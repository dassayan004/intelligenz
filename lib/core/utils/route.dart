import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intelligenz/core/constants/router_constant.dart';
import 'package:intelligenz/core/services/analytics/cubit/analytics_cubit.dart';
import 'package:intelligenz/core/services/auth/cubit/auth_cubit.dart';
import 'package:intelligenz/core/services/navigation/cubit/navigation_cubit.dart';
import 'package:intelligenz/core/services/uploadForm/cubit/upload_form_cubit.dart';
import 'package:intelligenz/screens/alerts_screen.dart';
import 'package:intelligenz/screens/analytics_screen.dart';
import 'package:intelligenz/screens/home_screen.dart';
import 'package:intelligenz/screens/login_screen.dart';
import 'package:intelligenz/screens/main_screen.dart';
import 'package:intelligenz/screens/settings_screen.dart';
import 'package:intelligenz/screens/splash_screen.dart';
import 'package:intelligenz/screens/upload_new_screen.dart';
import 'package:intelligenz/screens/upload_screen.dart';

import '../../models/alert_response.dart';
import '../../screens/alert_details_screen.dart';

GoRouter router(AuthCubit authCubit, AnalyticsCubit analyticsCubit) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final shellNavigatorKey = GlobalKey<NavigatorState>();
  return GoRouter(
    initialLocation: AppRouterConstant.splash,
    refreshListenable: GoRouterRefreshStream([
      authCubit.stream,
      analyticsCubit.stream,
    ]),
    navigatorKey: rootNavigatorKey,
    redirect: (context, state) {
      final isAuthenticated = authCubit.state is Authenticated;
      final isUnAuthenticated = authCubit.state is Unauthenticated;
      final analyticsState = analyticsCubit.state;
      final isAnalyticsLoaded =
          analyticsState is AnalyticsLoaded &&
          analyticsState.selectedAnalytics.isInBox;
      final String location = state.matchedLocation;
      // 1. Not authenticated → go to login
      if (isUnAuthenticated && location != AppRouterConstant.login) {
        return AppRouterConstant.login;
      }

      final shouldForceAnalyticsSelection =
          analyticsState is AnalyticsInitial ||
          (analyticsState is! AnalyticsLoaded &&
              analyticsState is! AnalyticsListLoaded);

      if (isAuthenticated &&
          shouldForceAnalyticsSelection &&
          location != AppRouterConstant.analytics) {
        return AppRouterConstant.analytics;
      }
      // 3. Authenticated and analytics loaded → go to home if not already there

      if (isAuthenticated && isAnalyticsLoaded) {
        // allow all ShellRoute destinations
        final shellPaths = [
          AppRouterConstant.home,
          AppRouterConstant.uploads,
          AppRouterConstant.alerts,
          AppRouterConstant.settings,
        ];
        final isAllowed = shellPaths.any(
          (prefix) => location.startsWith(prefix),
        );
        if (!isAllowed && location != AppRouterConstant.uploadNewItems) {
          return AppRouterConstant.home;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRouterConstant.splash,
        name: AppRouteName.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRouterConstant.login,
        name: AppRouteName.login.name,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRouterConstant.analytics,
        name: AppRouteName.analytics.name,
        builder: (context, state) => const AnalyticsPage(),
      ),

      /// [Authenticated] Shell
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return BlocProvider(
            create: (context) => NavigationCubit(),
            child: MainScreen(screen: child),
          );
        },
        routes: [
          GoRoute(
            path: AppRouterConstant.home,
            name: AppRouteName.home.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: AppRouterConstant.uploads,
            name: AppRouteName.uploads.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: UploadScreen()),
          ),
          GoRoute(
            path: AppRouterConstant.alerts,
            name: AppRouteName.alerts.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AlertsScreen()),
            routes: [
              GoRoute(
                path: AppRouterConstant.alertDetails,
                name: AppRouteName.alertDetails.name,
                pageBuilder: (context, state) {
                  final alert = state.extra as AlertData;
                  return NoTransitionPage(
                    child: AlertDetailsScreen(alert: alert),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRouterConstant.settings,
            name: AppRouteName.settings.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SettingScreen()),
          ),
        ],
      ),

      /// ✅ Upload New Items [Authenticated] OUTSIDE SHELL
      GoRoute(
        path: AppRouterConstant.uploadNewItems,
        name: AppRouteName.uploadNewItems.name,
        builder: (context, state) {
          final imagePath = state.extra as String?;
          return BlocProvider(
            create: (_) => UploadFormCubit(),
            child: UploadNewScreen(imagePath: imagePath!),
          );
        },
      ),
    ],
  );
}

/// 🌀 Converts Stream to Listenable for GoRouter refresh
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(List<Stream> streams) {
    for (var stream in streams) {
      final sub = stream.listen((_) => notifyListeners());
      _subscriptions.add(sub);
    }
    notifyListeners();
  }

  final List<StreamSubscription> _subscriptions = [];

  @override
  void dispose() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }
}
