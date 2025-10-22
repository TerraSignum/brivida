import 'package:brivida_app/core/exceptions/app_exceptions.dart';
import 'package:brivida_app/core/i18n/app_localizations.dart';
import 'package:brivida_app/core/models/app_user.dart';
import 'package:brivida_app/core/utils/debug_logger.dart';
import 'package:brivida_app/features/settings/logic/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({
    super.key,
    this.openUsername = false,
    this.openLanguage = false,
  });

  final bool openUsername;
  final bool openLanguage;

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final _scrollController = ScrollController();
  final _displayKey = GlobalKey();
  final _usernameKey = GlobalKey();
  final _languageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.openUsername) {
        _scrollToKey(_usernameKey);
      } else if (widget.openLanguage) {
        _scrollToKey(_languageKey);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('settings.edit.title'))),
      body: state.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.translate('settings.error.noProfile'),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return _ProfileEditContent(
            key: ValueKey(user.uid),
            user: user,
            controller: controller,
            scrollController: _scrollController,
            displayKey: _displayKey,
            usernameKey: _usernameKey,
            languageKey: _languageKey,
            openUsername: widget.openUsername,
            openLanguage: widget.openLanguage,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          DebugLogger.error(
            'Error loading profile for editing',
            error,
            stackTrace,
          );
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    l10n.translate('settings.error.generic'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () =>
                        ref.read(settingsControllerProvider.notifier).refresh(),
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.translate('common.retry')),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileEditContent extends StatefulWidget {
  const _ProfileEditContent({
    super.key,
    required this.user,
    required this.controller,
    required this.scrollController,
    required this.displayKey,
    required this.usernameKey,
    required this.languageKey,
    required this.openUsername,
    required this.openLanguage,
  });

  final AppUser user;
  final SettingsController controller;
  final ScrollController scrollController;
  final GlobalKey displayKey;
  final GlobalKey usernameKey;
  final GlobalKey languageKey;
  final bool openUsername;
  final bool openLanguage;

  @override
  State<_ProfileEditContent> createState() => _ProfileEditContentState();
}

class _ProfileEditContentState extends State<_ProfileEditContent> {
  late final TextEditingController _handleController;
  final FocusNode _usernameFocus = FocusNode();

  bool _usernameDirty = false;
  bool _reservingUsername = false;
  bool _updatingLocale = false;
  bool _isNormalizingHandle = false;

  String? _usernameMessage;
  bool _usernameMessageIsError = false;
  String? _selectedLocale;

  @override
  void initState() {
    super.initState();
    final initialHandle = widget.user.username ?? widget.user.displayName ?? '';
    final normalizedHandle = _normalizeHandle(initialHandle);
    _handleController = TextEditingController(text: normalizedHandle);
    _selectedLocale = widget.user.locale;

    _handleController.addListener(_onHandleChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.openUsername) {
        _scrollToKey(widget.usernameKey);
        _usernameFocus.requestFocus();
      } else if (widget.openLanguage) {
        _scrollToKey(widget.languageKey);
      }
    });
  }

  @override
  void didUpdateWidget(covariant _ProfileEditContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_usernameDirty &&
        (oldWidget.user.username != widget.user.username ||
            oldWidget.user.displayName != widget.user.displayName)) {
      final incoming = widget.user.username ?? widget.user.displayName ?? '';
      final normalized = _normalizeHandle(incoming);
      if (_handleController.text != normalized) {
        _handleController.text = normalized;
      }
    }
    if (oldWidget.user.locale != widget.user.locale && !_updatingLocale) {
      setState(() {
        _selectedLocale = widget.user.locale;
      });
    }
  }

  @override
  void dispose() {
    _handleController.removeListener(_onHandleChanged);
    _handleController.dispose();
    _usernameFocus.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _onHandleChanged() {
    if (_isNormalizingHandle) {
      return;
    }
    final normalized = _normalizeHandle(_handleController.text);
    if (_handleController.text != normalized) {
      _isNormalizingHandle = true;
      _handleController.value = TextEditingValue(
        text: normalized,
        selection: TextSelection.collapsed(offset: normalized.length),
      );
      _isNormalizingHandle = false;
    }
    if (!_usernameDirty) {
      _usernameDirty = true;
    }
  }

  String _normalizeHandle(String value) {
    final trimmed = value.trim().toLowerCase();
    final sanitized = trimmed.replaceAll(RegExp(r'[^a-z0-9_.]'), '');
    if (sanitized.length > 20) {
      return sanitized.substring(0, 20);
    }
    return sanitized;
  }

  Future<void> _reserveUsername() async {
    final l10n = AppLocalizations.of(context);
    final desired = _normalizeHandle(_handleController.text);
    if (desired.isEmpty || desired.length < 3) {
      setState(() {
        _usernameMessage = l10n.translate('settings.edit.username.required');
        _usernameMessageIsError = true;
      });
      return;
    }

    if (_handleController.text != desired) {
      _isNormalizingHandle = true;
      _handleController.value = TextEditingValue(
        text: desired,
        selection: TextSelection.collapsed(offset: desired.length),
      );
      _isNormalizingHandle = false;
    }

    setState(() {
      _reservingUsername = true;
      _usernameMessage = null;
    });

    try {
      await widget.controller.reserveUsername(desired);
      if (!mounted) return;
      _usernameDirty = false;
      setState(() {
        _usernameMessage = l10n.translate('settings.edit.username.success');
        _usernameMessageIsError = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.translate('settings.edit.username.snackbarSuccess'),
          ),
        ),
      );
    } on AppException catch (error) {
      setState(() {
        _usernameMessage = error.message;
        _usernameMessageIsError = true;
      });
    } catch (error, stack) {
      DebugLogger.error('Unknown error reserving username', error, stack);
      setState(() {
        _usernameMessage = l10n.translate('settings.error.generic');
        _usernameMessageIsError = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _reservingUsername = false;
        });
      }
    }
  }

  Future<void> _selectLocale(String? code) async {
    final l10n = AppLocalizations.of(context);
    final normalized = code == 'system' ? null : code;

    setState(() {
      _updatingLocale = true;
    });

    try {
      await widget.controller.updateLocale(normalized);
      if (!mounted) return;
      setState(() {
        _selectedLocale = normalized;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.translate('settings.edit.language.success')),
        ),
      );
    } on AppException catch (error) {
      _handleError(error);
    } catch (error, stack) {
      DebugLogger.error('Unknown error updating locale', error, stack);
      _handleError(error);
    } finally {
      if (mounted) {
        setState(() {
          _updatingLocale = false;
        });
      }
    }
  }

  void _handleError(Object error) {
    final l10n = AppLocalizations.of(context);
    final message = error is AppException
        ? error.message
        : l10n.translate('settings.error.generic');
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      children: [
        Text(
          l10n.translate('settings.edit.subtitle'),
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        _buildDisplayNameCard(context, l10n, theme),
        const SizedBox(height: 24),
        _buildUsernameCard(context, l10n, theme),
        const SizedBox(height: 24),
        _buildLanguageCard(context, l10n, theme),
      ],
    );
  }

  Widget _buildDisplayNameCard(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Card(
      key: widget.displayKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translate('settings.edit.displayName.title'),
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _handleController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: l10n.translate('settings.edit.displayName.label'),
                helperText: l10n.translate('settings.edit.displayName.helper'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsernameCard(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Card(
      key: widget.usernameKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translate('settings.edit.username.title'),
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _handleController,
              focusNode: _usernameFocus,
              textInputAction: TextInputAction.done,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: l10n.translate('settings.edit.username.label'),
                prefixText: '@',
                helperMaxLines: 3,
                helperText: l10n.translate('settings.edit.username.helper'),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_.]')),
                LengthLimitingTextInputFormatter(20),
              ],
              onSubmitted: (_) => _reserveUsername(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: _reservingUsername
                      ? null
                      : () => _reserveUsername(),
                  icon: _reservingUsername
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.verified_user_outlined),
                  label: Text(l10n.translate('settings.edit.username.action')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.translate('settings.edit.username.disclaimer'),
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            if (_usernameMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _usernameMessage!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _usernameMessageIsError
                      ? theme.colorScheme.error
                      : theme.colorScheme.secondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final languages = [
      ('system', l10n.translate('settings.language.system')),
      ('de', l10n.translate('settings.language.de')),
      ('en', l10n.translate('settings.language.en')),
      ('pt', l10n.translate('settings.language.pt')),
      ('es', l10n.translate('settings.language.es')),
      ('fr', l10n.translate('settings.language.fr')),
    ];

    final selected = _selectedLocale ?? 'system';

    return Card(
      key: widget.languageKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translate('settings.edit.language.title'),
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.translate('settings.edit.language.description'),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in languages)
                  ChoiceChip(
                    label: Text(entry.$2),
                    selected: selected == entry.$1,
                    onSelected: _updatingLocale
                        ? null
                        : (value) {
                            if (!value) return;
                            _selectLocale(entry.$1);
                          },
                  ),
              ],
            ),
            if (_updatingLocale)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: LinearProgressIndicator(minHeight: 2),
              ),
          ],
        ),
      ),
    );
  }
}
