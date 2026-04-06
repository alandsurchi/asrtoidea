import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../domain/models/ideas_dashboard_model.dart';
import '../../domain/models/project_card_model.dart';
import '../../domain/models/magic_idea_chat_model.dart';

class MockRepository {
  static List<IdeaCardModel> get mockIdeas => [
        IdeaCardModel(
          title: 'Landing Page\nfor Client',
          description:
              'This Idea give more attain to hire a new employ to see there position and play the tole',
          category: 'Design',
          priority: 'High',
          status: 'In Progress',
          backgroundImage: ImageConstant.imgRectangle29250x400,
          teamMembers: [
            TeamMemberModel(profileImage: ImageConstant.imgEllipse37),
            TeamMemberModel(profileImage: ImageConstant.imgEllipse38),
            TeamMemberModel(profileImage: ImageConstant.imgEllipse39),
          ],
          additionalMembersCount: '+3',
          timestamp: DateTime.now(),
        ),
        IdeaCardModel(
          title: 'Finance App Branding',
          description:
              'This Idea give more attain to hire a new employ to see there position and play the tole',
          category: 'Design',
          priority: 'High',
          status: 'In Progress',
          backgroundImage: ImageConstant.imgRectangle29250x400,
          teamMembers: [
            TeamMemberModel(profileImage: ImageConstant.imgEllipse37),
            TeamMemberModel(profileImage: ImageConstant.imgEllipse38),
            TeamMemberModel(profileImage: ImageConstant.imgEllipse39),
          ],
          additionalMembersCount: '+1',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        IdeaCardModel(
          title: 'Create UI/UX for Health App',
          description:
              'This Idea give more attain to hire a new employ to see there position and play the tole',
          category: 'Design',
          priority: 'Low',
          status: 'To-do',
          backgroundImage: ImageConstant.imgRectangle29250x400,
          teamMembers: [
            TeamMemberModel(profileImage: ImageConstant.imgEllipse37),
            TeamMemberModel(profileImage: ImageConstant.imgEllipse38),
          ],
          additionalMembersCount: '+2',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];

  static List<ProjectCardModel> get mockProjects => [
        ProjectCardModel(
          id: "p1",
          title: "Landing Page \nfor Client",
          description:
              "This Idea give more attain to hire a new employ to see there position and play the tole",
          backgroundImage: ImageConstant.imgRectangle29250x400,
          primaryChip: "Design",
          priorityChip: "High",
          avatarImages: [
            ImageConstant.imgEllipse37,
            ImageConstant.imgEllipse38,
            ImageConstant.imgEllipse39,
          ],
          teamCount: 3,
          statusText: "In Progress",
          statusIcon: ImageConstant.imgGroupAmber300,
          actionIcon: ImageConstant.imgGroupWhiteA700,
          isSaved: false,
          comments: [],
        ),
        ProjectCardModel(
          id: "p2",
          title: "Finance App Branding",
          description:
              "This Idea give more attain to hire a new employ to see there position and play the tole",
          backgroundImage: ImageConstant.imgRectangle29250x400,
          primaryChip: "Design",
          priorityChip: "High",
          avatarImages: [
            ImageConstant.imgEllipse37,
            ImageConstant.imgEllipse38,
            ImageConstant.imgEllipse39,
          ],
          teamCount: 1,
          statusText: "To-do",
          statusIcon: ImageConstant.imgGroupAmber300,
          actionIcon: ImageConstant.imgGroupWhiteA700,
          isSaved: false,
          comments: [],
        ),
      ];

  static List<MagicIdeaChatModel> get mockChats => [
        MagicIdeaChatModel(
          id: "ui_ux_chat",
          title: "Create UI/UX App",
          description: "Health App help passions to get more healthy food",
          status: "Thinking",
          statusColor: const Color(0xFFFBD060),
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        MagicIdeaChatModel(
          id: "business_idea_chat",
          title: "Create Business Idea",
          description: "create A bank to withdraw money and send money",
          status: "Done",
          statusColor: const Color(0xFF1DE4A2),
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
}
