import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/constants/size_constant.dart';
import 'package:intelligenz/core/services/analytics/cubit/analytics_cubit.dart';
import 'package:intelligenz/core/services/auth/cubit/auth_cubit.dart';
import 'package:intelligenz/widgets/change_analytics_card.dart';
import 'package:intelligenz/widgets/reusable_app_bar.dart';
import 'package:intelligenz/widgets/videoIntervalDropdown.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final bool isLoading = state is AuthLoading;
        return Stack(
          children: [
            Scaffold(
              appBar: const ReusableAppBar(title: "Application Settings"),
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChangeAnalyticsCard(),
                    SizedBox(height: 24),
                    VideoIntervalDropdown(),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Text(
                          'Notifications',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: kNeutralBlack,
                              ),
                        ),
                        const Spacer(),
                        _buildToggleButton(
                          isActive: true,
                          label: 'On',
                          color: kSuccessColor,
                        ),
                        const SizedBox(width: 8),
                        _buildToggleButton(
                          isActive: false,
                          label: 'Off',
                          color: kErrorColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Theme Row
                    Row(
                      children: [
                        Text(
                          'Theme',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: kNeutralBlack,
                              ),
                        ),
                        const Spacer(),
                        _buildThemeToggleButton(isLight: true),
                        const SizedBox(width: 8),
                        const Text('Dark'),
                        const SizedBox(width: 4),
                        const Icon(Icons.dark_mode, size: 18),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextButton.icon(
                      onPressed: () async {
                        final authCubit = context.read<AuthCubit>();
                        final analyticsCubit = context.read<AnalyticsCubit>();

                        await analyticsCubit.clear();
                        await authCubit.logout();
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: kErrorColor,
                        size: 32,
                      ),
                      label: Text(
                        'Logout',
                        style: GoogleFonts.dmSans(
                          fontSize: SizeConstants.size500,
                          fontWeight: FontWeight.w700,
                          color: kErrorColor,
                        ),
                      ),
                      style: TextButton.styleFrom(overlayColor: kErrorColor),
                    ),
                  ],
                ),
              ),
            ),

            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: kNeutralBlack.withAlpha(128),
                  child: const Center(
                    child: CircularProgressIndicator(color: kNeutralWhite),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

Widget _buildToggleButton({
  required bool isActive,
  required String label,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color),
      color: isActive ? color.withOpacity(0.1) : Colors.transparent,
    ),
    child: Row(
      children: [
        Text(label),
        const SizedBox(width: 8),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ],
    ),
  );
}

Widget _buildThemeToggleButton({required bool isLight}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: kSkyBlue300),
      color: isLight ? kSkyBlue300.withOpacity(0.1) : Colors.transparent,
    ),
    child: Row(
      children: const [
        Text('Light'),
        SizedBox(width: 6),
        Icon(Icons.wb_sunny, size: 18, color: kSkyBlue500),
      ],
    ),
  );
}
