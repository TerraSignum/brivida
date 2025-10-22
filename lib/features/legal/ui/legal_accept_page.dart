import 'package:flutter/widgets.dart';

/// Deprecated placeholder. Legal consent is now captured during sign-up,
/// so this widget remains only to avoid import churn in generated artifacts.
@Deprecated(
  'Legal consent handled during sign-up; this screen is no longer used.',
)
class LegalAcceptPage extends StatelessWidget {
  const LegalAcceptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
