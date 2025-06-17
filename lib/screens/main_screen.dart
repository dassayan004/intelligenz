import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/constants/router_constant.dart';
import 'package:intelligenz/core/services/navigation/cubit/navigation_cubit.dart';
import 'package:intelligenz/core/utils/named_nav_bar_item_widget.dart';

class MainScreen extends StatelessWidget {
  final Widget screen;

  MainScreen({super.key, required this.screen});

  final tabs = [
    NamedNavigationBarItemWidget(
      initialLocation: AppRouterConstant.home,
      icon: const Icon(Icons.home),
      label: 'Home',
    ),
    NamedNavigationBarItemWidget(
      initialLocation: AppRouterConstant.uploads,
      icon: const Icon(Icons.upload),
      label: 'Uploads',
    ),
    NamedNavigationBarItemWidget(
      initialLocation: AppRouterConstant.alerts,
      icon: const Icon(Icons.crisis_alert),
      label: 'Alerts',
    ),
    NamedNavigationBarItemWidget(
      initialLocation: AppRouterConstant.settings,
      icon: const Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentUri = GoRouterState.of(context).uri.toString();
    context.read<NavigationCubit>().syncWithRoute(currentUri);
    return Scaffold(
      body: screen,
      // Floating camera button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // handle camera tap
          debugPrint("Camera button pressed");
        },
        backgroundColor: kButtonColor,
        elevation: 0,
        hoverElevation: 0,
        shape: const CircleBorder(),
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigation(context, tabs),
    );
  }
}

BlocBuilder<NavigationCubit, NavigationState> _buildBottomNavigation(
  mContext,
  List<NamedNavigationBarItemWidget> tabs,
) => BlocBuilder<NavigationCubit, NavigationState>(
  buildWhen: (previous, current) => previous.index != current.index,
  builder: (context, state) {
    return BottomNavigationBar(
      onTap: (value) {
        if (state.index != value) {
          context.read<NavigationCubit>().getNavBarItem(value);
          context.go(tabs[value].initialLocation);
        }
      },
      backgroundColor: kNeutralWhite,
      currentIndex: state.index,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,

      selectedItemColor: kNeutralGrey500,
      unselectedItemColor: kNeutralGrey700,

      selectedLabelStyle: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: kNeutralGrey500,
      ),
      unselectedLabelStyle: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: kNeutralGrey500,
      ),

      selectedIconTheme: IconThemeData(
        size: ((IconTheme.of(mContext).size)! * 1.3),
        color: kSkyBlue300,
      ),
      items: tabs,
    );
  },
);
