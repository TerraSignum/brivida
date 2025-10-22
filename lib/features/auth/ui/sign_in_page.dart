import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../logic/auth_controller.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/language_footer.dart';
import '../../../core/utils/debug_logger.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    DebugLogger.lifecycle('SignInPage', 'dispose', {
      'emailLength': _emailController.text.length,
      'hasPassword': _passwordController.text.isNotEmpty,
    });

    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    DebugLogger.enter('_signIn', {
      'email': _emailController.text.trim(),
      'passwordLength': _passwordController.text.length,
      'formValid': _formKey.currentState?.validate() ?? false,
    });

    DebugLogger.userAction('sign_in_attempt', {
      'email': _emailController.text.trim(),
      'timestamp': DateTime.now().toIso8601String(),
    });

    DebugLogger.startTimer('signin_ui_duration');

    if (_formKey.currentState?.validate() ?? false) {
      DebugLogger.debug('📝 Form validation passed, attempting sign in');

      final success = await ref
          .read(authControllerProvider.notifier)
          .signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      final duration = DebugLogger.stopTimer(
        'signin_ui_duration',
        'sign in UI flow',
      );

      // If sign-in was successful, redirect to home
      if (success && mounted) {
        DebugLogger.navigation('home', 'sign_in_success', {
          'duration': duration?.inMilliseconds,
          'email': _emailController.text.trim(),
        });
        context.go('/home');

        DebugLogger.exit('_signIn', {'success': true, 'redirected': true});
      } else {
        DebugLogger.debug('❌ Sign in failed or widget unmounted', {
          'success': success,
          'mounted': mounted,
          'duration': duration?.inMilliseconds,
        });

        DebugLogger.exit('_signIn', {'success': false, 'mounted': mounted});
      }
    } else {
      final duration = DebugLogger.stopTimer(
        'signin_ui_duration',
        'sign in form validation failed',
      );
      DebugLogger.debug('❌ Form validation failed', {
        'duration': duration?.inMilliseconds,
      });

      DebugLogger.exit('_signIn', {
        'success': false,
        'reason': 'validation_failed',
      });
    }
  }

  @override
  void initState() {
    super.initState();
    DebugLogger.lifecycle('SignInPage', 'initState');
  }

  @override
  Widget build(BuildContext context) {
    DebugLogger.lifecycle('SignInPage', 'build');

    try {
      DebugLogger.log('📱 SIGNIN DEBUG: Building SignInPage widget');
      final authState = ref.watch(authControllerProvider);
      DebugLogger.log('🔄 SIGNIN DEBUG: Auth state loaded successfully');

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
                              'auth.welcomeTitle'.tr(),
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1F2937),
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'auth.welcomeSubtitle'.tr(),
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: const Color(0xFF6B7280)),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),

                            // Login Form Card
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
                                      labelText: 'auth.emailLabel'.tr(),
                                      hintText: 'auth.emailHint'.tr(),
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
                                      labelText: 'auth.passwordLabel'.tr(),
                                      hintText: 'auth.passwordHint'.tr(),
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
                                            _obscurePassword =
                                                !_obscurePassword;
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
                                  const SizedBox(height: 32),

                                  // Sign In Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: authState.isLoading
                                          ? null
                                          : _signIn,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF6366F1,
                                        ),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            )
                                          : Text(
                                              'auth.signInButton'.tr(),
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

                            // Sign Up Link
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  'auth.noAccount'.tr(),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: const Color(0xFF6B7280),
                                      ),
                                ),
                                TextButton(
                                  onPressed: () => context.push('/sign-up'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF6366F1),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                  ),
                                  child: Text(
                                    'auth.signUp'.tr(),
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
    } catch (e, stackTrace) {
      DebugLogger.log('❌ SIGNIN DEBUG: Critical error building SignInPage: $e');
      DebugLogger.log('📍 SIGNIN DEBUG: Stack trace: $stackTrace');

      // Return error widget
      return Scaffold(
        backgroundColor: Colors.red[100],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'SignIn Page Error',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Error: $e',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }
  }
}
