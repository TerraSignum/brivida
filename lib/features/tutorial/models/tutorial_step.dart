import 'tutorial_context.dart';

typedef TutorialPredicate = bool Function(TutorialContext context);

/// Declarative representation of a single tutorial popup.
class TutorialStep {
  const TutorialStep({
    required this.titleKey,
    required this.bodyKey,
    this.isCompletion = false,
    this.predicate,
  });

  /// Localization key describing the dialog title.
  final String titleKey;

  /// Localization key describing the dialog body text.
  final String bodyKey;

  /// Marks the step as the final completion message for the screen.
  final bool isCompletion;

  /// Optional predicate to decide if the step should be displayed.
  final TutorialPredicate? predicate;

  /// True when the step should be rendered for the provided context.
  bool shouldDisplay(TutorialContext context) {
    if (predicate == null) {
      return true;
    }
    return predicate!.call(context);
  }
}
