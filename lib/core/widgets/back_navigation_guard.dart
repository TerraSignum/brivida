import 'package:flutter/material.dart';

import '../../app/router.dart' show appRouter;

/// Allows screens to override the fallback route that should be used when the
/// system back button is pressed and there is no deeper navigation stack.
class BackNavigationConfig extends InheritedWidget {
  const BackNavigationConfig({
    super.key,
    required this.fallbackRoute,
    required super.child,
  });

  final String fallbackRoute;

  static BackNavigationConfig? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BackNavigationConfig>();
  }

  @override
  bool updateShouldNotify(BackNavigationConfig oldWidget) =>
      oldWidget.fallbackRoute != fallbackRoute;
}

/// Provides consistent handling of the Android back button across the app.
///
/// When the user presses back we prefer to
/// 1. Pop the active route if possible.
/// 2. Navigate to the configured fallback route (defaults to `/home`).
/// 3. If already on the fallback route, allow the system to exit the app.
class BackNavigationGuard extends StatelessWidget {
  const BackNavigationGuard({
    super.key,
    required this.child,
    this.fallbackRoute = '/home',
  });

  final Widget child;
  final String fallbackRoute;

  bool _popActiveRoute([NavigatorState? cachedNavigator]) {
    if (appRouter.canPop()) {
      appRouter.pop();
      return true;
    }

    final navigator =
        cachedNavigator ?? appRouter.routerDelegate.navigatorKey.currentState;
    if (navigator?.canPop() ?? false) {
      navigator!.pop();
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RouteInformation>(
      valueListenable: appRouter.routeInformationProvider,
      builder: (context, routeInfo, inheritedChild) {
        final navigatorState =
            appRouter.routerDelegate.navigatorKey.currentState;
        final currentUri = routeInfo.uri;
        final currentPath = currentUri.path.isEmpty ? '/' : currentUri.path;

        final effectiveFallback =
            BackNavigationConfig.maybeOf(context)?.fallbackRoute ??
            fallbackRoute;
        final canPopRouter = appRouter.canPop();
        final canPopNavigator = navigatorState?.canPop() ?? false;
        final shouldIntercept =
            canPopRouter || canPopNavigator || currentPath != effectiveFallback;

        return PopScope(
          canPop: shouldIntercept,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;

            if (_popActiveRoute(navigatorState)) {
              return;
            }

            final latestUri = appRouter.routeInformationProvider.value.uri;
            final latestPath = latestUri.path.isEmpty ? '/' : latestUri.path;

            if (latestPath != effectiveFallback) {
              appRouter.go(effectiveFallback);
            }
          },
          child: inheritedChild ?? child,
        );
      },
      child: child,
    );
  }
}
