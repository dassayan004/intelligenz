import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/services/analytics/cubit/analytics_cubit.dart';
import 'package:intelligenz/core/services/auth/cubit/auth_cubit.dart';
import 'package:intelligenz/widgets/reusable_app_bar.dart';

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
              body: Center(child: Text('Settings Screen')),
              floatingActionButton: FloatingActionButton(
                heroTag: 'logoutBtn',
                backgroundColor: kErrorColor,
                foregroundColor: kButtonTextColor,
                shape: const CircleBorder(),
                onPressed: () async {
                  final authCubit = context.read<AuthCubit>();
                  final analyticsCubit = context.read<AnalyticsCubit>();

                  await analyticsCubit.clear();
                  await authCubit.logout();
                },
                tooltip: 'Logout',
                child: const Icon(Icons.logout),
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
