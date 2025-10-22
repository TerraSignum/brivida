import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../logic/auth_controller.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/language_footer.dart';
import '../../../core/models/legal.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedLegal = false;
  bool _showLegalError = false;
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () => _openLegal('terms');
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () => _openLegal('privacy');
  }

  Future<void> _signUp() async {
    if (!_acceptedLegal) {
      setState(() {
        _showLegalError = true;
      });
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      await ref
          .read(authControllerProvider.notifier)
          .signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            consentLanguage: _resolveConsentLanguage(),
          );

      // Show success message and redirect to sign in
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Konto erstellt! Bitte überprüfen Sie Ihre E-Mail zur Verifizierung.',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/sign-in');
      }
    }
  }

  SupportedLanguage _resolveConsentLanguage() {
    final code = context.locale.languageCode;
    switch (code) {
      case 'de':
        return SupportedLanguage.de;
      case 'pt':
        return SupportedLanguage.pt;
      case 'es':
        return SupportedLanguage.es;
      case 'fr':
        return SupportedLanguage.fr;
      case 'en':
      default:
        return SupportedLanguage.en;
    }
  }

  void _openLegal(String route) {
    final lang = _resolveConsentLanguage().name;
    context.push('/legal/$route?lang=$lang');
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bitte bestätigen Sie Ihr Passwort';
    }
    if (value != _passwordController.text) {
      return 'Passwörter stimmen nicht überein';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light background
      body: Column(
        children: [
          // Logo Banner/Header - Full Width
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/logo2.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: const Color(0xFF6366F1),
                  child: const Center(
                    child: Icon(
                      Icons.cleaning_services,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          // Content Area
          Expanded(
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Welcome Text
                          Text(
                            'Bei Brivida registrieren',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1F2937),
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Erstellen Sie Ihr Konto und finden Sie Reinigungskräfte',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: const Color(0xFF6B7280)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),

                          // Registration Form Card
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Email Field
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: 'E-Mail-Adresse',
                                    hintText: 'max@example.com',
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: Color(0xFF6366F1),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF6366F1),
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFF9FAFB),
                                  ),
                                  validator: Validators.email,
                                ),
                                const SizedBox(height: 20),

                                // Password Field
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    labelText: 'Passwort',
                                    hintText: 'Mindestens 6 Zeichen',
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFF6366F1),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: const Color(0xFF6B7280),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF6366F1),
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFF9FAFB),
                                  ),
                                  validator: Validators.password,
                                ),
                                const SizedBox(height: 20),

                                // Confirm Password Field
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirmPassword,
                                  decoration: InputDecoration(
                                    labelText: 'Passwort bestätigen',
                                    hintText: 'Passwort erneut eingeben',
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFF6366F1),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: const Color(0xFF6B7280),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF6366F1),
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFF9FAFB),
                                  ),
                                  validator: _validateConfirmPassword,
                                ),
                                const SizedBox(height: 32),

                                // Legal Consent Checkbox
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: _acceptedLegal,
                                      onChanged: (value) {
                                        setState(() {
                                          _acceptedLegal = value ?? false;
                                          if (_acceptedLegal) {
                                            _showLegalError = false;
                                          }
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: const Color(0xFF374151),
                                              ),
                                          children: [
                                            TextSpan(
                                              text: 'auth.acceptLegalPrefix'
                                                  .tr(),
                                            ),
                                            TextSpan(
                                              text: 'auth.termsLabel'.tr(),
                                              style: const TextStyle(
                                                color: Color(0xFF6366F1),
                                                decoration:
                                                    TextDecoration.underline,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              recognizer: _termsRecognizer,
                                            ),
                                            TextSpan(
                                              text: 'auth.acceptLegalMiddle'
                                                  .tr(),
                                            ),
                                            TextSpan(
                                              text: 'auth.privacyLabel'.tr(),
                                              style: const TextStyle(
                                                color: Color(0xFF6366F1),
                                                decoration:
                                                    TextDecoration.underline,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              recognizer: _privacyRecognizer,
                                            ),
                                            TextSpan(
                                              text: 'auth.acceptLegalSuffix'
                                                  .tr(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_showLegalError)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 12,
                                        top: 4,
                                      ),
                                      child: Text(
                                        'auth.acceptLegalError'.tr(),
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 16),

                                // Sign Up Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: authState.isLoading
                                        ? null
                                        : _signUp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6366F1),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      disabledBackgroundColor: const Color(
                                        0xFF9CA3AF,
                                      ),
                                    ),
                                    child: authState.isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : Text(
                                            'auth.signUpButton'.tr(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Sign In Link
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'auth.hasAccount'.tr(),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: const Color(0xFF6B7280)),
                              ),
                              TextButton(
                                onPressed: () {
                                  final router = GoRouter.of(context);
                                  if (router.canPop()) {
                                    router.pop();
                                  } else {
                                    context.go('/sign-in');
                                  }
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF6366F1),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                                child: Text(
                                  'auth.signIn'.tr(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Error Message
                          if (authState.hasError)
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFFCA5A5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Color(0xFFDC2626),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      authState.error.toString(),
                                      style: const TextStyle(
                                        color: Color(0xFFDC2626),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const LanguageFooter(),
    );
  }
}
