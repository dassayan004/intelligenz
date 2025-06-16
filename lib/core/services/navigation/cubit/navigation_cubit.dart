import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligenz/core/constants/router_constant.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit()
    : super(
        const NavigationState(bottomNavItems: AppRouterConstant.home, index: 0),
      );

  void getNavBarItem(int index) {
    switch (index) {
      case 0:
        emit(
          const NavigationState(
            bottomNavItems: AppRouterConstant.home,
            index: 0,
          ),
        );
        break;
      case 1:
        emit(
          const NavigationState(
            bottomNavItems: AppRouterConstant.uploads,
            index: 1,
          ),
        );
        break;
      case 2:
        emit(
          const NavigationState(
            bottomNavItems: AppRouterConstant.alerts,
            index: 2,
          ),
        );
        break;
      case 3:
        emit(
          const NavigationState(
            bottomNavItems: AppRouterConstant.settings,
            index: 3,
          ),
        );
        break;
    }
  }

  void syncWithRoute(String route) {
    if (route.contains(AppRouterConstant.home)) {
      if (state.index != 0) {
        emit(
          const NavigationState(
            bottomNavItems: AppRouterConstant.home,
            index: 0,
          ),
        );
      }
    } else if (route.contains(AppRouterConstant.uploads)) {
      if (state.index != 1) {
        emit(
          const NavigationState(
            bottomNavItems: AppRouterConstant.uploads,
            index: 1,
          ),
        );
      }
    } else if (route.contains(AppRouterConstant.alerts)) {
      if (state.index != 2) {
        emit(
          const NavigationState(
            bottomNavItems: AppRouterConstant.alerts,
            index: 2,
          ),
        );
      }
    } else if (route.contains(AppRouterConstant.settings)) {
      if (state.index != 3) {
        emit(
          const NavigationState(
            bottomNavItems: AppRouterConstant.settings,
            index: 3,
          ),
        );
      }
    }
  }
}
