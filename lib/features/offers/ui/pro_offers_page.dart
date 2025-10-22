import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/pro_offer.dart';
import '../../../core/utils/debug_logger.dart';
import '../../../core/utils/navigation_helpers.dart';
import '../../admin_services/ui/admin_service_status_banner.dart';
import '../logic/pro_offers_controller.dart';
import '../utils/offer_extra_options.dart';
import 'pro_offer_editor_page.dart';
import '../../tutorial/logic/tutorial_registry.dart';
import '../../tutorial/ui/tutorial_trigger.dart';

final _busyOfferIdsProvider = StateProvider<Set<String>>((ref) => <String>{});

class ProOffersPage extends ConsumerWidget {
  const ProOffersPage({super.key});

  static const routeName = '/pro/offers';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersAsync = ref.watch(proOffersStreamProvider);

    final content = PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        popOrGoHome(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => popOrGoHome(context),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text('proOffers.pageTitle'.tr()),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            DebugLogger.userAction('open_offer_editor_new');
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProOfferEditorPage()),
            );
          },
          icon: const Icon(Icons.add),
          label: Text('proOffers.newOffer'.tr()),
        ),
        body: offersAsync.when(
          data: (offers) {
            final bottomInset = MediaQuery.of(context).viewPadding.bottom;

            Future<void> refresh() {
              return ref.refresh(proOffersStreamProvider.future);
            }

            if (offers.isEmpty) {
              return RefreshIndicator(
                onRefresh: refresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 80 + bottomInset),
                  children: [
                    const AdminServiceStatusBanner(),
                    const SizedBox(height: 24),
                    _EmptyOffersState(
                      onCreate: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ProOfferEditorPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            final sortedOffers = List<ProOffer>.from(offers)
              ..sort((a, b) {
                if (a.isActive != b.isActive) {
                  return a.isActive ? -1 : 1;
                }
                final aDate =
                    a.updatedAt ??
                    a.createdAt ??
                    DateTime.fromMillisecondsSinceEpoch(0);
                final bDate =
                    b.updatedAt ??
                    b.createdAt ??
                    DateTime.fromMillisecondsSinceEpoch(0);
                return bDate.compareTo(aDate);
              });

            final activeCount = sortedOffers
                .where((offer) => offer.isActive)
                .length;
            final pausedCount = sortedOffers.length - activeCount;

            return RefreshIndicator(
              onRefresh: refresh,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16, 24, 16, 112 + bottomInset),
                itemCount: sortedOffers.length + 2,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const AdminServiceStatusBanner();
                  }
                  if (index == 1) {
                    return _OffersSummary(
                      activeCount: activeCount,
                      inactiveCount: pausedCount,
                    );
                  }
                  final offer = sortedOffers[index - 2];
                  return _OfferCard(offer: offer);
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) {
            DebugLogger.error('❌ Failed to load offers', error, stack);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text('proOffers.error.loadFailed'.tr()),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => ref.refresh(proOffersStreamProvider),
                    icon: const Icon(Icons.refresh),
                    label: Text('common.retry'.tr()),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    return TutorialTrigger(screen: TutorialScreen.proOffers, child: content);
  }
}

class _EmptyOffersState extends StatelessWidget {
  const _EmptyOffersState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.library_add, size: 56, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'proOffers.empty.title'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'proOffers.empty.subtitle'.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: Text('proOffers.empty.cta'.tr()),
          ),
        ],
      ),
    );
  }
}

class _OffersSummary extends StatelessWidget {
  const _OffersSummary({
    required this.activeCount,
    required this.inactiveCount,
  });

  final int activeCount;
  final int inactiveCount;

  @override
  Widget build(BuildContext context) {
    final total = activeCount + inactiveCount;
    final chips = <Widget>[
      _InfoChip(
        label: 'proOffers.summary.active'.tr(
          namedArgs: {'count': '$activeCount'},
        ),
      ),
    ];

    if (inactiveCount > 0) {
      chips.add(
        _InfoChip(
          label: 'proOffers.summary.inactive'.tr(
            namedArgs: {'count': '$inactiveCount'},
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'proOffers.summary.total'.tr(namedArgs: {'count': '$total'}),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: chips),
      ],
    );
  }
}

class _OfferCard extends ConsumerWidget {
  const _OfferCard({required this.offer});

  final ProOffer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(proOffersControllerProvider);
    final busyIds = ref.watch(_busyOfferIdsProvider);
    final isBusy = offer.id != null && busyIds.contains(offer.id);
    final weekdayLabel = plural(
      'proOffers.card.weekdayCount',
      offer.weekdays.length,
      namedArgs: {'count': '${offer.weekdays.length}'},
    );
    final selectedExtraIds = offer.extras.selectedIds;

    Future<void> handleToggle(bool value) async {
      final offerId = offer.id;
      if (offerId == null) {
        return;
      }
      final busyNotifier = ref.read(_busyOfferIdsProvider.notifier);
      busyNotifier.update((state) {
        final updated = {...state};
        updated.add(offerId);
        return updated;
      });

      try {
        DebugLogger.userAction('toggle_offer_active', {
          'offerId': offerId,
          'to': value,
        });
        await controller.toggleOfferActive(offerId, value);
      } catch (error, stack) {
        DebugLogger.error('❌ Failed to toggle offer', error, stack);
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('proOffers.messages.toggleFailed'.tr())),
        );
      } finally {
        busyNotifier.update((state) {
          final updated = {...state};
          updated.remove(offerId);
          return updated;
        });
      }
    }

    Future<void> handleDelete() async {
      final offerId = offer.id;
      if (offerId == null) {
        return;
      }
      final busyNotifier = ref.read(_busyOfferIdsProvider.notifier);
      busyNotifier.update((state) {
        final updated = {...state};
        updated.add(offerId);
        return updated;
      });

      try {
        DebugLogger.userAction('delete_offer_confirmed', {'offerId': offerId});
        await controller.deleteOffer(offerId);
      } catch (error, stack) {
        DebugLogger.error('❌ Failed to delete offer', error, stack);
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('proOffers.messages.deleteFailed'.tr())),
        );
      } finally {
        busyNotifier.update((state) {
          final updated = {...state};
          updated.remove(offerId);
          return updated;
        });
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    offer.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                SizedBox(
                  width: 64,
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Switch.adaptive(
                        value: offer.isActive,
                        onChanged: (offer.id == null || isBusy)
                            ? null
                            : (value) => handleToggle(value),
                      ),
                      if (isBusy)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(label: weekdayLabel),
                _InfoChip(
                  label: 'proOffers.card.timeRange'.tr(
                    namedArgs: {'from': offer.timeFrom, 'to': offer.timeTo},
                  ),
                ),
                _InfoChip(
                  label: 'proOffers.card.radius'.tr(
                    namedArgs: {'km': '${offer.serviceRadiusKm}'},
                  ),
                ),
                _InfoChip(label: '${offer.minHours}–${offer.maxHours} h'),
                if (offer.acceptsRecurring)
                  _InfoChip(label: 'proOffers.card.recurring'.tr()),
              ],
            ),
            if (selectedExtraIds.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: offerExtraOptions
                    .where((option) => selectedExtraIds.contains(option.id))
                    .map((option) => _InfoChip(label: option.labelKey.tr()))
                    .toList(),
              ),
            ],
            if (offer.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(offer.notes, style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton.icon(
                  onPressed: isBusy
                      ? null
                      : () async {
                          if (offer.id == null) {
                            return;
                          }
                          DebugLogger.userAction('open_offer_editor_existing', {
                            'offerId': offer.id,
                          });
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProOfferEditorPage(offer: offer),
                            ),
                          );
                        },
                  icon: const Icon(Icons.edit),
                  label: Text('proOffers.card.edit'.tr()),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: isBusy
                      ? null
                      : () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: Text('proOffers.dialog.deleteTitle'.tr()),
                              content: Text(
                                'proOffers.dialog.deleteBody'.tr(
                                  namedArgs: {'title': offer.title},
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(false),
                                  child: Text('common.cancel'.tr()),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: Text('common.delete'.tr()),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            await handleDelete();
                          }
                        },
                  icon: const Icon(Icons.delete_outline),
                  label: Text('common.delete'.tr()),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
      backgroundColor: Colors.grey.withValues(alpha: 0.1),
    );
  }
}
