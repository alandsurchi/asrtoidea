import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  static const delegate = _AppLocalizationsDelegate();
  static const localizationsDelegates = [delegate];

  static final List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
    Locale('ku'),
  ];

  String _t(String key) =>
      _localizedValues[locale.languageCode]?[key] ??
      _localizedValues['en']![key] ??
      key;

  // Language meta
  String get language => _t('language');
  String get languageNameEn => _t('languageNameEn');
  String get languageNameAr => _t('languageNameAr');
  String get languageNameKu => _t('languageNameKu');

  // Settings screen
  String get settingsTitle => _t('settingsTitle');
  String get settingsGeneral => _t('settingsGeneral');
  String get settingsAlerts => _t('settingsAlerts');
  String get settingsSupport => _t('settingsSupport');
  String get settingsAccount => _t('settingsAccount');
  String get settingsLanguage => _t('settingsLanguage');
  String get settingsBilling => _t('settingsBilling');
    String get settingsFavoritesHub => _t('settingsFavoritesHub');
    String get settingsMyPosts => _t('settingsMyPosts');
  String get settingsDarkMode => _t('settingsDarkMode');
  String get settingsSecurity => _t('settingsSecurity');
  String get settingsReminders => _t('settingsReminders');
  String get settingsHelpSupport => _t('settingsHelpSupport');
  String get settingsRateApp => _t('settingsRateApp');
  String get settingsLogOut => _t('settingsLogOut');
  String get settingsUpgradePlan => _t('settingsUpgradePlan');
  String get settingsUpgradePlanDesc => _t('settingsUpgradePlanDesc');
  String get settingsBuyNow => _t('settingsBuyNow');

  // Language screen
  String get languageSectionTitle => _t('languageSectionTitle');
  String get languageSectionSubtitle => _t('languageSectionSubtitle');
  String get languageSelectLabel => _t('languageSelectLabel');

  // Bottom nav
  String get navHome => _t('navHome');
  String get navExplore => _t('navExplore');
  String get navStats => _t('navStats');
  String get navProfile => _t('navProfile');

  // Home / Dashboard
  String get welcomeBack => _t('welcomeBack');
  String get ideasForToday => _t('ideasForToday');
  String get search => _t('search');
  String get filter => _t('filter');
  String get recentIdeas => _t('recentIdeas');
  String get seeAll => _t('seeAll');
  String get inProgress => _t('inProgress');
  String get toDo => _t('toDo');
  String get completed => _t('completed');
  String get generated => _t('generated');
  String get filterIdeas => _t('filterIdeas');
  String get status => _t('status');
  String get priority => _t('priority');
  String get applyFilters => _t('applyFilters');
  String get all => _t('all');
  String get high => _t('high');
  String get medium => _t('medium');
  String get low => _t('low');

  // Stats page
  String get statistics => _t('statistics');
  String get totalIdeas => _t('totalIdeas');
  String get completedIdeas => _t('completedIdeas');
  String get inProgressIdeas => _t('inProgressIdeas');
  String get aiGenerated => _t('aiGenerated');
  String get monthlyProgress => _t('monthlyProgress');
  String get design => _t('design');
  String get development => _t('development');
  String get marketing => _t('marketing');
  String get research => _t('research');
  String get recentActivity => _t('recentActivity');
  String get newIdeaCreated => _t('newIdeaCreated');
  String get ideaCompleted => _t('ideaCompleted');
  String get aiGeneratedIdea => _t('aiGeneratedIdea');
  String get teamMemberAdded => _t('teamMemberAdded');

  // Explore screen
  String get explore => _t('explore');
  String get editOptions => _t('editOptions');
  String get editProjectName => _t('editProjectName');
  String get editDescription => _t('editDescription');
  String get editTags => _t('editTags');
  String get deleteProject => _t('deleteProject');
  String get deleteConfirm => _t('deleteConfirm');
  String get cancel => _t('cancel');
  String get delete => _t('delete');
  String get filterProjects => _t('filterProjects');
  String get sortBy => _t('sortBy');
  String get newest => _t('newest');
  String get oldest => _t('oldest');
  String get aToZ => _t('aToZ');
  String get projectActions => _t('projectActions');
  String get viewDetails => _t('viewDetails');
  String get shareProject => _t('shareProject');
  String get saveToFavorites => _t('saveToFavorites');
  String get removeProject => _t('removeProject');

  // AI Chat screen
  String get magicIdea => _t('magicIdea');
  String get newChat => _t('newChat');
  String get whatIdeaToday => _t('whatIdeaToday');
  String get chatHint => _t('chatHint');
  String get chooseAiModel => _t('chooseAiModel');
  String get chooseAiModelDesc => _t('chooseAiModelDesc');
  String get previousChats => _t('previousChats');
  String get geminiDesc => _t('geminiDesc');
  String get gpt4Desc => _t('gpt4Desc');
  String get claudeDesc => _t('claudeDesc');
  String get perplexityDesc => _t('perplexityDesc');

  // Notifications
  String get notification => _t('notification');
  String get today => _t('today');
  String get yesterday => _t('yesterday');

  // Edit Profile
  String get editProfile => _t('editProfile');
  String get fullName => _t('fullName');
  String get nickName => _t('nickName');
  String get email => _t('email');
  String get phone => _t('phone');
  String get address => _t('address');
  String get job => _t('job');
  String get saveProfile => _t('saveProfile');
  String get profileUpdated => _t('profileUpdated');

  // Welcome / Auth screens
  String get welcome => _t('welcome');
  String get welcomeDesc => _t('welcomeDesc');
  String get signIn => _t('signIn');
  String get signUp => _t('signUp');
  String get welcomeBack2 => _t('welcomeBack2');
  String get welcomeBackDesc => _t('welcomeBackDesc');
  String get username => _t('username');
  String get password => _t('password');
  String get forgotPassword => _t('forgotPassword');
  String get getStartedFree => _t('getStartedFree');
  String get noCardNeeded => _t('noCardNeeded');
  String get emailAddress => _t('emailAddress');
  String get name => _t('name');
  String get alreadyHaveAccount => _t('alreadyHaveAccount');
  String get dontHaveAccount => _t('dontHaveAccount');
  String get orContinueWith => _t('orContinueWith');
  String get continueWithGoogle => _t('continueWithGoogle');
  String get continueWithApple => _t('continueWithApple');
  String get signUpSuccess => _t('signUpSuccess');

  // Onboarding
  String get onboardingTitle1 => _t('onboardingTitle1');
  String get onboardingDesc1 => _t('onboardingDesc1');
  String get onboardingTitle2 => _t('onboardingTitle2');
  String get onboardingDesc2 => _t('onboardingDesc2');
  String get onboardingTitle3 => _t('onboardingTitle3');
  String get onboardingDesc3 => _t('onboardingDesc3');
  String get next => _t('next');
  String get skip => _t('skip');
  String get getStarted => _t('getStarted');

  // Idea Detail
  String get ideaDetail => _t('ideaDetail');
  String get comments => _t('comments');
  String get attachments => _t('attachments');
  String get teamMembers => _t('teamMembers');
  String get addComment => _t('addComment');
  String get like => _t('like');
  String get share => _t('share');
  String get save => _t('save');

  // Dialogs / common
  String get confirm => _t('confirm');
  String get yes => _t('yes');
  String get no => _t('no');
  String get close => _t('close');
  String get apply => _t('apply');
  String get logoutConfirmTitle => _t('logoutConfirmTitle');
  String get logoutConfirmDesc => _t('logoutConfirmDesc');
  String get logout => _t('logout');
  String get comingSoon => _t('comingSoon');
  String get filtered => _t('filtered');
  String get sortedBy => _t('sortedBy');
  String get projectDeleted => _t('projectDeleted');
  String get savedToFavorites => _t('savedToFavorites');
  String get projectRemoved => _t('projectRemoved');
  String get shareComingSoon => _t('shareComingSoon');
  String get editComingSoon => _t('editComingSoon');

  // Security / Billing dialogs
  String get securityTitle => _t('securityTitle');
  String get securityDesc => _t('securityDesc');
  String get billingTitle => _t('billingTitle');
  String get billingDesc => _t('billingDesc');
    String get favoritesHubTitle => _t('favoritesHubTitle');
    String get favoritesHubSubtitle => _t('favoritesHubSubtitle');
    String get myPostsTitle => _t('myPostsTitle');
    String get myPostsSubtitle => _t('myPostsSubtitle');
    String get savedPosts => _t('savedPosts');
    String get likedPosts => _t('likedPosts');
    String get noSavedPosts => _t('noSavedPosts');
    String get noLikedPosts => _t('noLikedPosts');
    String get noMyPosts => _t('noMyPosts');
    String get profileLoadHint => _t('profileLoadHint');
    String get removeSaved => _t('removeSaved');
    String get openPost => _t('openPost');
  String get remindersTitle => _t('remindersTitle');
  String get remindersDesc => _t('remindersDesc');
  String get upgradePlanTitle => _t('upgradePlanTitle');
  String get upgradePlanDesc2 => _t('upgradePlanDesc2');
  String get upgradePlanMonthly => _t('upgradePlanMonthly');
  String get upgradePlanYearly => _t('upgradePlanYearly');
  String get upgradePlanFeature1 => _t('upgradePlanFeature1');
  String get upgradePlanFeature2 => _t('upgradePlanFeature2');
  String get upgradePlanFeature3 => _t('upgradePlanFeature3');

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'language': 'Language',
      'languageNameEn': 'English',
      'languageNameAr': 'Arabic (عربي)',
      'languageNameKu': 'Kurdish (کوردی)',
      // Settings
      'settingsTitle': 'Settings',
      'settingsGeneral': 'General',
      'settingsAlerts': 'Alerts',
      'settingsSupport': 'Support',
      'settingsAccount': 'Account',
      'settingsLanguage': 'Language',
      'settingsBilling': 'Billing & Subscriptions',
    'settingsFavoritesHub': 'Saved & Liked Posts',
    'settingsMyPosts': 'My Posts',
      'settingsDarkMode': 'Dark Mode',
      'settingsSecurity': 'Security',
      'settingsReminders': 'Reminders',
      'settingsHelpSupport': 'Help & Support',
      'settingsRateApp': 'Rate App',
      'settingsLogOut': 'Log Out',
      'settingsUpgradePlan': 'Upgrade Your Plan',
      'settingsUpgradePlanDesc':
          'Get Advantage of Pro Plan, Get Fully\nAccess AI Models and More',
      'settingsBuyNow': 'Buy Now',
      // Language screen
      'languageSectionTitle': 'Language',
      'languageSectionSubtitle': 'Select your preferred language',
      'languageSelectLabel': 'App Language',
      // Nav
      'navHome': 'Home',
      'navExplore': 'Explore',
      'navStats': 'Stats',
      'navProfile': 'Profile',
      // Home
      'welcomeBack': 'Welcome back',
      'ideasForToday': 'Ideas for today',
      'search': 'Search',
      'filter': 'Filter',
      'recentIdeas': 'Recent Ideas',
      'seeAll': 'See all',
      'inProgress': 'In progress',
      'toDo': 'To-do',
      'completed': 'Completed',
      'generated': 'Generated',
      'filterIdeas': 'Filter Ideas',
      'status': 'Status',
      'priority': 'Priority',
      'applyFilters': 'Apply Filters',
      'all': 'All',
      'high': 'High',
      'medium': 'Medium',
      'low': 'Low',
      // Stats
      'statistics': 'Statistics',
      'totalIdeas': 'Total Ideas',
      'completedIdeas': 'Completed',
      'inProgressIdeas': 'In Progress',
      'aiGenerated': 'AI Generated',
      'monthlyProgress': 'Monthly Progress',
      'design': 'Design',
      'development': 'Development',
      'marketing': 'Marketing',
      'research': 'Research',
      'recentActivity': 'Recent Activity',
      'newIdeaCreated': 'New idea created',
      'ideaCompleted': 'Idea completed',
      'aiGeneratedIdea': 'AI generated idea',
      'teamMemberAdded': 'Team member added',
      // Explore
      'explore': 'Explore',
      'editOptions': 'Edit Options',
      'editProjectName': 'Edit Project Name',
      'editDescription': 'Edit Description',
      'editTags': 'Edit Tags',
      'deleteProject': 'Delete Project',
      'deleteConfirm':
          'Are you sure you want to delete this project? This action cannot be undone.',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'filterProjects': 'Filter Projects',
      'sortBy': 'Sort By',
      'newest': 'Newest',
      'oldest': 'Oldest',
      'aToZ': 'A-Z',
      'projectActions': 'Project Actions',
      'viewDetails': 'View Details',
      'shareProject': 'Share Project',
      'saveToFavorites': 'Save to Favorites',
      'removeProject': 'Remove Project',
      // AI Chat
      'magicIdea': 'Magic Idea',
      'newChat': 'New Chat',
      'whatIdeaToday': 'What idea will you\ncreate today?',
      'chatHint': "Start with a word, and let's design something amazing...",
      'chooseAiModel': 'Choose AI Model',
      'chooseAiModelDesc': 'Select the AI model to generate your ideas',
      'previousChats': 'Previous Chats',
      'geminiDesc': "Google's multimodal AI model",
      'gpt4Desc': "OpenAI's most capable model",
      'claudeDesc': "Anthropic's helpful AI assistant",
      'perplexityDesc': 'AI with real-time web search',
      // Notifications
      'notification': 'Notification',
      'today': 'Today',
      'yesterday': 'Yesterday',
      // Edit Profile
      'editProfile': 'Edit Profile',
      'fullName': 'Full Name',
      'nickName': 'Nick Name',
      'email': 'Email',
      'phone': 'Phone',
      'address': 'Address',
      'job': 'Job',
      'saveProfile': 'Save Profile',
      'profileUpdated': 'Profile updated successfully',
      // Welcome / Auth
      'welcome': 'Welcome =)',
      'welcomeDesc':
          "Hi there!\nwe're pleasure to see you to generate your Idea By using AI",
      'signIn': 'Sign In',
      'signUp': 'Sign Up',
      'welcomeBack2': 'Welcome Back!',
      'welcomeBackDesc': 'welcome back we missed you',
      'username': 'Username',
      'password': 'Password',
      'forgotPassword': 'Forgot Password?',
      'getStartedFree': 'Get Started Free',
      'noCardNeeded': 'Free Forever. No Credit Card Needed',
      'emailAddress': 'Email Address',
      'name': 'Name',
      'alreadyHaveAccount': 'Already have an account? Sign In',
      'dontHaveAccount': "Don't have an account? Sign Up",
      'orContinueWith': 'Or continue with',
      'continueWithGoogle': 'Continue with Google',
      'continueWithApple': 'Continue with Apple',
      'signUpSuccess': 'Sign up successful!',
      // Onboarding
      'onboardingTitle1': 'Wanna start one ?',
      'onboardingDesc1':
          'try to get Our idea using AI to enhance your productivity',
      'onboardingTitle2': 'Generate Ideas',
      'onboardingDesc2': 'Use AI to generate creative ideas for your projects',
      'onboardingTitle3': 'Track Progress',
      'onboardingDesc3': 'Monitor and manage all your ideas in one place',
      'next': 'Next',
      'skip': 'Skip',
      'getStarted': 'Get Started',
      // Idea Detail
      'ideaDetail': 'Idea Detail',
      'comments': 'Comments',
      'attachments': 'Attachments',
      'teamMembers': 'Team Members',
      'addComment': 'Add a comment...',
      'like': 'Like',
      'share': 'Share',
      'save': 'Save',
      // Common
      'confirm': 'Confirm',
      'yes': 'Yes',
      'no': 'No',
      'close': 'Close',
      'apply': 'Apply',
      'logoutConfirmTitle': 'Log Out',
      'logoutConfirmDesc': 'Are you sure you want to log out?',
      'logout': 'Log Out',
      'comingSoon': 'Coming soon',
      'filtered': 'Filtered',
      'sortedBy': 'Sorted by',
      'projectDeleted': 'Project deleted',
      'savedToFavorites': 'Saved to favorites!',
      'projectRemoved': 'Project removed',
      'shareComingSoon': 'Share feature coming soon',
      'editComingSoon': 'Edit coming soon',
      // Security / Billing
      'securityTitle': 'Security Settings',
      'securityDesc':
          'Manage your password, two-factor authentication, and security preferences.',
      'billingTitle': 'Billing & Subscriptions',
      'billingDesc': 'Manage your subscription plan and payment methods.',
    'favoritesHubTitle': 'Favorites Hub',
    'favoritesHubSubtitle': 'Your saved and liked posts in one place',
    'myPostsTitle': 'My Posts',
    'myPostsSubtitle': 'All posts you published',
    'savedPosts': 'Saved',
    'likedPosts': 'Liked',
    'noSavedPosts': 'You have no saved posts yet.',
    'noLikedPosts': 'You have no liked posts yet.',
    'noMyPosts': 'You have not created any posts yet.',
    'profileLoadHint': 'Profile is still loading. Pull to refresh and try again.',
    'removeSaved': 'Remove Save',
    'openPost': 'Open Post',
      'remindersTitle': 'Reminders',
      'remindersDesc':
          'Set up daily reminders to keep track of your ideas and tasks.',
      'upgradePlanTitle': 'Upgrade to Pro',
      'upgradePlanDesc2':
          'Unlock unlimited AI generations, advanced analytics, and priority support.',
      'upgradePlanMonthly': '\$9.99/month',
      'upgradePlanYearly': '\$79.99/year (Save 33%)',
      'upgradePlanFeature1': 'Unlimited AI idea generation',
      'upgradePlanFeature2': 'Advanced analytics & insights',
      'upgradePlanFeature3': 'Priority customer support',
    },
    'ar': {
      'language': 'اللغة',
      'languageNameEn': 'English',
      'languageNameAr': 'عربي',
      'languageNameKu': 'کوردی',
      // Settings
      'settingsTitle': 'الإعدادات',
      'settingsGeneral': 'عام',
      'settingsAlerts': 'التنبيهات',
      'settingsSupport': 'الدعم',
      'settingsAccount': 'الحساب',
      'settingsLanguage': 'اللغة',
      'settingsBilling': 'الفواتير والاشتراكات',
      'settingsDarkMode': 'الوضع الداكن',
      'settingsSecurity': 'الأمان',
      'settingsReminders': 'التذكيرات',
      'settingsHelpSupport': 'المساعدة والدعم',
      'settingsRateApp': 'تقييم التطبيق',
      'settingsLogOut': 'تسجيل الخروج',
      'settingsUpgradePlan': 'ترقية خطتك',
      'settingsUpgradePlanDesc':
          'استفد من الخطة الاحترافية، احصل على\nوصول كامل لنماذج الذكاء الاصطناعي والمزيد',
      'settingsBuyNow': 'اشتر الآن',
      // Language screen
      'languageSectionTitle': 'اللغة',
      'languageSectionSubtitle': 'اختر لغتك المفضلة',
      'languageSelectLabel': 'لغة التطبيق',
      // Nav
      'navHome': 'الرئيسية',
      'navExplore': 'استكشاف',
      'navStats': 'الإحصاءات',
      'navProfile': 'الملف الشخصي',
      // Home
      'welcomeBack': 'مرحباً بعودتك',
      'ideasForToday': 'أفكار لهذا اليوم',
      'search': 'بحث',
      'filter': 'تصفية',
      'recentIdeas': 'الأفكار الأخيرة',
      'seeAll': 'عرض الكل',
      'inProgress': 'قيد التنفيذ',
      'toDo': 'للقيام به',
      'completed': 'مكتمل',
      'generated': 'مُولَّد',
      'filterIdeas': 'تصفية الأفكار',
      'status': 'الحالة',
      'priority': 'الأولوية',
      'applyFilters': 'تطبيق الفلاتر',
      'all': 'الكل',
      'high': 'عالية',
      'medium': 'متوسطة',
      'low': 'منخفضة',
      // Stats
      'statistics': 'الإحصاءات',
      'totalIdeas': 'إجمالي الأفكار',
      'completedIdeas': 'مكتملة',
      'inProgressIdeas': 'قيد التنفيذ',
      'aiGenerated': 'مُولَّد بالذكاء الاصطناعي',
      'monthlyProgress': 'التقدم الشهري',
      'design': 'التصميم',
      'development': 'التطوير',
      'marketing': 'التسويق',
      'research': 'البحث',
      'recentActivity': 'النشاط الأخير',
      'newIdeaCreated': 'تم إنشاء فكرة جديدة',
      'ideaCompleted': 'تم إكمال الفكرة',
      'aiGeneratedIdea': 'فكرة مُولَّدة بالذكاء الاصطناعي',
      'teamMemberAdded': 'تمت إضافة عضو في الفريق',
      // Explore
      'explore': 'استكشاف',
      'editOptions': 'خيارات التعديل',
      'editProjectName': 'تعديل اسم المشروع',
      'editDescription': 'تعديل الوصف',
      'editTags': 'تعديل العلامات',
      'deleteProject': 'حذف المشروع',
      'deleteConfirm':
          'هل أنت متأكد أنك تريد حذف هذا المشروع؟ لا يمكن التراجع عن هذا الإجراء.',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'filterProjects': 'تصفية المشاريع',
      'sortBy': 'ترتيب حسب',
      'newest': 'الأحدث',
      'oldest': 'الأقدم',
      'aToZ': 'أ-ي',
      'projectActions': 'إجراءات المشروع',
      'viewDetails': 'عرض التفاصيل',
      'shareProject': 'مشاركة المشروع',
      'saveToFavorites': 'حفظ في المفضلة',
      'removeProject': 'إزالة المشروع',
      // AI Chat
      'magicIdea': 'الفكرة السحرية',
      'newChat': 'محادثة جديدة',
      'whatIdeaToday': 'ما الفكرة التي\nستنشئها اليوم؟',
      'chatHint': 'ابدأ بكلمة، ودعنا نصمم شيئاً رائعاً...',
      'chooseAiModel': 'اختر نموذج الذكاء الاصطناعي',
      'chooseAiModelDesc': 'اختر نموذج الذكاء الاصطناعي لتوليد أفكارك',
      'previousChats': 'المحادثات السابقة',
      'geminiDesc': 'نموذج الذكاء الاصطناعي متعدد الوسائط من Google',
      'gpt4Desc': 'أقوى نماذج OpenAI',
      'claudeDesc': 'مساعد الذكاء الاصطناعي المفيد من Anthropic',
      'perplexityDesc': 'ذكاء اصطناعي مع بحث ويب في الوقت الفعلي',
      // Notifications
      'notification': 'الإشعارات',
      'today': 'اليوم',
      'yesterday': 'أمس',
      // Edit Profile
      'editProfile': 'تعديل الملف الشخصي',
      'fullName': 'الاسم الكامل',
      'nickName': 'الاسم المستعار',
      'email': 'البريد الإلكتروني',
      'phone': 'الهاتف',
      'address': 'العنوان',
      'job': 'الوظيفة',
      'saveProfile': 'حفظ الملف الشخصي',
      'profileUpdated': 'تم تحديث الملف الشخصي بنجاح',
      // Welcome / Auth
      'welcome': 'مرحباً =)',
      'welcomeDesc':
          'مرحباً!\nيسعدنا رؤيتك لتوليد أفكارك باستخدام الذكاء الاصطناعي',
      'signIn': 'تسجيل الدخول',
      'signUp': 'إنشاء حساب',
      'welcomeBack2': 'مرحباً بعودتك!',
      'welcomeBackDesc': 'مرحباً بعودتك، لقد اشتقنا إليك',
      'username': 'اسم المستخدم',
      'password': 'كلمة المرور',
      'forgotPassword': 'نسيت كلمة المرور؟',
      'getStartedFree': 'ابدأ مجاناً',
      'noCardNeeded': 'مجاني للأبد. لا حاجة لبطاقة ائتمان',
      'emailAddress': 'عنوان البريد الإلكتروني',
      'name': 'الاسم',
      'alreadyHaveAccount': 'لديك حساب بالفعل؟ تسجيل الدخول',
      'dontHaveAccount': 'ليس لديك حساب؟ إنشاء حساب',
      'orContinueWith': 'أو تابع مع',
      'continueWithGoogle': 'تابع مع Google',
      'continueWithApple': 'تابع مع Apple',
      'signUpSuccess': 'تم إنشاء الحساب بنجاح!',
      // Onboarding
      'onboardingTitle1': 'هل تريد البدء؟',
      'onboardingDesc1':
          'احصل على أفكارنا باستخدام الذكاء الاصطناعي لتعزيز إنتاجيتك',
      'onboardingTitle2': 'توليد الأفكار',
      'onboardingDesc2':
          'استخدم الذكاء الاصطناعي لتوليد أفكار إبداعية لمشاريعك',
      'onboardingTitle3': 'تتبع التقدم',
      'onboardingDesc3': 'راقب وأدر جميع أفكارك في مكان واحد',
      'next': 'التالي',
      'skip': 'تخطي',
      'getStarted': 'ابدأ الآن',
      // Idea Detail
      'ideaDetail': 'تفاصيل الفكرة',
      'comments': 'التعليقات',
      'attachments': 'المرفقات',
      'teamMembers': 'أعضاء الفريق',
      'addComment': 'أضف تعليقاً...',
      'like': 'إعجاب',
      'share': 'مشاركة',
      'save': 'حفظ',
      // Common
      'confirm': 'تأكيد',
      'yes': 'نعم',
      'no': 'لا',
      'close': 'إغلاق',
      'apply': 'تطبيق',
      'logoutConfirmTitle': 'تسجيل الخروج',
      'logoutConfirmDesc': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
      'logout': 'تسجيل الخروج',
      'comingSoon': 'قريباً',
      'filtered': 'تمت التصفية',
      'sortedBy': 'مرتب حسب',
      'projectDeleted': 'تم حذف المشروع',
      'savedToFavorites': 'تم الحفظ في المفضلة!',
      'projectRemoved': 'تم إزالة المشروع',
      'shareComingSoon': 'ميزة المشاركة قريباً',
      'editComingSoon': 'التعديل قريباً',
      // Security / Billing
      'securityTitle': 'إعدادات الأمان',
      'securityDesc': 'إدارة كلمة المرور والمصادقة الثنائية وتفضيلات الأمان.',
      'billingTitle': 'الفواتير والاشتراكات',
      'billingDesc': 'إدارة خطة اشتراكك وطرق الدفع.',
      'remindersTitle': 'التذكيرات',
      'remindersDesc': 'اضبط تذكيرات يومية لمتابعة أفكارك ومهامك.',
      'upgradePlanTitle': 'الترقية إلى Pro',
      'upgradePlanDesc2':
          'افتح توليدات ذكاء اصطناعي غير محدودة وتحليلات متقدمة ودعماً ذا أولوية.',
      'upgradePlanMonthly': '9.99\$/شهر',
      'upgradePlanYearly': '79.99\$/سنة (وفر 33%)',
      'upgradePlanFeature1': 'توليد أفكار ذكاء اصطناعي غير محدود',
      'upgradePlanFeature2': 'تحليلات ورؤى متقدمة',
      'upgradePlanFeature3': 'دعم عملاء ذو أولوية',
    },
    'ku': {
      'language': 'زمان',
      'languageNameEn': 'English',
      'languageNameAr': 'عربي',
      'languageNameKu': 'کوردی',
      // Settings
      'settingsTitle': 'ڕێکخستنەکان',
      'settingsGeneral': 'گشتی',
      'settingsAlerts': 'ئاگادارکردنەوەکان',
      'settingsSupport': 'پشتگیری',
      'settingsAccount': 'ئەکاونت',
      'settingsLanguage': 'زمان',
      'settingsBilling': 'پارەدان و بەشداریکردن',
      'settingsDarkMode': 'دۆخی تاریک',
      'settingsSecurity': 'ئەمنیەت',
      'settingsReminders': 'بیرخستنەوەکان',
      'settingsHelpSupport': 'یارمەتی و پشتگیری',
      'settingsRateApp': 'نرخاندنی ئەپ',
      'settingsLogOut': 'چوونەدەرەوە',
      'settingsUpgradePlan': 'پلانەکەت بەرزبکەرەوە',
      'settingsUpgradePlanDesc':
          'سوودی پلانی پرۆ وەربگرە، دەستگەیشتنی تەواو\nبە مۆدێلەکانی زیرەکی دەستکرد و زیاتر',
      'settingsBuyNow': 'ئێستا بکڕە',
      // Language screen
      'languageSectionTitle': 'زمان',
      'languageSectionSubtitle': 'زمانی دڵخوازت هەڵبژێرە',
      'languageSelectLabel': 'زمانی ئەپ',
      // Nav
      'navHome': 'ماڵەوە',
      'navExplore': 'گەڕان',
      'navStats': 'ئامارەکان',
      'navProfile': 'پرۆفایل',
      // Home
      'welcomeBack': 'بەخێربێیتەوە',
      'ideasForToday': 'بیرۆکەکان بۆ ئەمڕۆ',
      'search': 'گەڕان',
      'filter': 'فلتەر',
      'recentIdeas': 'بیرۆکەی نوێ',
      'seeAll': 'هەمووی ببینە',
      'inProgress': 'لە کارکردندایە',
      'toDo': 'دەبێت بیکرێت',
      'completed': 'تەواوبووە',
      'generated': 'دروستکراوە',
      'filterIdeas': 'فلتەرکردنی بیرۆکەکان',
      'status': 'دۆخ',
      'priority': 'پێشینە',
      'applyFilters': 'فلتەرەکان جێبەجێبکە',
      'all': 'هەمووی',
      'high': 'بەرز',
      'medium': 'مامناوەند',
      'low': 'نزم',
      // Stats
      'statistics': 'ئامارەکان',
      'totalIdeas': 'کۆی بیرۆکەکان',
      'completedIdeas': 'تەواوبووەکان',
      'inProgressIdeas': 'لە کارکردندایە',
      'aiGenerated': 'دروستکراوی زیرەکی دەستکرد',
      'monthlyProgress': 'پێشکەوتنی مانگانە',
      'design': 'دیزاین',
      'development': 'گەشەپێدان',
      'marketing': 'بازاڕکاری',
      'research': 'توێژینەوە',
      'recentActivity': 'چالاکیی نوێ',
      'newIdeaCreated': 'بیرۆکەی نوێ دروستکرا',
      'ideaCompleted': 'بیرۆکە تەواوبوو',
      'aiGeneratedIdea': 'بیرۆکەی دروستکراوی زیرەکی دەستکرد',
      'teamMemberAdded': 'ئەندامی تیم زیادکرا',
      // Explore
      'explore': 'گەڕان',
      'editOptions': 'هەڵبژاردنەکانی دەستکاری',
      'editProjectName': 'دەستکاریکردنی ناوی پرۆژە',
      'editDescription': 'دەستکاریکردنی وەسف',
      'editTags': 'دەستکاریکردنی تاگەکان',
      'deleteProject': 'سڕینەوەی پرۆژە',
      'deleteConfirm':
          'دڵنیایت دەتەوێت ئەم پرۆژەیە بسڕیتەوە؟ ئەم کارە ناگەڕێتەوە.',
      'cancel': 'هەڵوەشاندنەوە',
      'delete': 'سڕینەوە',
      'filterProjects': 'فلتەرکردنی پرۆژەکان',
      'sortBy': 'ڕیزکردن بەپێی',
      'newest': 'نوێترین',
      'oldest': 'کۆنترین',
      'aToZ': 'ئەلف-یا',
      'projectActions': 'کردارەکانی پرۆژە',
      'viewDetails': 'بینینی وردەکاریەکان',
      'shareProject': 'هاوبەشکردنی پرۆژە',
      'saveToFavorites': 'پاراستن لە دڵخوازەکان',
      'removeProject': 'لابردنی پرۆژە',
      // AI Chat
      'magicIdea': 'بیرۆکەی سیحری',
      'newChat': 'چاتی نوێ',
      'whatIdeaToday': 'چ بیرۆکەیەک\nئەمڕۆ دروست دەکەیت؟',
      'chatHint': 'بە وشەیەک دەست پێبکە، با شتێکی سەرسوڕمان دیزاین بکەین...',
      'chooseAiModel': 'مۆدێلی زیرەکی دەستکرد هەڵبژێرە',
      'chooseAiModelDesc':
          'مۆدێلی زیرەکی دەستکرد هەڵبژێرە بۆ دروستکردنی بیرۆکەکانت',
      'previousChats': 'چاتە پێشووەکان',
      'geminiDesc': 'مۆدێلی زیرەکی دەستکردی گشتوگشتی Google',
      'gpt4Desc': 'بەتوانترین مۆدێلی OpenAI',
      'claudeDesc': 'یاریدەدەری زیرەکی دەستکردی Anthropic',
      'perplexityDesc': 'زیرەکی دەستکرد لەگەڵ گەڕانی ئینتەرنێتی ئێستا',
      // Notifications
      'notification': 'ئاگادارکردنەوەکان',
      'today': 'ئەمڕۆ',
      'yesterday': 'دوێنێ',
      // Edit Profile
      'editProfile': 'دەستکاریکردنی پرۆفایل',
      'fullName': 'ناوی تەواو',
      'nickName': 'ناوی تایبەت',
      'email': 'ئیمەیل',
      'phone': 'تەلەفۆن',
      'address': 'ناونیشان',
      'job': 'کار',
      'saveProfile': 'پاراستنی پرۆفایل',
      'profileUpdated': 'پرۆفایل بە سەرکەوتوویی نوێکرایەوە',
      // Welcome / Auth
      'welcome': 'بەخێربێی =)',
      'welcomeDesc':
          'سڵاو!\nخۆشحاڵین تۆت دەبینین بۆ دروستکردنی بیرۆکەکانت بە زیرەکی دەستکرد',
      'signIn': 'چوونەژوورەوە',
      'signUp': 'تۆمارکردن',
      'welcomeBack2': 'بەخێربێیتەوە!',
      'welcomeBackDesc': 'بەخێربێیتەوە، خەمانت کێشا',
      'username': 'ناوی بەکارهێنەر',
      'password': 'وشەی نهێنی',
      'forgotPassword': 'وشەی نهێنیت بیرچووەتەوە؟',
      'getStartedFree': 'بەخۆڕایی دەست پێبکە',
      'noCardNeeded': 'بۆ هەمیشە خۆڕایی. پێویستی بە کارتی کرێدیت نییە',
      'emailAddress': 'ناونیشانی ئیمەیل',
      'name': 'ناو',
      'alreadyHaveAccount': 'پێشتر ئەکاونتت هەیە؟ چوونەژوورەوە',
      'dontHaveAccount': 'ئەکاونتت نییە؟ تۆمارکردن',
      'orContinueWith': 'یان بەردەوام بە',
      'continueWithGoogle': 'بەردەوام بە Google',
      'continueWithApple': 'بەردەوام بە Apple',
      'signUpSuccess': 'تۆمارکردن سەرکەوتوو بوو!',
      // Onboarding
      'onboardingTitle1': 'دەتەوێت دەست پێبکەیت؟',
      'onboardingDesc1':
          'هەوڵبدە بیرۆکەکانمان بەکاربهێنیت بە زیرەکی دەستکرد بۆ بەرزکردنەوەی بەرهەمهێنانت',
      'onboardingTitle2': 'دروستکردنی بیرۆکەکان',
      'onboardingDesc2':
          'زیرەکی دەستکرد بەکاربهێنە بۆ دروستکردنی بیرۆکەی داهێنانە بۆ پرۆژەکانت',
      'onboardingTitle3': 'شوێنکەوتنی پێشکەوتن',
      'onboardingDesc3': 'هەموو بیرۆکەکانت لە شوێنێکدا چاودێری و بەڕێوەبەرە',
      'next': 'دواتر',
      'skip': 'تێپەڕین',
      'getStarted': 'دەست پێبکە',
      // Idea Detail
      'ideaDetail': 'وردەکاریی بیرۆکە',
      'comments': 'لێدوانەکان',
      'attachments': 'پاوانەکان',
      'teamMembers': 'ئەندامانی تیم',
      'addComment': 'لێدوانێک زیاد بکە...',
      'like': 'حەزکردن',
      'share': 'هاوبەشکردن',
      'save': 'پاراستن',
      // Common
      'confirm': 'پشتڕاستکردنەوە',
      'yes': 'بەڵێ',
      'no': 'نەخێر',
      'close': 'داخستن',
      'apply': 'جێبەجێکردن',
      'logoutConfirmTitle': 'چوونەدەرەوە',
      'logoutConfirmDesc': 'دڵنیایت دەتەوێت بچیتە دەرەوە؟',
      'logout': 'چوونەدەرەوە',
      'comingSoon': 'بەم زووانە',
      'filtered': 'فلتەرکرا',
      'sortedBy': 'ڕیزکرا بەپێی',
      'projectDeleted': 'پرۆژە سڕایەوە',
      'savedToFavorites': 'لە دڵخوازەکان پارێزرا!',
      'projectRemoved': 'پرۆژە لابرا',
      'shareComingSoon': 'تایبەتمەندیی هاوبەشکردن بەم زووانە',
      'editComingSoon': 'دەستکاریکردن بەم زووانە',
      // Security / Billing
      'securityTitle': 'ڕێکخستنەکانی ئەمنیەت',
      'securityDesc':
          'بەڕێوەبردنی وشەی نهێنی، دوو-هەنگاوی پشتڕاستکردنەوە، و ئامادەکاریەکانی ئەمنیەت.',
      'billingTitle': 'پارەدان و بەشداریکردن',
      'billingDesc': 'بەڕێوەبردنی پلانی بەشداریکردنت و شێوازەکانی پارەدان.',
      'remindersTitle': 'بیرخستنەوەکان',
      'remindersDesc':
          'بیرخستنەوەی ڕۆژانە دابنێ بۆ شوێنکەوتنی بیرۆکەکانت و کارەکانت.',
      'upgradePlanTitle': 'بەرزکردنەوە بۆ Pro',
      'upgradePlanDesc2':
          'دروستکردنی زیرەکی دەستکردی نامحدود، شیکاریی پێشکەوتوو، و پشتگیریی پێشینەدار کردنەوە.',
      'upgradePlanMonthly': '9.99\$/مانگ',
      'upgradePlanYearly': '79.99\$/ساڵ (33% پاشەکەوت)',
      'upgradePlanFeature1': 'دروستکردنی بیرۆکەی زیرەکی دەستکردی نامحدود',
      'upgradePlanFeature2': 'شیکاری و تێگەیشتنی پێشکەوتوو',
      'upgradePlanFeature3': 'پشتگیریی کڕیاری پێشینەدار',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar', 'ku'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
