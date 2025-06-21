import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intelligenz/core/constants/router_constant.dart';
import 'package:intelligenz/core/services/analytics/cubit/analytics_cubit.dart';
import 'package:intelligenz/core/utils/theme/elevated_btn_theme.dart';
import 'package:intelligenz/db/analytics/analytics_model.dart';

class DefaultAnalyticsCard extends StatefulWidget {
  const DefaultAnalyticsCard({super.key});

  @override
  State<DefaultAnalyticsCard> createState() => _DefaultAnalyticsCardState();
}

class _DefaultAnalyticsCardState extends State<DefaultAnalyticsCard> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsCubit>().loadSelectedAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, state) {
        if (state is AnalyticsLoaded) {
          final AnalyticsModel model = state.selectedAnalytics;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your current default analytics",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: model.analyticsName,
                readOnly: true,
                style: Theme.of(context).textTheme.bodySmall,
                decoration: InputDecoration(
                  suffixIconConstraints: const BoxConstraints(
                    minHeight: 36,
                    minWidth: 0,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ElevatedButton(
                      style: TElevatedButtonTheme.btnInsideInput,
                      onPressed: () {
                        context.read<AnalyticsCubit>().clear();
                        context.goNamed(AppRouteName.analytics.name);
                      },
                      child: const Text("Change"),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (state is AnalyticsInitial) {
          return const SizedBox.shrink();
        } else {
          return const Text("No default analytics selected");
        }
      },
    );
  }
}
