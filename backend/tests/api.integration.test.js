process.env.NODE_ENV = 'test';
process.env.JWT_SECRET = process.env.JWT_SECRET || 'test-jwt-secret';

const request = require('supertest');
const { runMigrations } = require('../migrations/run');
const { pool } = require('../db');
const { app } = require('../server');

const BASE_PATH = '/api/v1';

async function resetDatabase() {
  await pool.query(
    `TRUNCATE TABLE
      entity_comment_likes,
      entity_comments,
      entity_likes,
      entity_views,
      projects,
      ideas,
      users
     RESTART IDENTITY CASCADE`
  );
}

async function createAuthenticatedUser(label) {
  const unique = `${Date.now()}_${Math.random().toString(36).slice(2, 8)}`;
  const email = `${label}_${unique}@testmail.com`;
  const password = 'Passw0rd!123';

  await request(app)
    .post(`${BASE_PATH}/auth/register`)
    .send({
      name: label,
      email,
      password,
    })
    .expect(201);

  const login = await request(app)
    .post(`${BASE_PATH}/auth/login`)
    .send({
      email,
      password,
    })
    .expect(200);

  return {
    token: login.body?.data?.token,
    userId: login.body?.data?.user?.id,
    email,
    password,
  };
}

function authHeader(token) {
  return { Authorization: `Bearer ${token}` };
}

describe('Backend API integration', () => {
  beforeAll(async () => {
    await runMigrations({ closePool: false });
  });

  beforeEach(async () => {
    await resetDatabase();
  });

  afterAll(async () => {
    await pool.end();
  });

  test('returns request id headers on health endpoint', async () => {
    const response = await request(app)
      .get(`${BASE_PATH}/health`)
      .expect(200);

    expect(response.body.success).toBe(true);
    expect(response.headers['x-request-id']).toBeTruthy();
  });

  test('keeps ideas private per account while projects remain globally visible', async () => {
    const accountA = await createAuthenticatedUser('Account A');
    const accountB = await createAuthenticatedUser('Account B');

    const ideaATitle = `Idea A ${Date.now()}`;
    const ideaBTitle = `Idea B ${Date.now()}`;

    await request(app)
      .post(`${BASE_PATH}/ideas`)
      .set(authHeader(accountA.token))
      .send({
        title: ideaATitle,
        description: 'Private idea A',
        category: 'General',
        priority: 'Medium',
        status: 'Generated',
      })
      .expect(201);

    await request(app)
      .post(`${BASE_PATH}/ideas`)
      .set(authHeader(accountB.token))
      .send({
        title: ideaBTitle,
        description: 'Private idea B',
        category: 'General',
        priority: 'Medium',
        status: 'Generated',
      })
      .expect(201);

    const projectATitle = `Project A ${Date.now()}`;
    const projectBTitle = `Project B ${Date.now()}`;

    await request(app)
      .post(`${BASE_PATH}/projects`)
      .set(authHeader(accountA.token))
      .send({
        title: projectATitle,
        description: 'Global project A',
        primaryChip: 'General',
        priorityChip: 'Medium',
        statusText: 'Generated',
      })
      .expect(201);

    await request(app)
      .post(`${BASE_PATH}/projects`)
      .set(authHeader(accountB.token))
      .send({
        title: projectBTitle,
        description: 'Global project B',
        primaryChip: 'General',
        priorityChip: 'Medium',
        statusText: 'Generated',
      })
      .expect(201);

    const ideasForA = await request(app)
      .get(`${BASE_PATH}/ideas`)
      .set(authHeader(accountA.token))
      .expect(200);

    const ideasForB = await request(app)
      .get(`${BASE_PATH}/ideas`)
      .set(authHeader(accountB.token))
      .expect(200);

    const titlesA = (ideasForA.body.data || []).map((idea) => idea.title);
    const titlesB = (ideasForB.body.data || []).map((idea) => idea.title);

    expect(titlesA).toContain(ideaATitle);
    expect(titlesA).not.toContain(ideaBTitle);
    expect(titlesB).toContain(ideaBTitle);
    expect(titlesB).not.toContain(ideaATitle);

    const projectsForA = await request(app)
      .get(`${BASE_PATH}/projects`)
      .set(authHeader(accountA.token))
      .expect(200);

    const projectsForB = await request(app)
      .get(`${BASE_PATH}/projects`)
      .set(authHeader(accountB.token))
      .expect(200);

    const projectTitlesA = (projectsForA.body.data || []).map((project) => project.title);
    const projectTitlesB = (projectsForB.body.data || []).map((project) => project.title);

    expect(projectTitlesA).toEqual(expect.arrayContaining([projectATitle, projectBTitle]));
    expect(projectTitlesB).toEqual(expect.arrayContaining([projectATitle, projectBTitle]));
  });

  test('persists linked publish entities and keeps project comment thread consistent', async () => {
    const account = await createAuthenticatedUser('Publisher');

    const createdIdea = await request(app)
      .post(`${BASE_PATH}/ideas`)
      .set(authHeader(account.token))
      .send({
        title: `Linked Idea ${Date.now()}`,
        description: 'Idea for linked publish test',
        category: 'General',
        priority: 'Medium',
        status: 'Generated',
      })
      .expect(201);

    const ideaId = createdIdea.body?.data?.id;
    expect(ideaId).toBeTruthy();

    const createdProject = await request(app)
      .post(`${BASE_PATH}/projects`)
      .set(authHeader(account.token))
      .send({
        title: `Linked Project ${Date.now()}`,
        description: 'Project for linked publish test',
        primaryChip: 'General',
        priorityChip: 'Medium',
        statusText: 'Generated',
        linkedIdeaId: ideaId,
      })
      .expect(201);

    const projectId = createdProject.body?.data?.id;
    expect(projectId).toBeTruthy();
    expect(createdProject.body?.data?.linkedIdeaId).toBe(ideaId);

    await request(app)
      .put(`${BASE_PATH}/ideas/${ideaId}`)
      .set(authHeader(account.token))
      .send({
        linkedProjectId: projectId,
      })
      .expect(200);

    const ideaDetail = await request(app)
      .get(`${BASE_PATH}/ideas/${ideaId}`)
      .set(authHeader(account.token))
      .expect(200);

    expect(ideaDetail.body?.data?.linkedProjectId).toBe(projectId);

    const addedComment = await request(app)
      .post(`${BASE_PATH}/projects/${projectId}/comments`)
      .set(authHeader(account.token))
      .send({
        content: 'Single canonical project thread',
      })
      .expect(201);

    const threadFromCommentsEndpoint = addedComment.body?.data || [];
    expect(threadFromCommentsEndpoint).toHaveLength(1);

    const detailResponse = await request(app)
      .get(`${BASE_PATH}/projects/${projectId}/detail`)
      .set(authHeader(account.token))
      .expect(200);

    const threadFromDetailEndpoint = detailResponse.body?.data?.comments || [];
    expect(threadFromDetailEndpoint).toHaveLength(1);
    expect(threadFromDetailEndpoint[0].id).toBe(threadFromCommentsEndpoint[0].id);
    expect(threadFromDetailEndpoint[0].content).toBe('Single canonical project thread');
  });
});
