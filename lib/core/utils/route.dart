import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intelligenz/core/constants/router_constant.dart';
import 'package:intelligenz/core/services/auth/cubit/auth_cubit.dart';
import 'package:intelligenz/screens/home_screen.dart';
import 'package:intelligenz/screens/login_screen.dart';
import 'package:intelligenz/screens/splash_screen.dart';

GoRouter router(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: AppRouterConstant.splash,
    refreshListenable: StreamToListenable([authCubit.stream]),
    redirect: (context, state) {
      final isAuthenticated = authCubit.state is Authenticated;
      final isUnAuthenticated = authCubit.state is Unauthenticated;

      // Redirect to the login page if the user is not authenticated, and if authenticated, do not show the login page
      if (isUnAuthenticated &&
          state.matchedLocation != AppRouterConstant.login) {
        return AppRouterConstant.login;
      }

      if (isAuthenticated && state.matchedLocation != AppRouterConstant.home) {
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
        path: AppRouterConstant.home,
        name: AppRouteName.home.name,
        builder: (context, state) => const HomePage(title: 'Home'),
      ),
      //  GoRoute(
      //   path: AppRouterConstant.analytics,
      //   name: AppRouteName.analytics.name,
      //   builder: (context, state) => const AnalyticsPage(),
      // ),
    ],
  );
}

// for convert stream to listenable
class StreamToListenable extends ChangeNotifier {
  late final List<StreamSubscription> subscriptions;

  StreamToListenable(List<Stream> streams) {
    subscriptions = [];
    for (var e in streams) {
      var s = e.asBroadcastStream().listen(_tt);
      subscriptions.add(s);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    for (var e in subscriptions) {
      e.cancel();
    }
    super.dispose();
  }

  void _tt(event) => notifyListeners();
}
