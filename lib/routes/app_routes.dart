import 'package:flutter/material.dart';
import '../presentation/idea_generation_onboarding_screen/idea_generation_onboarding_screen.dart';
import '../presentation/welcome_onboarding_screen/welcome_onboarding_screen.dart';
import '../presentation/idea_creation_onboarding_screen/idea_creation_onboarding_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/welcome_screen/welcome_screen.dart';
import '../presentation/sign_up_screen/sign_up_screen.dart';
import '../presentation/magic_idea_chat_screen/magic_idea_chat_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/ideas_dashboard_screen/ideas_dashboard_screen.dart';
import '../presentation/project_explore_dashboard_screen/project_explore_dashboard_screen.dart';
import '../presentation/edit_profile_screen/edit_profile_screen.dart';
import '../presentation/notification_center_screen/notification_center_screen.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/main_shell_screen/main_shell_screen.dart';
import '../presentation/language_settings_screen/language_settings_screen.dart';
import '../presentation/premium_opening_animation/premium_opening_animation.dart';
import '../presentation/interactive_ideas_home/interactive_ideas_home.dart';
import '../presentation/idea_detail_view/idea_detail_view.dart';

class AppRoutes {
  // Onboarding flow
  static const String premiumOpeningAnimation = '/';
  static const String ideaGenerationOnboardingScreen =
      '/idea_generation_onboarding_screen';
  static const String welcomeOnboardingScreen = '/welcome_onboarding_screen';
  static const String ideaCreationOnboardingScreen =
      '/idea_creation_onboarding_screen';
  static const String welcomeScreen = '/welcome_screen';

  // Auth
  static const String loginScreen = '/login_screen';
  static const String signUpScreen = '/sign_up_screen';

  // Main app shell (post-auth)
  static const String mainShellScreen = '/main_shell_screen';

  // Individual tab screens (used inside shell)
  static const String ideasDashboardScreen = '/ideas_dashboard_screen';
  static const String projectExploreDashboardScreen =
      '/project_explore_dashboard_screen';
  static const String magicIdeaChatScreen = '/magic_idea_chat_screen';
  static const String settingsScreen = '/settings_screen';

  // Sub-screens
  static const String editProfileScreen = '/edit_profile_screen';
  static const String notificationCenterScreen = '/notification_center_screen';
  static const String languageSettingsScreen = '/language_settings_screen';
  static const String interactiveIdeasHome = '/interactive-ideas-home';
  static const String ideaDetailView = '/idea-detail-view';
    static const String standardIdeaDetailPrefix = '/idea-detail-view';
    static const String semanticIdeaPrefix = '/idea';
    static const String semanticProjectPrefix = '/project';
  static const String appNavigationScreen = '/app_navigation_screen';

  // Legacy aliases kept for backward compatibility
  static const String magicIdeaChatScreenInitialPage =
      '/magic_idea_chat_screen_initial_page';

  static const String initialRoute = '/';

    static String buildIdeaDetailPath(String id) {
        final safeId = Uri.encodeComponent(id.trim());
        return '$standardIdeaDetailPrefix/$safeId';
    }

    static String buildSemanticDetailPath(String entityType, String id) {
        if (entityType.toLowerCase().trim() == 'project') {
            final safeId = Uri.encodeComponent(id.trim());
            return '$semanticProjectPrefix/$safeId';
        }
        return buildIdeaDetailPath(id);
    }

    static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
        final name = settings.name ?? '';

        final uri = Uri.tryParse(name);
        final segments = uri?.pathSegments ?? const <String>[];
        if (segments.length >= 2) {
            final type = segments.first.toLowerCase();
            final id = segments[1].trim();

            if (id.isNotEmpty) {
                if (type == 'idea-detail-view' || type == 'idea') {
                    return MaterialPageRoute(
                        settings: RouteSettings(
                            name: ideaDetailView,
                            arguments: {
                                'entityType': 'idea',
                                'id': Uri.decodeComponent(id),
                            },
                        ),
                        builder: (context) => const IdeaDetailView(),
                    );
                }

                if (type == 'project') {
                    return MaterialPageRoute(
                        settings: RouteSettings(
                            name: ideaDetailView,
                            arguments: {
                                'entityType': 'project',
                                'id': Uri.decodeComponent(id),
                            },
                        ),
                        builder: (context) => const IdeaDetailView(),
                    );
                }
            }
        }

        return null;
    }

  static Map<String, WidgetBuilder> get routes => {
    premiumOpeningAnimation: (context) => const PremiumOpeningAnimation(),
    ideaGenerationOnboardingScreen: (context) =>
        IdeaGenerationOnboardingScreen(),
    welcomeOnboardingScreen: (context) => WelcomeOnboardingScreen(),
    ideaCreationOnboardingScreen: (context) => IdeaCreationOnboardingScreen(),
    welcomeScreen: (context) => WelcomeScreen(),
    loginScreen: (context) => LoginScreen(),
    signUpScreen: (context) => SignUpScreen(),
    mainShellScreen: (context) =>
        MainShellScreen(key: MainShellScreen.shellKey),
    ideasDashboardScreen: (context) => IdeasDashboardScreen(),
    projectExploreDashboardScreen: (context) => ProjectExploreDashboardScreen(),
    magicIdeaChatScreen: (context) => const MagicIdeaChatScreen(),
    magicIdeaChatScreenInitialPage: (context) => const MagicIdeaChatScreen(),
    settingsScreen: (context) => SettingsScreen(),
    editProfileScreen: (context) => EditProfileScreen(),
    notificationCenterScreen: (context) => NotificationCenterScreen(),
    languageSettingsScreen: (context) => const LanguageSettingsScreen(),
    interactiveIdeasHome: (context) => const InteractiveIdeasHome(),
    ideaDetailView: (context) => const IdeaDetailView(),
    appNavigationScreen: (context) => AppNavigationScreen(),
  };
}
