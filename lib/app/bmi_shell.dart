import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';

/// Bottom navigation that keeps محاسبه، تاریخچه، and پروفایل alive.
class BmiShell extends StatelessWidget {
  const BmiShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final canvas = context.appCanvas;

    return Scaffold(
      backgroundColor: canvas.canvas,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: canvas.accent.withValues(alpha: 0.16),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                child: NavigationBar(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: navigationShell.goBranch,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.monitor_weight_outlined),
                      selectedIcon: Icon(Icons.monitor_weight),
                      label: 'محاسبه',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.show_chart_outlined),
                      selectedIcon: Icon(Icons.show_chart),
                      label: 'تاریخچه',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: 'پروفایل',
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
