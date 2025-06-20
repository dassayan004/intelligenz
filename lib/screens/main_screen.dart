import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/constants/router_constant.dart';
import 'package:intelligenz/core/services/navigation/cubit/navigation_cubit.dart';

class MainScreen extends StatelessWidget {
  final Widget screen;

  const MainScreen({super.key, required this.screen});

  @override
  Widget build(BuildContext context) {
    final currentUri = GoRouterState.of(context).uri.toString();
    context.read<NavigationCubit>().syncWithRoute(currentUri);

    return Scaffold(
      body: screen,
      floatingActionButton: Transform.translate(
        offset: const Offset(
          0,
          12.5,
        ), // Lower the FAB+label slightly into BottomAppBar
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: FloatingActionButton(
                onPressed: () {
                  debugPrint("Camera button pressed");
                },
                backgroundColor: kButtonColor,
                elevation: 0,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Camera',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: klTextHint),
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        buildWhen: (previous, current) => previous.index != current.index,
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: kNeutralBlack.withAlpha((0.12 * 255).round()),
                  blurRadius: 10,
                  offset: const Offset(0, 0), // X: 0, Y: 0
                  spreadRadius: 0,
                ),
              ],
            ),
            child: BottomAppBar(
              color: kNeutralWhite,
              height: 76,
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Left side
                  _buildNavItem(
                    context,
                    state.index,
                    0,
                    Icons.home_outlined,
                    Icons.home,
                    'Home',
                  ),
                  _buildNavItem(
                    context,
                    state.index,
                    1,
                    Icons.upload_outlined,
                    Icons.upload,
                    'Uploads',
                    showDot: true,
                  ),
                  const SizedBox(width: 50), // Spacer to center the FAB
                  _buildNavItem(
                    context,
                    state.index,
                    2,
                    Icons.add_alert_outlined,
                    Icons.add_alert_sharp,
                    'Alerts',
                  ),
                  _buildNavItem(
                    context,
                    state.index,
                    3,
                    Icons.settings_outlined,
                    Icons.settings,
                    'Settings',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int selectedIndex,
    int itemIndex,
    IconData icon,
    IconData selectedIcon,
    String label, {
    bool showDot = false,
  }) {
    final isSelected = selectedIndex == itemIndex;
    final color = isSelected ? kSkyBlue300 : kNeutralGrey700;
    final iconRef = isSelected ? selectedIcon : icon;
    return InkWell(
      onTap: () {
        context.read<NavigationCubit>().getNavBarItem(itemIndex);
        context.go(
          [
            AppRouterConstant.home,
            AppRouterConstant.uploads,
            AppRouterConstant.alerts,
            AppRouterConstant.settings,
          ][itemIndex],
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Icon(iconRef, color: color, size: 24),
                if (showDot)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: kWarningColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: klTextHint),
            ),
          ],
        ),
      ),
    );
  }
}
