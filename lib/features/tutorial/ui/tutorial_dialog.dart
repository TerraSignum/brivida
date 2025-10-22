import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../logic/tutorial_registry.dart';
import '../models/tutorial_step.dart';

class TutorialDialogResult {
  const TutorialDialogResult({required this.disableTutorial});

  final bool disableTutorial;
}

Future<TutorialDialogResult?> showTutorialDialog({
  required BuildContext context,
  required TutorialScreen screen,
  required TutorialStep step,
  required int stepIndex,
  required int totalSteps,
}) {
  return showDialog<TutorialDialogResult>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      var disableTutorial = false;
      final theme = Theme.of(dialogContext);
      final title = step.titleKey.tr();
      final body = step.bodyKey.tr();
      final stepLabel = 'tutorial.global.stepIndicator'.tr(
        namedArgs: {'current': '${stepIndex + 1}', 'total': '$totalSteps'},
      );
      final confirmLabel = step.isCompletion
          ? 'tutorial.global.finish'.tr()
          : 'tutorial.global.ok'.tr();

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stepLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(title),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(body, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    value: disableTutorial,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text('tutorial.global.neverShow'.tr()),
                    onChanged: (value) {
                      setState(() {
                        disableTutorial = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(
                    dialogContext,
                  ).pop(TutorialDialogResult(disableTutorial: disableTutorial));
                },
                child: Text(confirmLabel),
              ),
            ],
          );
        },
      );
    },
  );
}
