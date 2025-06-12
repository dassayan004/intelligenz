import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intelligenz/core/constants/router_constant.dart';
import 'package:intelligenz/core/services/analytics/cubit/analytics_cubit.dart';
import 'package:intelligenz/core/services/auth/cubit/auth_cubit.dart';
import 'package:intelligenz/screens/analytics_screen.dart';
import 'package:intelligenz/screens/home_screen.dart';
import 'package:intelligenz/screens/login_screen.dart';
import 'package:intelligenz/screens/splash_screen.dart';

GoRouter router(AuthCubit authCubit, AnalyticsCubit analyticsCubit) {
  return GoRouter(
    initialLocation: AppRouterConstant.splash,
    refreshListenable: GoRouterRefreshStream([
      authCubit.stream,
      analyticsCubit.stream,
    ]),
    redirect: (context, state) {
      final isAuthenticated = authCubit.state is Authenticated;
      final isUnAuthenticated = authCubit.state is Unauthenticated;
      final analyticsState = analyticsCubit.state;
      final isAnalyticsLoaded =
          analyticsState is AnalyticsLoaded &&
          analyticsState.selectedAnalytics.isNotEmpty;

      // 1. Not authenticated → go to login
      if (isUnAuthenticated &&
          state.matchedLocation != AppRouterConstant.login) {
        return AppRouterConstant.login;
      }
      // 2. Authenticated but no analytics selected → go to analytics
      if (isAuthenticated &&
          !isAnalyticsLoaded &&
          state.matchedLocation != AppRouterConstant.analytics) {
        return AppRouterConstant.analytics;
      }

      // 3. Authenticated and analytics loaded → go to home if not already there
      if (isAuthenticated &&
          isAnalyticsLoaded &&
          state.matchedLocation != AppRouterConstant.home) {
        return AppRouterConstant.home;
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
      GoRoute(
        path: AppRouterConstant.home,
        name: AppRouteName.home.name,
        builder: (context, state) => const HomePage(title: 'Home'),
      ),
    ],
  );
}

// for convert stream to listenable

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(List<Stream> streams) {
    for (var stream in streams) {
      final sub = stream.listen((_) => notifyListeners());
      _subscriptions.add(sub);
    }
    notifyListeners(); // trigger once at init
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
