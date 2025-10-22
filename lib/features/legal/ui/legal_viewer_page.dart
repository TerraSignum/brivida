import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import '../../../core/i18n/app_localizations.dart';

import '../../../core/models/legal.dart';
import '../../../core/utils/debug_logger.dart';
import '../logic/legal_controller.dart';

class LegalViewerPage extends ConsumerStatefulWidget {
  final LegalDocType docType;
  final SupportedLanguage? language;
  final String? version;

  const LegalViewerPage({
    super.key,
    required this.docType,
    this.language,
    this.version,
  });

  @override
  ConsumerState<LegalViewerPage> createState() => _LegalViewerPageState();
}

class _LegalViewerPageState extends ConsumerState<LegalViewerPage> {
  late SupportedLanguage currentLanguage;
  LegalDocument? currentDocument;
  bool isLoading = true;
  String? errorMessage;
  static const SupportedLanguage _fallbackLanguage = SupportedLanguage.en;

  @override
  void initState() {
    super.initState();
    DebugLogger.lifecycle('LegalViewerPage', 'initState', {
      'docType': widget.docType.name,
      'language': widget.language?.name,
      'version': widget.version,
    });

    currentLanguage = _resolveCurrentLanguage();
    _syncSharedLanguage(currentLanguage);
    DebugLogger.debug('🌐 Initial language set to: ${currentLanguage.name}');
    _loadDocument();
  }

  @override
  void didUpdateWidget(covariant LegalViewerPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.language != null && widget.language != oldWidget.language) {
      DebugLogger.debug(
        '🌐 Widget language changed: ${widget.language?.name}, reloading document',
      );
      setState(() {
        currentLanguage = widget.language!;
      });
      _syncSharedLanguage(currentLanguage);
      _loadDocument();
    }
  }

  SupportedLanguage _resolveCurrentLanguage() {
    if (widget.language != null) {
      return widget.language!;
    }

    try {
      return ref.read(currentLanguageProvider);
    } catch (error) {
      if (_isMissingProviderScope(error)) {
        return _fallbackLanguage;
      }
      rethrow;
    }
  }

  void _syncSharedLanguage(SupportedLanguage language) {
    try {
      ref.read(currentLanguageProvider.notifier).state = language;
    } catch (error) {
      if (!_isMissingProviderScope(error)) {
        rethrow;
      }
    }
  }

  bool _isMissingProviderScope(Object error) {
    return error is StateError &&
        error.message.contains('No ProviderScope found');
  }

  Future<void> _loadDocument() async {
    DebugLogger.enter('LegalViewerPage._loadDocument', {
      'docType': widget.docType.name,
      'language': currentLanguage.name,
      'version': widget.version,
    });
    DebugLogger.startTimer('loadDocument');

    if (!mounted) {
      DebugLogger.exit('LegalViewerPage._loadDocument', 'disposed');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    DebugLogger.stateChange('LegalViewerPage', 'ready', 'loading');

    try {
      DebugLogger.debug(
        '🔒 LEGAL_VIEWER: Loading document ${widget.docType} in $currentLanguage',
      );
      final fileName = _resolveAssetFileName(widget.docType);
      final languagesToTry = <SupportedLanguage>{
        currentLanguage,
        if (currentLanguage != _fallbackLanguage) _fallbackLanguage,
      };

      String? content;
      SupportedLanguage? resolvedLanguage;

      for (final lang in languagesToTry) {
        final assetPath = _buildAssetPath(lang, fileName);
        DebugLogger.debug('� Trying asset path: $assetPath');
        try {
          final loaded = await rootBundle.loadString(assetPath);
          DebugLogger.debug(
            '✅ Asset loaded for ${lang.name}, bytes: ${loaded.length}',
          );
          content = loaded;
          resolvedLanguage = lang;
          break;
        } on FlutterError catch (assetError) {
          DebugLogger.warning(
            '⚠️ Asset not found for ${lang.name}: $assetError',
          );
        }
      }

      if (!mounted) {
        DebugLogger.exit('LegalViewerPage._loadDocument', 'disposed');
        return;
      }

      if (content == null || resolvedLanguage == null) {
        DebugLogger.error(
          '❌ LEGAL_VIEWER: No legal asset found for ${widget.docType.name}',
        );
        setState(() {
          isLoading = false;
          errorMessage =
              'Dokument für ${widget.docType.name} konnte nicht geladen werden.';
        });
        DebugLogger.stateChange('LegalViewerPage', 'loading', 'error');
        final duration = DebugLogger.stopTimer('loadDocument');
        if (duration != null) {
          DebugLogger.performance('loadDocument', duration);
        }
        DebugLogger.exit('LegalViewerPage._loadDocument', 'asset_missing');
        return;
      }

      if (resolvedLanguage != currentLanguage) {
        DebugLogger.debug(
          'ℹ️ Switching to fallback language ${resolvedLanguage.name}',
        );
        currentLanguage = resolvedLanguage;
        _syncSharedLanguage(resolvedLanguage);
      }

      final doc = LegalDocument(
        id: '${widget.docType.name}_${resolvedLanguage.name}',
        type: widget.docType,
        lang: resolvedLanguage,
        version: widget.version ?? 'v1.0',
        title: _getDocumentTitle(widget.docType, resolvedLanguage),
        content: content,
        isActive: true,
        publishedAt: DateTime.now(),
      );

      setState(() {
        currentDocument = doc;
        isLoading = false;
        errorMessage = null;
      });
      DebugLogger.stateChange('LegalViewerPage', 'loading', 'loaded');

      final duration = DebugLogger.stopTimer('loadDocument');
      if (duration != null) {
        DebugLogger.performance('loadDocument', duration);
      }
      DebugLogger.exit('LegalViewerPage._loadDocument', 'asset_success');
      return;
    } catch (e, stackTrace) {
      DebugLogger.error(
        '🔒 LEGAL_VIEWER: Critical error loading document',
        e,
        stackTrace,
      );
      if (mounted) {
        setState(() {
          errorMessage = 'Fehler beim Laden: $e';
          isLoading = false;
        });
        DebugLogger.stateChange('LegalViewerPage', 'loading', 'error');
      } else {
        DebugLogger.stateChange('LegalViewerPage', 'loading', 'disposed');
      }
      final duration = DebugLogger.stopTimer('loadDocument');
      if (duration != null) {
        DebugLogger.performance('loadDocument', duration);
      }
      DebugLogger.exit(
        'LegalViewerPage._loadDocument',
        mounted ? 'error' : 'disposed',
      );
    }
  }

  String _buildAssetPath(SupportedLanguage lang, String fileName) {
    return 'assets/legal/${lang.name}/$fileName.md';
  }

  String _resolveAssetFileName(LegalDocType type) {
    switch (type) {
      case LegalDocType.tos:
        return 'terms';
      case LegalDocType.privacy:
        return 'privacy';
      case LegalDocType.impressum:
        return 'impressum';
      case LegalDocType.guidelines:
        return 'guidelines';
      case LegalDocType.refund:
        return 'refund';
    }
  }

  String _getDocumentTitle(LegalDocType type, SupportedLanguage language) {
    switch (type) {
      case LegalDocType.privacy:
        return language == SupportedLanguage.de
            ? 'Datenschutzerklärung'
            : language == SupportedLanguage.es
            ? 'Política de Privacidad'
            : language == SupportedLanguage.fr
            ? 'Politique de Confidentialité'
            : language == SupportedLanguage.pt
            ? 'Política de Privacidade'
            : 'Privacy Policy';
      case LegalDocType.tos:
        return language == SupportedLanguage.de
            ? 'Allgemeine Geschäftsbedingungen'
            : language == SupportedLanguage.es
            ? 'Términos y Condiciones'
            : language == SupportedLanguage.fr
            ? 'Conditions Générales'
            : language == SupportedLanguage.pt
            ? 'Termos e Condições'
            : 'Terms and Conditions';
      case LegalDocType.impressum:
        return language == SupportedLanguage.de
            ? 'Impressum'
            : language == SupportedLanguage.es
            ? 'Aviso Legal'
            : language == SupportedLanguage.fr
            ? 'Mentions Légales'
            : language == SupportedLanguage.pt
            ? 'Impressão Legal'
            : 'Legal Notice';
      case LegalDocType.refund:
        return language == SupportedLanguage.de
            ? 'Rückerstattungsrichtlinie'
            : language == SupportedLanguage.es
            ? 'Política de Reembolso'
            : language == SupportedLanguage.fr
            ? 'Politique de Remboursement'
            : language == SupportedLanguage.pt
            ? 'Política de Reembolso'
            : 'Refund Policy';
      case LegalDocType.guidelines:
        return language == SupportedLanguage.de
            ? 'Nutzungsrichtlinien'
            : language == SupportedLanguage.es
            ? 'Directrices de Uso'
            : language == SupportedLanguage.fr
            ? 'Directives d\'Utilisation'
            : language == SupportedLanguage.pt
            ? 'Diretrizes de Uso'
            : 'Usage Guidelines';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _handleBack(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _getDocumentTitle(
              widget.docType,
              currentDocument?.lang ?? currentLanguage,
            ),
          ),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _handleBack(context),
          ),
          actions: [
            // Language selector
            PopupMenuButton<SupportedLanguage>(
              icon: const Icon(Icons.language),
              initialValue: currentLanguage,
              onSelected: (lang) {
                DebugLogger.userAction('language_change', {
                  'from': currentLanguage.name,
                  'to': lang.name,
                  'docType': widget.docType.name,
                });

                setState(() {
                  currentLanguage = lang;
                });
                _syncSharedLanguage(lang);
                DebugLogger.stateChange(
                  'LegalViewerPage',
                  'language_${currentLanguage.name}',
                  'language_${lang.name}',
                );
                _loadDocument();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: SupportedLanguage.de,
                  child: Row(
                    children: [
                      Text('🇩🇪'),
                      SizedBox(width: 8),
                      Text('Deutsch'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: SupportedLanguage.en,
                  child: Row(
                    children: [
                      Text('🇺🇸'),
                      SizedBox(width: 8),
                      Text('English'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: SupportedLanguage.pt,
                  child: Row(
                    children: [
                      Text('🇵🇹'),
                      SizedBox(width: 8),
                      Text('Português'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: SupportedLanguage.es,
                  child: Row(
                    children: [
                      Text('🇪🇸'),
                      SizedBox(width: 8),
                      Text('Español'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: SupportedLanguage.fr,
                  child: Row(
                    children: [
                      Text('🇫🇷'),
                      SizedBox(width: 8),
                      Text('Français'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  void _handleBack(BuildContext context) {
    final router = GoRouter.maybeOf(context);
    if (router != null && router.canPop()) {
      router.pop();
      return;
    }

    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }

    router?.go('/home');
  }

  Widget _buildBody() {
    final l10n = AppLocalizations.of(context);

    if (isLoading) {
      // Show app logo (less jarring than a spinner + hardcoded text)
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo2.png', width: 96, height: 96),
            const SizedBox(height: 16),
            Text(l10n.translate('footer.legal.viewer.loading')),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              l10n.translate('footer.legal.viewer.errorTitle'),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n
                  .translate('footer.legal.viewer.errorDetail')
                  .replaceAll('{error}', errorMessage!),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadDocument,
              child: Text(l10n.translate('footer.legal.viewer.retry')),
            ),
          ],
        ),
      );
    }

    if (currentDocument == null) {
      return Center(
        child: Text(
          AppLocalizations.of(
            context,
          ).translate('footer.legal.viewer.notFound'),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Document header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentDocument!.title ??
                        _getDocumentTitle(
                          widget.docType,
                          currentDocument!.lang,
                        ),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Version ${currentDocument!.version}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        () {
                          final dateStr = currentDocument!.publishedAt
                              .toLocal()
                              .toString();
                          final parts = dateStr.split(' ');
                          return parts.isNotEmpty ? parts[0] : dateStr;
                        }(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Document content
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildDocumentContent(currentDocument!.content),
            ),
          ),

          const SizedBox(height: 32),

          // Footer
          Card(
            color: Colors.grey[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kontakt',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'BRIVIDA GmbH\nE-Mail: legal@brivida.com\nWebsite: www.brivida.com',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentContent(String content) {
    final theme = Theme.of(context);

    return MarkdownBody(
      data: content,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
        textScaler: const TextScaler.linear(1.0),
        p: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
        h1: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1F2937),
        ),
        h2: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1F2937),
        ),
        h3: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1F2937),
        ),
        listBullet: theme.textTheme.bodyMedium,
      ),
      softLineBreak: true,
    );
  }
}
