import 'package:collection/collection.dart';

/// Runtime representation of the tutorial status for the authenticated user.
class TutorialState {
  TutorialState({this.disabled = false, Map<String, bool>? completedScreens})
    : completedScreens = Map.unmodifiable(
        completedScreens ?? const <String, bool>{},
      );

  /// Global flag that disables all tutorial popups for the user.
  final bool disabled;

  /// Map of screen identifiers that have been completed by the user.
  final Map<String, bool> completedScreens;

  /// Returns a state that skips all tutorials (used for signed-out scenarios).
  TutorialState.disabled()
    : disabled = true,
      completedScreens = const <String, bool>{};

  /// Default empty state.
  factory TutorialState.initial() => TutorialState();

  /// Recreates the state from Firestore payloads.
  factory TutorialState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return TutorialState();
    }

    final disabled = json['disabled'] is bool
        ? json['disabled'] as bool
        : false;

    final rawCompleted = json['completedScreens'];
    final completed = <String, bool>{};

    if (rawCompleted is Map) {
      rawCompleted.forEach((key, value) {
        if (key == null) {
          return;
        }
        final screenId = key.toString();
        final isCompleted = value is bool ? value : value == true;
        if (isCompleted) {
          completed[screenId] = true;
        }
      });
    } else if (rawCompleted is Iterable) {
      for (final entry in rawCompleted) {
        if (entry is String) {
          completed[entry] = true;
        } else if (entry is MapEntry) {
          final key = entry.key?.toString();
          if (key != null && entry.value == true) {
            completed[key] = true;
          }
        }
      }
    }

    return TutorialState(disabled: disabled, completedScreens: completed);
  }

  /// Serializes the state into a Firestore-friendly map.
  Map<String, dynamic> toJson() => {
    'disabled': disabled,
    'completedScreens': completedScreens,
  };

  /// Returns true when a screen already finished its walkthrough.
  bool isScreenCompleted(String screenId) => completedScreens[screenId] == true;

  /// Creates a new state with specific fields updated.
  TutorialState copyWith({
    bool? disabled,
    Map<String, bool>? completedScreens,
  }) {
    return TutorialState(
      disabled: disabled ?? this.disabled,
      completedScreens: completedScreens ?? this.completedScreens,
    );
  }

  /// Marks a screen identifier as completed.
  TutorialState markScreenCompleted(String screenId) {
    final updated = Map<String, bool>.from(completedScreens)
      ..update(screenId, (_) => true, ifAbsent: () => true);
    return copyWith(completedScreens: updated);
  }

  /// Removes completion markers for every screen.
  TutorialState resetScreens() => TutorialState();

  @override
  bool operator ==(Object other) {
    return other is TutorialState &&
        other.disabled == disabled &&
        const DeepCollectionEquality().equals(
          other.completedScreens,
          completedScreens,
        );
  }

  @override
  int get hashCode => Object.hash(
    disabled,
    const DeepCollectionEquality().hash(completedScreens),
  );

  @override
  String toString() =>
      'TutorialState(disabled: $disabled, completedScreens: $completedScreens)';
}
