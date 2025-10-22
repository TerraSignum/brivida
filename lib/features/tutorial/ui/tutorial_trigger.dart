import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/user_role_provider.dart';
import '../logic/tutorial_controller.dart';
import '../logic/tutorial_registry.dart';
import '../models/tutorial_context.dart';

/// Wraps a screen and triggers the tutorial popups when appropriate.
class TutorialTrigger extends ConsumerStatefulWidget {
  const TutorialTrigger({super.key, required this.screen, required this.child});

  final TutorialScreen screen;
  final Widget child;

  @override
  ConsumerState<TutorialTrigger> createState() => _TutorialTriggerState();
}

class _TutorialTriggerState extends ConsumerState<TutorialTrigger> {
  final Set<AppUserRole?> _handledRoles = <AppUserRole?>{};

  @override
  Widget build(BuildContext context) {
    final roleAsync = ref.watch(userRoleProvider);

    roleAsync.whenData((role) {
      if (_handledRoles.contains(role)) {
        return;
      }
      _handledRoles.add(role);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        final notifier = ref.read(tutorialControllerProvider.notifier);
        notifier.maybeShowTutorial(
          context: context,
          screen: widget.screen,
          tutorialContext: TutorialContext(role: role),
        );
      });
    });

    return widget.child;
  }
}
