import 'dart:io';

import 'package:brivida_app/core/exceptions/app_exceptions.dart';
import 'package:brivida_app/core/i18n/app_localizations.dart';
import 'package:brivida_app/core/models/app_user.dart';
import 'package:brivida_app/core/providers/firebase_providers.dart';
import 'package:brivida_app/core/utils/debug_logger.dart';
import 'package:brivida_app/features/settings/logic/settings_controller.dart';
import 'package:brivida_app/features/settings/ui/delete_account_sheet.dart';
import 'package:brivida_app/features/settings/ui/profile_edit_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../tutorial/logic/tutorial_registry.dart';
import '../../tutorial/ui/tutorial_trigger.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _imagePicker = ImagePicker();
  bool _uploadingPhoto = false;
  bool _updatingMarketing = false;
  bool _updatingPhone = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(settingsControllerProvider);

    final scaffold = Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => _handleBack(context)),
        title: Text(l10n.translate('settings.title')),
      ),
      body: state.when(
        data: (user) => _SettingsContent(
          user: user,
          uploadingPhoto: _uploadingPhoto,
          updatingMarketing: _updatingMarketing,
          updatingPhone: _updatingPhone,
          onRefresh: () =>
              ref.read(settingsControllerProvider.notifier).refresh(),
          onChangePhoto: () => _pickNewPhoto(context),
          onToggleMarketing: (value) => _toggleMarketing(context, value),
          onEditPhone: (appUser) => _editPhone(context, appUser),
          onCallPhone: (phone) => _callPhone(context, phone),
          onOpenTerms: () => _openLegal(context, '/legal/terms'),
          onOpenPrivacy: () => _openLegal(context, '/legal/privacy'),
          onOpenImprint: () => _openLegal(context, '/legal/impressum'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildError(context, error, stack),
      ),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _handleBack(context);
        }
      },
      child: TutorialTrigger(screen: TutorialScreen.settings, child: scaffold),
    );
  }

  void _handleBack(BuildContext context) {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      context.pop();
      return;
    }

    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }

    context.go('/home');
  }

  void _openLegal(BuildContext context, String path) {
    final localeCode = context.locale.languageCode;
    final uri = Uri(path: path, queryParameters: {'lang': localeCode});
    context.push(uri.toString());
  }

  Widget _buildError(BuildContext context, Object error, StackTrace stack) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 16),
          Text(
            'settings.error'.tr(context: context),
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () =>
                ref.read(settingsControllerProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
            label: Text('common.retry'.tr(context: context)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickNewPhoto(BuildContext context) async {
    final controller = ref.read(settingsControllerProvider.notifier);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);

    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        imageQuality: 85,
      );
      if (image == null) return;

      setState(() {
        _uploadingPhoto = true;
      });

      await controller.updatePhoto(File(image.path));

      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(l10n.translate('settings.photo.updated'))),
      );
    } catch (error, stack) {
      DebugLogger.error('Error updating profile photo', error, stack);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(l10n.translate('settings.error.photoUpload'))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _uploadingPhoto = false;
        });
      }
    }
  }

  Future<void> _toggleMarketing(BuildContext context, bool value) async {
    final controller = ref.read(settingsControllerProvider.notifier);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);

    setState(() {
      _updatingMarketing = true;
    });

    try {
      await controller.updateMarketingOptIn(value);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(l10n.translate('settings.marketing.updated'))),
      );
    } catch (error, stack) {
      DebugLogger.error('Error toggling marketing opt-in', error, stack);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(l10n.translate('settings.error.generic'))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _updatingMarketing = false;
        });
      }
    }
  }

  Future<void> _editPhone(BuildContext context, AppUser user) async {
    final l10n = AppLocalizations.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final controller = ref.read(settingsControllerProvider.notifier);
    final hasExisting = user.phoneNumber?.trim().isNotEmpty ?? false;

    final textController = TextEditingController(text: user.phoneNumber ?? '');

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Text(l10n.translate('settings.phone.dialog.title')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: textController,
                autofocus: true,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: l10n.translate('settings.phone.dialog.label'),
                  hintText: l10n.translate('settings.phone.dialog.hint'),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.translate('settings.phone.dialog.helper'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.translate('settings.phone.dialog.cancel')),
            ),
            if (hasExisting)
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(''),
                child: Text(l10n.translate('settings.phone.dialog.remove')),
              ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(textController.text.trim()),
              child: Text(l10n.translate('settings.phone.dialog.save')),
            ),
          ],
        );
      },
    );

    textController.dispose();

    if (result == null) {
      return;
    }

    setState(() {
      _updatingPhone = true;
    });

    try {
      await controller.updatePhoneNumber(result);
      final trimmed = result.trim();
      final messageKey = trimmed.isEmpty
          ? 'settings.phone.removed'
          : 'settings.phone.updated';
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(l10n.translate(messageKey))),
      );
    } on AppException catch (error) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error, stack) {
      DebugLogger.error('Error updating phone number', error, stack);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(l10n.translate('settings.error.generic'))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _updatingPhone = false;
        });
      }
    }
  }

  Future<void> _callPhone(BuildContext context, String phoneNumber) async {
    final l10n = AppLocalizations.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final sanitized = phoneNumber.replaceAll(RegExp(r'[\s()-]'), '');
    final uri = Uri(scheme: 'tel', path: sanitized);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(l10n.translate('settings.phone.callUnavailable')),
          ),
        );
      }
    } catch (error, stack) {
      DebugLogger.error('Error launching phone call', error, stack);
      if (!mounted) {
        return;
      }
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.translate('settings.phone.callUnavailable')),
        ),
      );
    }
  }
}

class _SettingsContent extends ConsumerWidget {
  const _SettingsContent({
    required this.user,
    required this.uploadingPhoto,
    required this.updatingMarketing,
    required this.updatingPhone,
    required this.onRefresh,
    required this.onChangePhoto,
    required this.onToggleMarketing,
    required this.onEditPhone,
    required this.onCallPhone,
    required this.onOpenTerms,
    required this.onOpenPrivacy,
    required this.onOpenImprint,
  });

  final AppUser? user;
  final bool uploadingPhoto;
  final bool updatingMarketing;
  final bool updatingPhone;
  final Future<void> Function() onRefresh;
  final VoidCallback onChangePhoto;
  final ValueChanged<bool> onToggleMarketing;
  final Future<void> Function(AppUser user) onEditPhone;
  final Future<void> Function(String phoneNumber) onCallPhone;
  final VoidCallback onOpenTerms;
  final VoidCallback onOpenPrivacy;
  final VoidCallback onOpenImprint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    if (user == null) {
      return Center(child: Text(l10n.translate('settings.error.noProfile')));
    }

    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: EdgeInsets.fromLTRB(16, 24, 16, 24 + bottomInset),
        children: [
          _ProfileHeader(
            user: user!,
            uploadingPhoto: uploadingPhoto,
            onChangePhoto: onChangePhoto,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.translate('settings.sections.profile'),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(l10n.translate('settings.profile.displayName')),
                  subtitle: Text(
                    user!.hasUsername
                        ? '@${user!.username}'
                        : (user!.displayName ?? '—'),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ProfileEditPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.alternate_email),
                  title: Text(l10n.translate('settings.profile.username')),
                  subtitle: Text(
                    user!.hasUsername
                        ? '@${user!.username}'
                        : l10n.translate('settings.username.addPrompt'),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            const ProfileEditPage(openUsername: true),
                      ),
                    );
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l10n.translate('settings.profile.language')),
                  subtitle: Text(
                    l10n
                        .translate('settings.language.current')
                        .replaceAll(
                          '{code}',
                          (user!.locale ?? 'system').toUpperCase(),
                        ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            const ProfileEditPage(openLanguage: true),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.translate('settings.sections.notifications'),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile.adaptive(
              value: user!.marketingOptIn,
              title: Text(l10n.translate('settings.notifications.marketing')),
              subtitle: Text(
                l10n.translate('settings.notifications.marketingHint'),
              ),
              onChanged: updatingMarketing ? null : onToggleMarketing,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.translate('settings.sections.communication'),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  title: Text(l10n.translate('settings.phone.title')),
                  subtitle: Text(
                    (user!.phoneNumber?.trim().isNotEmpty ?? false)
                        ? user!.phoneNumber!
                        : l10n.translate('settings.phone.subtitle'),
                  ),
                  trailing: updatingPhone
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.edit_outlined),
                  onTap: updatingPhone ? null : () => onEditPhone(user!),
                ),
                if (user!.phoneNumber?.trim().isNotEmpty ?? false) ...[
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.call_outlined),
                    title: Text(l10n.translate('settings.phone.call')),
                    subtitle: Text(
                      l10n
                          .translate('settings.phone.callHint')
                          .replaceAll('{number}', user!.phoneNumber!),
                    ),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () => onCallPhone(user!.phoneNumber!),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.translate('settings.sections.account'),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: Text(l10n.translate('settings.logout')),
              onTap: () async {
                final auth = ref.read(authProvider);
                await auth.signOut();
                if (context.mounted) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/sign-in', (route) => false);
                }
              },
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.translate('settings.sections.legal'),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.gavel_outlined),
                  title: Text(l10n.translate('settings.legal.terms')),
                  onTap: onOpenTerms,
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(l10n.translate('settings.legal.privacy')),
                  onTap: onOpenPrivacy,
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.article_outlined),
                  title: Text(l10n.translate('settings.legal.imprint')),
                  onTap: onOpenImprint,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.translate('settings.sections.dangerZone'),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: Colors.red[700]),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.delete_forever_outlined,
                color: Colors.red,
              ),
              title: Text(
                l10n.translate('settings.delete.title'),
                style: const TextStyle(color: Colors.red),
              ),
              subtitle: Text(
                l10n.translate('settings.delete.subtitle'),
                style: TextStyle(color: Colors.red[300]),
              ),
              onTap: () async {
                final auth = ref.read(authProvider);
                final result = await showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  builder: (sheetContext) => const DeleteAccountSheet(),
                );
                if (result == true) {
                  await auth.signOut();
                  if (context.mounted) {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/sign-in', (route) => false);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.user,
    required this.uploadingPhoto,
    required this.onChangePhoto,
  });

  final AppUser user;
  final bool uploadingPhoto;
  final VoidCallback onChangePhoto;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? Text(
                          user.displayLabel.characters
                              .take(2)
                              .toString()
                              .toUpperCase(),
                          style: const TextStyle(fontSize: 18),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: uploadingPhoto
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : IconButton(
                            icon: const Icon(Icons.camera_alt, size: 16),
                            color: Colors.white,
                            onPressed: uploadingPhoto ? null : onChangePhoto,
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.friendlyName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.displayLabel,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n
                        .translate('settings.profile.memberSince')
                        .replaceAll(
                          '{date}',
                          user.createdAt != null
                              ? DateFormat.yMMMMd(
                                  l10n.locale.languageCode,
                                ).format(user.createdAt!)
                              : '—',
                        ),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
