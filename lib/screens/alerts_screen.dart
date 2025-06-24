import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligenz/core/services/alerts/cubit/alert_cubit.dart';
import 'package:intelligenz/core/services/analytics/cubit/analytics_cubit.dart';
import 'package:intelligenz/core/utils/theme/refresh_indicator.dart';
import 'package:intelligenz/widgets/alerts_card.dart';
import 'package:intelligenz/widgets/reusable_app_bar.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  Future<void> _handleRefresh(BuildContext context) async {
    final analyticsCubit = context.read<AnalyticsCubit>();
    final alertCubit = context.read<AlertCubit>();

    if (analyticsCubit.state is AnalyticsLoaded) {
      final model = (analyticsCubit.state as AnalyticsLoaded).selectedAnalytics;
      await alertCubit.fetchAlerts(model.analyticsName);
    } else {
      // If not loaded, reload analytics which triggers alert loading too
      await analyticsCubit.loadSelectedAnalytics();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReusableAppBar(title: "Analytics Alert History"),
      body: TRefreshIndicator(
        onRefresh: () => _handleRefresh(context),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shrinkWrap: true,
          physics:
              const AlwaysScrollableScrollPhysics(), // to allow pull even if not scrollable
          children: const [AlertsCard()],
        ),
      ),
    );
  }
}
