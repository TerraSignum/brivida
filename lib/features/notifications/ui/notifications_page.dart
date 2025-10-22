import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brivida_app/core/i18n/app_localizations.dart';
import 'package:brivida_app/core/models/notification.dart';
import 'package:brivida_app/features/notifications/logic/notifications_controller.dart';
import 'package:brivida_app/features/notifications/ui/notification_service.dart';
import 'package:brivida_app/core/utils/navigation_helpers.dart';

/// Page displaying the notifications inbox
class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  bool _showUnreadOnly = false;

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsInboxProvider);
    final unreadCountAsync = ref.watch(unreadNotificationsCountProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => popOrGoHome(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Benachrichtigungen'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          // Unread filter toggle
          IconButton(
            onPressed: () {
              setState(() {
                _showUnreadOnly = !_showUnreadOnly;
              });
            },
            icon: Icon(
              _showUnreadOnly ? Icons.filter_alt : Icons.filter_alt_outlined,
              color: _showUnreadOnly ? Theme.of(context).primaryColor : null,
            ),
            tooltip: _showUnreadOnly ? 'Alle anzeigen' : 'Nur ungelesene',
          ),

          // Mark all as read
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'mark_all_read':
                  await _markAllAsRead();
                  break;
                case 'delete_all':
                  await _deleteAllNotifications();
                  break;
                case 'test_notification':
                  await _createTestNotification();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.done_all),
                    SizedBox(width: 8),
                    Text('Alle als gelesen markieren'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep),
                    SizedBox(width: 8),
                    Text('Alle löschen'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'test_notification',
                child: Row(
                  children: [
                    Icon(Icons.bug_report),
                    SizedBox(width: 8),
                    Text('Test-Benachrichtigung'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Stats header
            unreadCountAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (error, stack) => const SizedBox.shrink(),
              data: (unreadCount) => unreadCount > 0
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications_active,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '$unreadCount ungelesene Benachrichtigung${unreadCount != 1 ? 'en' : ''}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Notifications list
            Expanded(
              child: notificationsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Fehler beim Laden der Benachrichtigungen: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(notificationsInboxProvider);
                        },
                        child: const Text('Erneut versuchen'),
                      ),
                    ],
                  ),
                ),
                data: (notifications) {
                  final filteredNotifications = _showUnreadOnly
                      ? notifications.where((n) => !n.read).toList()
                      : notifications;

                  if (filteredNotifications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _showUnreadOnly
                                ? Icons.done_all
                                : Icons.notifications_none,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _showUnreadOnly
                                ? 'Keine ungelesenen Benachrichtigungen'
                                : 'Keine Benachrichtigungen vorhanden',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _showUnreadOnly
                                ? 'Alle Ihre Benachrichtigungen sind bereits gelesen'
                                : 'Sie erhalten hier Benachrichtigungen über wichtige Ereignisse',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[500]),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(notificationsInboxProvider);
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = filteredNotifications[index];
                        return NotificationCard(
                          notification: notification,
                          onTap: () => _handleNotificationTap(notification),
                          onMarkRead: () =>
                              _markAsRead(notification.firestoreId),
                          onDelete: () =>
                              _deleteNotification(notification.firestoreId),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle notification tap
  void _handleNotificationTap(AppNotification notification) async {
    // Mark as read if not already
    if (!notification.read) {
      await _markAsRead(notification.firestoreId);
    }

    // Navigate to deeplink if available
    if (!mounted) return;

    final route = notification.deeplinkRoute;
    if (route != null) {
      // Use central notification navigation to ensure consistent routing
      NotificationService.navigateToRoute(
        route,
        relatedId: notification.entityId,
      );
    }
  }

  /// Mark notification as read
  Future<void> _markAsRead(String notificationId) async {
    try {
      await ref
          .read(notificationsControllerProvider.notifier)
          .markRead(notificationId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Markieren: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Mark all notifications as read
  Future<void> _markAllAsRead() async {
    try {
      await ref.read(notificationsControllerProvider.notifier).markAllRead();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alle Benachrichtigungen als gelesen markiert'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  /// Delete notification
  Future<void> _deleteNotification(String notificationId) async {
    try {
      await ref
          .read(notificationsControllerProvider.notifier)
          .deleteNotification(notificationId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Benachrichtigung gelöscht')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Löschen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Delete all notifications
  Future<void> _deleteAllNotifications() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alle löschen'),
        content: const Text(
          'Sind Sie sicher, dass Sie alle Benachrichtigungen löschen möchten? '
          'Diese Aktion kann nicht rückgängig gemacht werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(notificationsControllerProvider.notifier)
          .deleteAllNotifications();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alle Benachrichtigungen gelöscht'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Löschen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Create test notification
  Future<void> _createTestNotification() async {
    try {
      await ref
          .read(notificationsControllerProvider.notifier)
          .createTestNotification();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Test-Benachrichtigung erstellt'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Erstellen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Widget for displaying a single notification
class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkRead;
  final VoidCallback? onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onMarkRead,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.firestoreId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        onDelete?.call();
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        elevation: notification.read ? 1 : 3,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: notification.read
                        ? Colors.grey[300]
                        : Theme.of(context).primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: notification.read
                        ? Colors.grey[600]
                        : Theme.of(context).primaryColor,
                    size: 20,
                  ),
                ),

                const SizedBox(width: 12),

                // Notification content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and time
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: notification.read
                                        ? FontWeight.normal
                                        : FontWeight.w600,
                                  ),
                            ),
                          ),
                          Text(
                            notification.timeString,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Body
                      Text(
                        notification.body,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: notification.read ? Colors.grey[700] : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Type badge
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          notification.type.displayName(
                            AppLocalizations.of(context),
                          ),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Unread indicator
                if (!notification.read) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],

                // Actions menu
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'mark_read':
                        onMarkRead?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    if (!notification.read)
                      const PopupMenuItem(
                        value: 'mark_read',
                        child: Row(
                          children: [
                            Icon(Icons.done, size: 16),
                            SizedBox(width: 8),
                            Text('Als gelesen markieren'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 16),
                          SizedBox(width: 8),
                          Text('Löschen'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.leadNew:
        return Icons.work;
      case NotificationType.leadAccepted:
        return Icons.check_circle;
      case NotificationType.leadDeclined:
        return Icons.cancel;
      case NotificationType.jobAssigned:
        return Icons.assignment;
      case NotificationType.jobChanged:
        return Icons.edit;
      case NotificationType.jobCancelled:
        return Icons.event_busy;
      case NotificationType.reminder24h:
      case NotificationType.reminder1h:
        return Icons.alarm;
      case NotificationType.paymentCaptured:
      case NotificationType.paymentReleased:
        return Icons.payment;
      case NotificationType.paymentRefunded:
        return Icons.money_off;
      case NotificationType.disputeOpened:
      case NotificationType.disputeResponse:
      case NotificationType.disputeDecision:
        return Icons.gavel;
      case NotificationType.chatMessage:
        return Icons.message;
    }
  }
}
