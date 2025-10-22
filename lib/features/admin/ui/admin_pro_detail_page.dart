import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/admin.dart';
import '../logic/admin_controller.dart';
import '../../../core/utils/navigation_helpers.dart';

class AdminProDetailPage extends ConsumerWidget {
  final String proUid;

  const AdminProDetailPage({super.key, required this.proUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proDetail = ref.watch(proDetailProvider(proUid));
    final abuseEvents = ref.watch(abuseEventsProvider(proUid));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          popOrGoHome(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () => popOrGoHome(context),
          ),
          title: const Text('Pro Details'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.invalidate(proDetailProvider(proUid));
                ref.invalidate(abuseEventsProvider(proUid));
              },
            ),
          ],
        ),
        body: proDetail.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (pro) {
            if (pro == null) {
              return const Center(child: Text('Pro not found'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProHeader(context, pro),
                  const SizedBox(height: 16),
                  _buildHealthScoreCard(context, pro),
                  const SizedBox(height: 16),
                  _buildBadgesSection(context, ref, pro),
                  const SizedBox(height: 16),
                  _buildFlagsSection(context, ref, pro),
                  const SizedBox(height: 16),
                  _buildAbuseEventsSection(context, abuseEvents),
                  const SizedBox(height: 16),
                  _buildAdminActions(context, ref, pro),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProHeader(BuildContext context, Map<String, dynamic> pro) {
    final name = (pro['name'] as String?)?.trim();
    final email = (pro['email'] as String?)?.trim();
    final phone = (pro['phone'] as String?)?.trim();
    final createdAt = pro['createdAt'];
    final formattedCreatedAt = _formatDate(createdAt);
    final avatarInitial = (name != null && name.isNotEmpty)
        ? name.substring(0, 1).toUpperCase()
        : '?';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: pro['photoUrl'] != null
                  ? NetworkImage(pro['photoUrl'])
                  : null,
              child: pro['photoUrl'] == null
                  ? Text(avatarInitial, style: const TextStyle(fontSize: 24))
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? 'Unbekannt',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    email ?? 'Keine E-Mail',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (phone != null && phone.isNotEmpty)
                    Text(phone, style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    'Erstellt: $formattedCreatedAt',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthScoreCard(BuildContext context, Map<String, dynamic> pro) {
    final health = pro['health'] as HealthScore?;
    if (health == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Health Score',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text('Kein Health Score verfügbar'),
            ],
          ),
        ),
      );
    }

    final score = health.score;
    final scoreColor = health.scoreColor;
    final scoreGrade = health.scoreGrade;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Health Score',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: scoreColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$scoreGrade (${score.toStringAsFixed(1)})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Health Score Metrics
            _buildHealthMetric(
              'No-Show Rate',
              '${(health.noShowRate * 100).toStringAsFixed(1)}%',
            ),
            _buildHealthMetric(
              'Cancel Rate',
              '${(health.cancelRate * 100).toStringAsFixed(1)}%',
            ),
            _buildHealthMetric(
              'Response Time',
              '${health.avgResponseMins.toStringAsFixed(0)} Min',
            ),
            _buildHealthMetric(
              'In-App Ratio',
              '${(health.inAppRatio * 100).toStringAsFixed(1)}%',
            ),
            _buildHealthMetric(
              'Rating Average',
              '${health.ratingAvg.toStringAsFixed(1)}/5',
            ),
            _buildHealthMetric('Rating Count', '${health.ratingCount}'),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthMetric(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBadgesSection(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> pro,
  ) {
    final badges = (pro['badges'] as List<ProBadge>? ?? const <ProBadge>[]);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Badges', style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showAddBadgeDialog(context, ref, proUid),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (badges.isEmpty)
              const Text('Keine Badges')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: badges.map((badge) {
                  return Chip(
                    label: Text(badge.displayName),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      ref
                          .read(adminControllerProvider.notifier)
                          .removeBadge(proUid: proUid, badge: badge);
                    },
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagsSection(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> pro,
  ) {
    final flags = pro['flags'] as ProFlags? ?? const ProFlags();
    final isSoftBanned = flags.softBanned;
    final isHardBanned = flags.hardBanned;
    final flagsNotes = flags.notes.isNotEmpty ? flags.notes : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Flags & Bans', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                Switch(
                  value: isSoftBanned,
                  onChanged: (value) {
                    ref
                        .read(adminControllerProvider.notifier)
                        .setProFlags(proUid: proUid, softBanned: value);
                  },
                ),
                const SizedBox(width: 8),
                const Text('Soft Ban (Warteschlange runterpriorisiert)'),
              ],
            ),
            Row(
              children: [
                Switch(
                  value: isHardBanned,
                  onChanged: (value) {
                    ref
                        .read(adminControllerProvider.notifier)
                        .setProFlags(proUid: proUid, hardBanned: value);
                  },
                ),
                const SizedBox(width: 8),
                const Text('Hard Ban (Komplett gesperrt)'),
              ],
            ),
            if (flagsNotes != null) ...[
              const SizedBox(height: 8),
              Text(
                'Notizen: $flagsNotes',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 8),
            TextButton(
              onPressed: () =>
                  _showEditNotesDialog(context, ref, proUid, flagsNotes),
              child: const Text('Notizen bearbeiten'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbuseEventsSection(
    BuildContext context,
    AsyncValue<List<AbuseEvent>> abuseEvents,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Abuse Events', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            abuseEvents.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
              data: (events) {
                if (events.isEmpty) {
                  return const Text('Keine Abuse Events');
                }

                return Column(
                  children: events.map((event) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(event.type.displayName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (event.description != null)
                              Text(event.description!),
                            Text('Weight: ${event.weight}'),
                            Text('Date: ${_formatDate(event.createdAt)}'),
                          ],
                        ),
                        leading: CircleAvatar(
                          child: Text(event.weight.toString()),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminActions(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> pro,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Health neu berechnen'),
                  onPressed: () {
                    ref
                        .read(adminControllerProvider.notifier)
                        .recalculateHealth(proUid: proUid);
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.warning),
                  label: const Text('Abuse Event erstellen'),
                  onPressed: () =>
                      _showCreateAbuseEventDialog(context, ref, proUid),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text('Profil anzeigen'),
                  onPressed: () => context.go('/admin/pro/$proUid'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBadgeDialog(BuildContext context, WidgetRef ref, String proUid) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Badge hinzufügen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ProBadge.values.map((badge) {
              return ListTile(
                title: Text(badge.displayName),
                onTap: () {
                  Navigator.of(context).pop();
                  ref
                      .read(adminControllerProvider.notifier)
                      .addBadge(proUid: proUid, badge: badge);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showEditNotesDialog(
    BuildContext context,
    WidgetRef ref,
    String proUid,
    String? currentNotes,
  ) {
    final controller = TextEditingController(text: currentNotes ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notizen bearbeiten'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Notizen eingeben...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref
                    .read(adminControllerProvider.notifier)
                    .setProFlags(
                      proUid: proUid,
                      notes: controller.text.trim().isEmpty
                          ? null
                          : controller.text.trim(),
                    );
              },
              child: const Text('Speichern'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateAbuseEventDialog(
    BuildContext context,
    WidgetRef ref,
    String proUid,
  ) {
    AbuseEventType? selectedType;
    final descriptionController = TextEditingController();
    final weightController = TextEditingController(text: '1.0');

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Abuse Event erstellen'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<AbuseEventType>(
                    value: selectedType,
                    hint: const Text('Event Type wählen'),
                    items: AbuseEventType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Beschreibung',
                      hintText: 'Details zum Event...',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight (0.1 - 10.0)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Abbrechen'),
                ),
                ElevatedButton(
                  onPressed: selectedType == null
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          final weight =
                              double.tryParse(weightController.text) ?? 1.0;
                          ref
                              .read(adminControllerProvider.notifier)
                              .createAbuseEvent(
                                userUid: proUid,
                                type: selectedType!,
                                weight: weight.clamp(0.1, 10.0),
                                description:
                                    descriptionController.text.trim().isEmpty
                                    ? null
                                    : descriptionController.text.trim(),
                              );
                        },
                  child: const Text('Erstellen'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Unbekannt';

    try {
      if (date is Timestamp) {
        return _formatDate(date.toDate());
      } else if (date is String) {
        final parsed = DateTime.parse(date);
        return '${parsed.day}.${parsed.month}.${parsed.year}';
      } else if (date is DateTime) {
        return '${date.day}.${date.month}.${date.year}';
      }
    } catch (e) {
      // Ignore parsing errors
    }

    return 'Unbekannt';
  }
}
