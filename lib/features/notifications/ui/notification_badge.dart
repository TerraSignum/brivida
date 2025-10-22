import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brivida_app/features/notifications/logic/notifications_controller.dart';

/// Widget that shows notification count badge
class NotificationBadge extends ConsumerWidget {
  final Widget child;
  final bool showZero;

  const NotificationBadge({
    super.key,
    required this.child,
    this.showZero = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCountAsync = ref.watch(unreadNotificationsCountProvider);

    return unreadCountAsync.when(
      loading: () => child,
      error: (error, stack) => child,
      data: (count) => count > 0 || (showZero && count == 0)
          ? Badge(
              label: Text(
                count > 99 ? '99+' : count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.red,
              child: child,
            )
          : child,
    );
  }
}

/// Simple notification icon with badge
class NotificationIcon extends ConsumerWidget {
  final VoidCallback? onTap;
  final Color? color;
  final double? size;

  const NotificationIcon({
    super.key,
    this.onTap,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationBadge(
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          Icons.notifications,
          color: color,
          size: size,
        ),
        tooltip: 'Benachrichtigungen',
      ),
    );
  }
}

/// Floating action button with notification badge
class NotificationFAB extends ConsumerWidget {
  final VoidCallback? onPressed;

  const NotificationFAB({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationBadge(
      child: FloatingActionButton(
        onPressed: onPressed,
        tooltip: 'Benachrichtigungen',
        child: const Icon(Icons.notifications),
      ),
    );
  }
}

/// App bar with notification icon
class NotificationAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final List<Widget>? actions;

  const NotificationAppBar({
    super.key,
    required this.title,
    this.onNotificationTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        NotificationIcon(onTap: onNotificationTap),
        ...?actions,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Bottom navigation bar item with notification badge
class NotificationBottomNavItem extends ConsumerWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const NotificationBottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NotificationBadge(
              child: Icon(
                icon,
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
