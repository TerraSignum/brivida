import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/models/document.dart';
import '../../../core/providers/firebase_providers.dart';
import '../logic/documents_controller.dart';
import 'document_viewer.dart';

/// PG-17: Document verification UI for pro identity and credentials
class DocumentVerificationPage extends ConsumerStatefulWidget {
  const DocumentVerificationPage({super.key});

  @override
  ConsumerState<DocumentVerificationPage> createState() =>
      _DocumentVerificationPageState();
}

class _DocumentVerificationPageState
    extends ConsumerState<DocumentVerificationPage> {
  @override
  void initState() {
    super.initState();
    // Load documents for current user
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = ref.read(currentUserDataProvider);
      if (currentUser != null) {
        ref
            .read(documentsControllerProvider.notifier)
            .loadDocuments(currentUser.uid);
      }
    });
  }

  // Required document types for verification
  final Map<DocumentType, Map<String, dynamic>> _requiredDocuments = {
    DocumentType.idCard: {
      'title': 'Personalausweis',
      'description': 'Vorder- und Rückseite Ihres gültigen Personalausweises',
      'icon': Icons.badge,
      'required': true,
      'color': Colors.blue,
    },
    DocumentType.criminalRecord: {
      'title': 'Führungszeugnis',
      'description':
          'Aktuelles erweitertes Führungszeugnis (nicht älter als 3 Monate)',
      'icon': Icons.verified_user,
      'required': true,
      'color': Colors.green,
    },
    DocumentType.insuranceCertificate: {
      'title': 'Haftpflichtversicherung',
      'description': 'Nachweis einer gültigen Haftpflichtversicherung',
      'icon': Icons.security,
      'required': true,
      'color': Colors.orange,
    },
    DocumentType.trainingCertificate: {
      'title': 'Qualifikationsnachweis',
      'description': 'Zertifikat oder Nachweis für Reinigungsqualifikationen',
      'icon': Icons.school,
      'required': false,
      'color': Colors.purple,
    },
    DocumentType.businessLicense: {
      'title': 'Gewerbeschein',
      'description': 'Nur für gewerblich tätige Reinigungskräfte',
      'icon': Icons.business,
      'required': false,
      'color': Colors.teal,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('📋 Dokumente & Verifizierung'),
        actions: [
          IconButton(
            onPressed: _showVerificationInfo,
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVerificationStatus(),
            const SizedBox(height: 24),
            _buildDocumentsList(),
            const SizedBox(height: 24),
            _buildUploadSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationStatus() {
    final documentsAsync = ref.watch(documentsControllerProvider);

    return documentsAsync.when(
      data: (documents) {
        final completedRequired = _requiredDocuments.entries
            .where((entry) => entry.value['required'] == true)
            .where((entry) => documents.any((doc) =>
                doc.type == entry.key && doc.status == DocumentStatus.approved))
            .length;

        final totalRequired = _requiredDocuments.entries
            .where((entry) => entry.value['required'] == true)
            .length;

        final isFullyVerified = completedRequired == totalRequired;
        final progress =
            totalRequired > 0 ? completedRequired / totalRequired : 0.0;

        return _buildVerificationStatusCard(
            isFullyVerified, progress, completedRequired, totalRequired);
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, _) => Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Fehler beim Laden: $error'),
        ),
      ),
    );
  }

  Widget _buildVerificationStatusCard(bool isFullyVerified, double progress,
      int completedRequired, int totalRequired) {
    return Card(
      color: isFullyVerified ? Colors.green.shade50 : Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isFullyVerified ? Icons.verified : Icons.pending,
                  color: isFullyVerified ? Colors.green : Colors.orange,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  isFullyVerified
                      ? 'Vollständig verifiziert'
                      : 'Verifizierung ausstehend',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isFullyVerified ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                isFullyVerified ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$completedRequired von $totalRequired Pflichtdokumenten verifiziert',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            if (!isFullyVerified) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Unvollständige Verifizierung kann zu eingeschränkter Sichtbarkeit führen.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsList() {
    final documentsAsync = ref.watch(documentsControllerProvider);

    return documentsAsync.when(
      data: (documents) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dokumente',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._requiredDocuments.entries.map((entry) {
            final docType = entry.key;
            final docInfo = entry.value;
            final existingDoc = documents
                .where((doc) => doc.type == docType)
                .fold<Document?>(null, (current, doc) => current ?? doc);

            return _buildDocumentCard(docType, docInfo, existingDoc);
          }),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text('Fehler beim Laden der Dokumente: $error'),
    );
  }

  Widget _buildDocumentCard(
    DocumentType type,
    Map<String, dynamic> info,
    Document? existingDoc,
  ) {
    final hasDocument = existingDoc?.id != null;
    final status = existingDoc?.status ?? DocumentStatus.pending;

    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (status) {
      case DocumentStatus.approved:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Genehmigt';
        break;
      case DocumentStatus.reviewing:
        statusColor = Colors.blue;
        statusIcon = Icons.hourglass_empty;
        statusText = 'In Prüfung';
        break;
      case DocumentStatus.rejected:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'Abgelehnt';
        break;
      case DocumentStatus.expired:
        statusColor = Colors.grey;
        statusIcon = Icons.history;
        statusText = 'Abgelaufen';
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.upload_file;
        statusText = hasDocument ? 'Hochgeladen' : 'Ausstehend';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (info['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    info['icon'] as IconData,
                    color: info['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            info['title'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (info['required'] == true) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'PFLICHT',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        info['description'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (hasDocument) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        existingDoc!.fileName,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (existingDoc.uploadedAt != null)
                      Text(
                        '${existingDoc.uploadedAt!.day}.${existingDoc.uploadedAt!.month}.${existingDoc.uploadedAt!.year}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
              if (status == DocumentStatus.rejected &&
                  existingDoc.rejectionReason != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Ablehnungsgrund: ${existingDoc.rejectionReason}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                if (!hasDocument || status == DocumentStatus.rejected)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _uploadDocument(type),
                      icon: const Icon(Icons.upload, size: 16),
                      label:
                          Text(hasDocument ? 'Erneut hochladen' : 'Hochladen'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: info['color'] as Color,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                if (hasDocument && status != DocumentStatus.rejected) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _viewDocument(existingDoc!),
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('Anzeigen'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _replaceDocument(type),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Ersetzen'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📤 Upload-Hinweise',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildUploadTip(
              Icons.photo_camera,
              'Gute Fotoqualität',
              'Sorgen Sie für ausreichend Licht und scharfe Aufnahmen',
            ),
            _buildUploadTip(
              Icons.crop_free,
              'Vollständig sichtbar',
              'Alle Informationen auf dem Dokument müssen lesbar sein',
            ),
            _buildUploadTip(
              Icons.file_present,
              'Unterstützte Formate',
              'JPG, PNG, PDF (max. 10 MB pro Datei)',
            ),
            _buildUploadTip(
              Icons.security,
              'Datenschutz',
              'Ihre Dokumente werden verschlüsselt gespeichert und nur für die Verifizierung verwendet',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadTip(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadDocument(DocumentType type) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => _buildUploadOptions(),
    );

    if (result == null) return;

    try {
      File? file;

      if (result == 'camera') {
        final image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );
        if (image != null) {
          file = File(image.path);
        }
      } else if (result == 'gallery') {
        final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );
        if (image != null) {
          file = File(image.path);
        }
      } else if (result == 'file') {
        final fileResult = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        );
        if (fileResult != null) {
          file = File(fileResult.files.single.path!);
        }
      }

      if (file != null) {
        final currentUser = ref.read(currentUserDataProvider);
        if (currentUser == null) {
          throw Exception('User not authenticated');
        }

        // Upload document via repository
        await ref.read(documentsControllerProvider.notifier).uploadDocument(
              proUid: currentUser.uid,
              type: type,
              file: file,
              fileName: file.path.split('/').last,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dokument erfolgreich hochgeladen!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Upload: $e')),
        );
      }
    } finally {
      // Loading state removed - no longer needed
    }
  }

  Widget _buildUploadOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Dokument hochladen',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Foto aufnehmen'),
            onTap: () => Navigator.pop(context, 'camera'),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Aus Galerie wählen'),
            onTap: () => Navigator.pop(context, 'gallery'),
          ),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Datei auswählen'),
            onTap: () => Navigator.pop(context, 'file'),
          ),
        ],
      ),
    );
  }

  void _replaceDocument(DocumentType type) {
    _uploadDocument(type);
  }

  void _viewDocument(Document document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentViewer(document: document),
      ),
    );
  }

  void _showVerificationInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ℹ️ Verifizierungsprozess'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Warum ist die Verifizierung wichtig?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• Vertrauen bei Kunden aufbauen\n'
                '• Rechtliche Absicherung\n'
                '• Höhere Sichtbarkeit in der App\n'
                '• Zugang zu Premium-Features',
              ),
              SizedBox(height: 16),
              Text(
                'Bearbeitungszeit:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                  'In der Regel 1-3 Werktage nach Einreichung aller Dokumente.'),
              SizedBox(height: 16),
              Text(
                'Bei Fragen:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                  'Kontaktieren Sie unseren Support unter support@brivida.com'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }
}
