import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './l10n/fallback_locale_delegates.dart';
import './providers/locale_provider.dart';
import './providers/theme_provider.dart';
import './widgets/custom_page_transition_builder.dart';
import 'core/app_export.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]).then((value) {
    runApp(
      ProviderScope(child: MyApp()),
    );
  });
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeProvider = ref.watch(localeProviderInstance);
    final themeProvider = ref.watch(themeProviderInstance);
    final isKu = localeProvider.locale.languageCode == 'ku';
    return Sizer(
      builder: (context, orientation, deviceType) {
        ThemeData light = theme.copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
              TargetPlatform.linux: CustomPageTransitionBuilder(),
              TargetPlatform.macOS: CustomPageTransitionBuilder(),
              TargetPlatform.windows: CustomPageTransitionBuilder(),
              TargetPlatform.fuchsia: CustomPageTransitionBuilder(),
            },
          ),
        );
        ThemeData dark = darkTheme.copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
              TargetPlatform.linux: CustomPageTransitionBuilder(),
              TargetPlatform.macOS: CustomPageTransitionBuilder(),
              TargetPlatform.windows: CustomPageTransitionBuilder(),
              TargetPlatform.fuchsia: CustomPageTransitionBuilder(),
            },
          ),
        );
        if (isKu) {
          light = light.copyWith(
            textTheme: light.textTheme.apply(fontFamily: 'Sarchia'),
            primaryTextTheme: light.primaryTextTheme.apply(fontFamily: 'Sarchia'),
          );
          dark = dark.copyWith(
            textTheme: dark.textTheme.apply(fontFamily: 'Sarchia'),
            primaryTextTheme: dark.primaryTextTheme.apply(fontFamily: 'Sarchia'),
          );
        }
        return MaterialApp(
          locale: localeProvider.locale,
          localizationsDelegates: [
            ...AppLocalizations.localizationsDelegates,
            const FallbackMaterialLocalizationsDelegate(),
            const FallbackCupertinoLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: light,
          darkTheme: dark,
          themeMode: themeProvider.themeMode,
          title: 'ai_idea_generator',
          // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
          builder: (context, child) {
            final mq = MediaQuery.of(context);
            Widget content = child!;
            // Phone-sized column on wide web viewports (Edge/Chrome fullscreen).
            if (kIsWeb && mq.size.width > 520) {
              content = Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: content,
                ),
              );
            }
            return MediaQuery(
              data: mq.copyWith(textScaler: TextScaler.linear(1.0)),
              child: content,
            );
          },
          // 🚨 END CRITICAL SECTION
          navigatorKey: NavigatorService.navigatorKey,
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.initialRoute,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
