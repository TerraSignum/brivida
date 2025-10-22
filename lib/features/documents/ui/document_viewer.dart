import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/document.dart';

/// Document viewer widget for displaying uploaded documents
class DocumentViewer extends StatelessWidget {
  final Document document;

  const DocumentViewer({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(document.fileName),
        actions: [
          IconButton(
            onPressed: () => _openInExternalApp(context),
            icon: const Icon(Icons.open_in_new),
            tooltip: 'In externer App öffnen',
          ),
        ],
      ),
      body: _buildDocumentContent(context),
    );
  }

  Widget _buildDocumentContent(BuildContext context) {
    final fileName = document.fileName.toLowerCase();

    if (fileName.endsWith('.pdf')) {
      return _buildPdfViewer(context);
    } else if (fileName.endsWith('.jpg') ||
        fileName.endsWith('.jpeg') ||
        fileName.endsWith('.png')) {
      return _buildImageViewer();
    } else {
      return _buildUnsupportedTypeViewer(context);
    }
  }

  Widget _buildImageViewer() {
    return Center(
      child: InteractiveViewer(
        panEnabled: true,
        minScale: 0.1,
        maxScale: 4.0,
        child: CachedNetworkImage(
          imageUrl: document.storageUrl,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Fehler beim Laden des Bildes'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _openInExternalApp(context),
                child: const Text('In Browser öffnen'),
              ),
            ],
          ),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildPdfViewer(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.picture_as_pdf, size: 120, color: Colors.red),
          const SizedBox(height: 24),
          Text(
            document.fileName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'PDF-Vorschau nicht verfügbar',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _openInExternalApp(context),
            icon: const Icon(Icons.open_in_new),
            label: const Text('In PDF-Viewer öffnen'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _downloadDocument(context),
            icon: const Icon(Icons.download),
            label: const Text('Herunterladen'),
          ),
        ],
      ),
    );
  }

  Widget _buildUnsupportedTypeViewer(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.insert_drive_file, size: 120, color: Colors.grey),
          const SizedBox(height: 24),
          Text(
            document.fileName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Vorschau für diesen Dateityp nicht verfügbar',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _openInExternalApp(context),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Extern öffnen'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _downloadDocument(context),
            icon: const Icon(Icons.download),
            label: const Text('Herunterladen'),
          ),
        ],
      ),
    );
  }

  Future<void> _openInExternalApp(BuildContext context) async {
    try {
      final uri = Uri.parse(document.storageUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dokument konnte nicht geöffnet werden'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _downloadDocument(BuildContext context) async {
    try {
      final uri = Uri.parse(document.storageUrl);
      if (await canLaunchUrl(uri)) {
        // On mobile, this will trigger the browser's download
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Download konnte nicht gestartet werden'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download-Fehler: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Simple modal document viewer dialog
class DocumentViewerDialog extends StatelessWidget {
  final Document document;

  const DocumentViewerDialog({
    super.key,
    required this.document,
  });

  static Future<void> show(BuildContext context, Document document) {
    return showDialog(
      context: context,
      builder: (context) => DocumentViewerDialog(document: document),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: DocumentViewer(document: document),
      ),
    );
  }
}
