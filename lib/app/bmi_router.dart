import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrmzee_bmi_calculator/app/bmi_shell.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_view_model.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/bmi_history_view.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/bmi_result_view.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/bmi_view.dart';
import 'package:mrmzee_bmi_calculator/features/profile/presentation/view_models/profile_view_model.dart';
import 'package:mrmzee_bmi_calculator/features/profile/presentation/views/profile_setup_view.dart';
import 'package:mrmzee_bmi_calculator/features/profile/presentation/views/profile_view.dart';

/// Setup stays outside the shell. Calculator, history, and profile share it.
GoRouter createBmiRouter({
  required BmiViewModel calculator,
  required ProfileViewModel profiles,
}) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/setup',
    refreshListenable: profiles,
    redirect: (context, state) {
      final profileState = profiles.state;
      if (!profileState.isLoaded) {
        return null;
      }
      final onSetup = state.matchedLocation == '/setup';
      if (!profileState.hasCompleteProfile) {
        return onSetup ? null : '/setup';
      }
      if (onSetup) {
        return '/calculate';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/setup',
        builder: (context, state) {
          return ProfileSetupView(viewModel: profiles);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BmiShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calculate',
                builder: (context, state) {
                  return BmiView(
                    viewModel: calculator,
                    profiles: profiles,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) {
                  return BmiHistoryView(
                    viewModel: calculator,
                    profiles: profiles,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) {
                  return ProfileView(
                    viewModel: profiles,
                    onProfileRemoved: calculator.clearHistoryFor,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/results/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return BmiResultView(
            entryId: state.pathParameters['id']!,
            viewModel: calculator,
            profiles: profiles,
          );
        },
      ),
    ],
  );
}
