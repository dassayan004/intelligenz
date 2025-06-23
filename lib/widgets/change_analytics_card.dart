import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/constants/size_constant.dart';
import 'package:intelligenz/core/services/analytics/cubit/analytics_cubit.dart';
import 'package:intelligenz/core/utils/theme/radio_field_theme.dart';
import 'package:intelligenz/db/analytics/analytics_model.dart';

import 'package:intelligenz/models/analytics_response.dart';

class ChangeAnalyticsCard extends StatefulWidget {
  const ChangeAnalyticsCard({super.key});

  @override
  State<ChangeAnalyticsCard> createState() => _ChangeAnalyticsCardState();
}

class _ChangeAnalyticsCardState extends State<ChangeAnalyticsCard> {
  AnalyticsList? _selectedAnalytic;
  AnalyticsModel? _defaultSelectedModel;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AnalyticsCubit>();
    cubit.loadSelectedAnalytics();
    cubit.fetchAnalyticsList();
  }

  void _onAnalyticsSelected(AnalyticsList analytic) {
    debugPrint('Selected: ${analytic.hashId} - ${analytic.analyticName}');
    setState(() => _selectedAnalytic = analytic);
    context.read<AnalyticsCubit>().selectAnalytics(analytic);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Default analytics changed to "${analytic.analyticName}"',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: kSuccessColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AnalyticsCubit, AnalyticsState>(
          listenWhen: (previous, current) => current is AnalyticsLoaded,
          listener: (context, state) {
            if (state is AnalyticsLoaded) {
              _defaultSelectedModel = state.selectedAnalytics;
            }
          },
        ),
      ],
      child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        buildWhen: (previous, current) =>
            current is AnalyticsListLoaded || current is AnalyticsError,
        builder: (context, state) {
          if (state is AnalyticsListLoaded) {
            final list = state.analyticsList;

            // Set the default only once if not already manually selected
            if (_selectedAnalytic == null && _defaultSelectedModel != null) {
              final matched = list.firstWhere(
                (a) => a.hashId == _defaultSelectedModel!.hashId,
                orElse: () => list.first,
              );
              _selectedAnalytic = matched;
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change your default analytics',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 16),
                Container(
                  height: 302,
                  decoration: BoxDecoration(
                    color: kNeutralWhite,
                    borderRadius: BorderRadius.circular(SizeConstants.size100),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final analytic = list[index];
                      return CustomCupertinoRadio<String>(
                        value: analytic.hashId ?? '',
                        groupValue: _selectedAnalytic?.hashId ?? '',
                        label: analytic.analyticName ?? '',
                        onChanged: (_) => _onAnalyticsSelected(analytic),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is AnalyticsError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
