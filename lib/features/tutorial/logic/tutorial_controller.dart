import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/debug_logger.dart';
import '../data/tutorial_repository.dart';
import '../models/tutorial_context.dart';
import '../models/tutorial_state.dart';
import '../logic/tutorial_registry.dart';
import '../ui/tutorial_dialog.dart';

final tutorialControllerProvider =
    StateNotifierProvider<
      TutorialControllerNotifier,
      AsyncValue<TutorialState>
    >((ref) {
      final repository = ref.watch(tutorialRepositoryProvider);
      return TutorialControllerNotifier(repository: repository);
    });

class TutorialControllerNotifier
    extends StateNotifier<AsyncValue<TutorialState>> {
  TutorialControllerNotifier({required TutorialRepository repository})
    : _repository = repository,
      super(const AsyncValue.loading()) {
    final future = _load();
    _loadFuture = future;
  }

  final TutorialRepository _repository;
  Future<void>? _loadFuture;
  bool _isShowing = false;

  Future<void> _load() async {
    try {
      final snapshot = await _repository.loadState();
      state = AsyncValue.data(snapshot);
    } catch (error, stackTrace) {
      DebugLogger.error(
        '🎓 TutorialController: load failed',
        error,
        stackTrace,
      );
      state = AsyncValue.error(error, stackTrace);
    } finally {
      _loadFuture = null;
    }
  }

  Future<void> _ensureLoaded() async {
    final pending = _loadFuture;
    if (pending != null) {
      await pending;
      return;
    }

    if (!state.hasValue) {
      final future = _load();
      _loadFuture = future;
      await future;
    }
  }

  Future<void> maybeShowTutorial({
    required BuildContext context,
    required TutorialScreen screen,
    TutorialContext? tutorialContext,
  }) async {
    await _ensureLoaded();

    final current = state.valueOrNull;
    if (current == null) {
      return;
    }

    if (current.disabled) {
      DebugLogger.debug('🎓 TutorialController: tutorial disabled, skip', {
        'screen': screen.id,
      });
      return;
    }

    if (current.isScreenCompleted(screen.id)) {
      return;
    }

    if (_isShowing) {
      DebugLogger.debug('🎓 TutorialController: already showing dialog', {
        'screen': screen.id,
      });
      return;
    }

    final contextData = tutorialContext ?? const TutorialContext();
    final steps = TutorialRegistry.stepsFor(screen, contextData);

    if (steps.isEmpty) {
      DebugLogger.debug('🎓 TutorialController: no steps for screen', {
        'screen': screen.id,
      });
      await _markScreenCompleted(screen.id);
      return;
    }

    _isShowing = true;
    try {
      for (var index = 0; index < steps.length; index++) {
        if (!context.mounted) {
          break;
        }

        final step = steps[index];
        final result = await showTutorialDialog(
          context: context,
          screen: screen,
          step: step,
          stepIndex: index,
          totalSteps: steps.length,
        );

        if (result == null) {
          DebugLogger.debug('🎓 TutorialController: dialog dismissed', {
            'screen': screen.id,
            'step': index,
          });
          return;
        }

        if (result.disableTutorial) {
          await _disableTutorial();
          return;
        }
      }

      await _markScreenCompleted(screen.id);
    } finally {
      _isShowing = false;
    }
  }

  Future<void> _markScreenCompleted(String screenId) async {
    final current = state.valueOrNull ?? TutorialState.initial();
    final updated = current.markScreenCompleted(screenId);
    state = AsyncValue.data(updated);
    await _repository.saveState(updated);
  }

  Future<void> _disableTutorial() async {
    final current = state.valueOrNull ?? TutorialState.initial();
    final updated = current.copyWith(disabled: true);
    state = AsyncValue.data(updated);
    await _repository.saveState(updated);
  }

  Future<void> resetTutorial() async {
    state = const AsyncValue.loading();
    try {
      final snapshot = await _repository.resetState();
      state = AsyncValue.data(snapshot);
    } catch (error, stackTrace) {
      DebugLogger.error(
        '🎓 TutorialController: reset failed',
        error,
        stackTrace,
      );
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
