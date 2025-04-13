import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/localization_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeLanguageWidget extends ConsumerStatefulWidget {
  const ChangeLanguageWidget({super.key});

  @override
  ConsumerState<ChangeLanguageWidget> createState() => _ChangeLanguageWidgetState();
}
class _ChangeLanguageWidgetState extends ConsumerState<ChangeLanguageWidget> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 398.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 4.0,
                width: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: const Color(0xFFC8CFD8),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
             const Text(
              'Languages',
               style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildLanguageOption('کوردی', const Locale('fa')),
            _buildLanguageOption('العربیة', const Locale('ar')),
            _buildLanguageOption('English', const Locale('en')),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                Locale newLocale = _selectedLanguage == 'کوردی'
                    ? const Locale('fa')
                    : _selectedLanguage == 'العربیة'
                    ? const Locale('ar')
                    : const Locale('en');
                ref.read(localeProvider.notifier).setLocale(newLocale);
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.bottomSheet_btn,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildLanguageOption(String language, Locale locale) {
    return Row(
      children: [
        Text(language),
        const Spacer(),
        Radio<String>(
          value: language,
          groupValue: _selectedLanguage,
          onChanged: (String? value) {
            setState(() {
              _selectedLanguage = value!;
            });
          },
        ),
      ],
    );
  }
}
