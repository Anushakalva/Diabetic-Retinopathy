import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/services/app_providers.dart';
import '../../../core/theme/theme_provider.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  static const _routes = [
    '/dashboard',
    '/patients',
    '/reports',
    '/profile',
  ];

  void _onTap(int index) {
    setState(() => _currentIndex = index);
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkModeProvider);
    final location = GoRouterState.of(context).matchedLocation;
    _currentIndex = _routes.indexWhere((r) => location.startsWith(r));
    if (_currentIndex < 0) _currentIndex = 0;

    return Scaffold(
      body: widget.child,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/camera'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 8,
        icon: const Icon(Icons.camera_alt_rounded),
        label: const Text('New Scan'),
      ).animate().scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
            delay: 400.ms,
            duration: 400.ms,
            curve: Curves.easeOutBack,
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
          child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            notchMargin: 8,
            shape: const CircularNotchedRectangle(),
            child: SizedBox(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.dashboard_rounded,
                    label: 'Home',
                    selected: _currentIndex == 0,
                    onTap: () => _onTap(0),
                  ),
                  _NavItem(
                    icon: Icons.people_rounded,
                    label: 'Patients',
                    selected: _currentIndex == 1,
                    onTap: () => _onTap(1),
                  ),
                  const SizedBox(width: 56),
                  _NavItem(
                    icon: Icons.description_rounded,
                    label: 'Reports',
                    selected: _currentIndex == 2,
                    onTap: () => _onTap(2),
                  ),
                  _NavItem(
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    selected: _currentIndex == 3,
                    onTap: () => _onTap(3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: selected ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
