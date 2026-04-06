import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/idea_repository.dart';
import '../../domain/repositories/project_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../data/implementations/mock_idea_repository.dart';
import '../../data/implementations/mock_project_repository.dart';
import '../../data/implementations/mock_auth_repository.dart';
import '../../data/implementations/mock_ai_repository.dart';
import '../../data/network/api_client.dart';
import '../../data/implementations/api_project_repository.dart';
import '../../data/implementations/api_auth_repository.dart';
import '../../data/implementations/api_idea_repository.dart';

/// ─── Dependency Injection ────────────────────────────────────────────────────
///
/// All repository bindings live here. Notifiers read from these providers
/// and NEVER instantiate concrete classes directly.
///
/// To swap to a real backend:
///   1. Switch `apiClientProvider` from `MockApiClient` to `HttpApiClient`.
///   2. Switch the respective repository providers below.
///   For example, replace `MockIdeaRepository()` with `ApiIdeaRepository(ref.read(apiClientProvider))`.
///   Zero UI code needs to change.
/// ─────────────────────────────────────────────────────────────────────────────

/// Provides the [ApiClient] implementation currently in use.
/// Switch this to `HttpApiClient()` mapped to the production URL when ready.
final apiClientProvider = Provider<ApiClient>(
  (ref) => HttpApiClient(),
);

/// Provides the [IdeaRepository] implementation currently in use.
final ideaRepositoryProvider = Provider<IdeaRepository>(
  (ref) => ApiIdeaRepository(ref.read(apiClientProvider)),
);

/// Provides the [ProjectRepository] implementation currently in use.
final projectRepositoryProvider = Provider<ProjectRepository>(
  (ref) => ApiProjectRepository(ref.read(apiClientProvider)),
);

/// Provides the [AuthRepository] implementation currently in use.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => ApiAuthRepository(ref.read(apiClientProvider)),
);

/// Provides the [AiRepository] implementation currently in use.
final aiRepositoryProvider = Provider<AiRepository>(
  (ref) => MockAiRepository(),
);
