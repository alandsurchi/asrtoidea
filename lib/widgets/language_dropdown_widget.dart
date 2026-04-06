import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class LanguageDropdownWidget extends ConsumerWidget {
  const LanguageDropdownWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeProvider = ref.watch(localeProviderInstance);
    final localizations = AppLocalizations.of(context)!;

    final languageItems = [
      DropdownMenuItem(
        value: 'en',
        child: Row(
          children: [
            Text('🇬🇧', style: TextStyle(fontSize: 16)),
            SizedBox(width: 8),
            Text(localizations.languageNameEn),
          ],
        ),
      ),
      DropdownMenuItem(
        value: 'ar',
        child: Row(
          children: [
            Text('🇸🇦', style: TextStyle(fontSize: 16)),
            SizedBox(width: 8),
            Text(localizations.languageNameAr),
          ],
        ),
      ),
      DropdownMenuItem(
        value: 'ku',
        child: Row(
          children: [
            Text('🏳️', style: TextStyle(fontSize: 16)),
            SizedBox(width: 8),
            Text(localizations.languageNameKu),
          ],
        ),
      ),
    ];

    return DropdownButton<String>(
      value: localeProvider.locale.languageCode,
      items: languageItems,
      underline: SizedBox.shrink(),
      onChanged: (value) => value != null
          ? ref.read(localeProviderInstance.notifier).setLocale(Locale(value))
          : null,
    );
  }
}
