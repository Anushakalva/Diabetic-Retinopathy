import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/app_providers.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../widgets/cards/glass_card.dart';
import '../../../widgets/inputs/custom_inputs.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'doctor@retinacare.org');
  final _passwordController = TextEditingController(text: 'password');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authStateProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );
    if (mounted && ref.read(authStateProvider).valueOrNull != null) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider);
    final isDark = ref.watch(isDarkModeProvider);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.darkBackground, AppColors.darkSurface]
                : [const Color(0xFFEFF6FF), AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width > 600 ? size.width * 0.25 : AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusLg),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.remove_red_eye_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ).animate().scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1),
                          duration: 500.ms,
                          curve: Curves.easeOutBack,
                        ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Welcome back',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.05, end: 0),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Sign in to access AI-powered retinal screening',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: AppSpacing.xl),
                    GlassCard(
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            label: 'Email Address',
                            hint: 'doctor@hospital.org',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Email required';
                              if (!v.contains('@')) return 'Invalid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          CustomTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Enter your password',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () =>
                                  setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Password required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          if (auth.hasError)
                            Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.md),
                              child: Text(
                                'Login failed. Please try again.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.danger),
                              ),
                            ),
                          PrimaryButton(
                            label: 'Sign In',
                            icon: Icons.login_rounded,
                            isLoading: auth.isLoading,
                            onPressed: _login,
                          ),
                        ],
                      ),
                    ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: Text(
                        AppStrings.copyright,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
