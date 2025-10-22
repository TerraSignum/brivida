import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../utils/debug_logger.dart';

class LanguageFooter extends ConsumerWidget {
  const LanguageFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = context.locale;
    final localeCode = currentLocale.languageCode.split('_').first;
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    final bottomPadding = bottomInset > 0 ? bottomInset + 6 : 8.0;

    // Simplified language info
    final languages = [
      {'code': 'de', 'flag': '🇩🇪', 'name': 'Deutsch'},
      {'code': 'en', 'flag': '🇺🇸', 'name': 'English'},
      {'code': 'es', 'flag': '🇪🇸', 'name': 'Español'},
      {'code': 'fr', 'flag': '🇫🇷', 'name': 'Français'},
      {'code': 'pt', 'flag': '🇵🇹', 'name': 'Português'},
    ];

    final fallbackLanguage = languages.first;
    final selectedLanguage = languages.firstWhere(
      (lang) => lang['code'] == localeCode,
      orElse: () => fallbackLanguage,
    );

    final legalLinks = [
      {
        'label': _resolveLegalLabel(
          context,
          primaryKey: 'footer.legal.terms',
          fallbackKey: 'settings.legal.terms',
        ),
        'route': '/legal/terms',
      },
      {
        'label': _resolveLegalLabel(
          context,
          primaryKey: 'footer.legal.privacy',
          fallbackKey: 'settings.legal.privacy',
        ),
        'route': '/legal/privacy',
      },
      {
        'label': _resolveLegalLabel(
          context,
          primaryKey: 'footer.legal.imprint',
          fallbackKey: 'settings.legal.imprint',
        ),
        'route': '/legal/impressum',
      },
    ];

    return SafeArea(
      bottom: true,
      child: Container(
        // Android standard bottom spacing: 16dp padding + extra 8dp for navigation
        padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPadding),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border(top: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.language, size: 20, color: Color(0xFF6366F1)),
                const SizedBox(width: 12),
                // Enhanced touch target for mobile (48dp minimum per Android guidelines)
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    // Enhanced UX: Show language selection bottom sheet for better mobile experience
                    _showLanguageSelection(context, languages, currentLocale);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF6366F1),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(selectedLanguage['flag'] ?? '🌐'),
                        const SizedBox(width: 8),
                        Text(
                          selectedLanguage['name'] ?? localeCode.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF6366F1),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF6366F1),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              runSpacing: 4,
              children: [
                for (var i = 0; i < legalLinks.length; i++) ...[
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () {
                      final uri = Uri(
                        path: legalLinks[i]['route']!,
                        queryParameters: {'lang': currentLocale.languageCode},
                      );
                      context.push(uri.toString());
                    },
                    child: Text(
                      legalLinks[i]['label']!,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  if (i < legalLinks.length - 1)
                    const Text(
                      '·',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                ],
              ],
            ),
          ],
        ),
      ), // Container closing
    ); // SafeArea closing
  }

  String _resolveLegalLabel(
    BuildContext context, {
    required String primaryKey,
    required String fallbackKey,
  }) {
    final translated = context.tr(primaryKey);
    if (translated == primaryKey) {
      DebugLogger.warning(
        '🌍 LANG_FOOTER: Missing translation for $primaryKey, falling back to $fallbackKey',
      );
      return context.tr(fallbackKey);
    }
    return translated;
  }

  void _showLanguageSelection(
    BuildContext context,
    List<Map<String, String>> languages,
    Locale currentLocale,
  ) {
    final currentCode = currentLocale.languageCode.split('_').first;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar for better UX
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.tr('language.select'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                for (final lang in languages)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        DebugLogger.debug(
                          '🌍 LANG_FOOTER: Language tap - Current: ${currentLocale.languageCode}, Target: ${lang['code']}',
                        );
                        if (lang['code'] != currentLocale.languageCode) {
                          try {
                            final newLocale = Locale(lang['code']!);
                            DebugLogger.debug(
                              '🌍 LANG_FOOTER: Setting new locale: $newLocale',
                            );
                            await context.setLocale(newLocale);
                            if (!context.mounted) {
                              DebugLogger.warning(
                                '🌍 LANG_FOOTER: Context unmounted after locale change',
                              );
                              return;
                            }
                            DebugLogger.debug(
                              '🌍 LANG_FOOTER: Locale set successfully to: ${context.locale}',
                            );

                            // Close bottom sheet first
                            Navigator.of(context).pop();

                            // Small delay to ensure bottom sheet is fully closed
                            await Future.delayed(
                              const Duration(milliseconds: 200),
                            );
                            if (!context.mounted) {
                              DebugLogger.warning(
                                '🌍 LANG_FOOTER: Context unmounted before showing snackbar',
                              );
                              return;
                            }
                            // Show a snackbar to indicate language change
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Language changed to ${lang['name']}',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } catch (e, stackTrace) {
                            DebugLogger.error(
                              '🌍 LANG_FOOTER: Error setting locale',
                              e,
                              stackTrace,
                            );
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          }
                        } else {
                          DebugLogger.debug(
                            '🌍 LANG_FOOTER: Same language selected, no change needed',
                          );
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: lang['code'] == currentCode
                              ? const Color(0xFF6366F1).withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: lang['code'] == currentCode
                                ? const Color(0xFF6366F1)
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              lang['flag']!,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                lang['name']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: lang['code'] == currentCode
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: lang['code'] == currentCode
                                      ? const Color(0xFF6366F1)
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            if (lang['code'] == currentCode)
                              const Icon(
                                Icons.check,
                                color: Color(0xFF6366F1),
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
