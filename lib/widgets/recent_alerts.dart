import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/constants/router_constant.dart';
import 'package:intelligenz/core/constants/size_constant.dart';
import 'package:intelligenz/core/services/alerts/cubit/alert_cubit.dart';
import 'package:intelligenz/core/services/analytics/cubit/analytics_cubit.dart';

import 'package:intelligenz/models/alert_response.dart';
import 'package:intelligenz/widgets/alert_thumb.dart';
import 'package:shimmer/shimmer.dart';

class RecentAlertsCard extends StatelessWidget {
  const RecentAlertsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AnalyticsCubit, AnalyticsState>(
      listenWhen: (previous, current) =>
          current is AnalyticsLoaded && previous != current,
      listener: (context, state) {
        if (state is AnalyticsLoaded) {
          context.read<AlertCubit>().fetchAlerts(
            state.selectedAnalytics.analyticsName,
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Alerts",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to alerts page
                  context.goNamed(AppRouteName.alerts.name);
                },
                child: Text(
                  "View All",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: klTextMedium,
                    decoration: TextDecoration.underline,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12.5),
          BlocBuilder<AlertCubit, AlertState>(
            builder: (context, state) {
              if (state is AlertLoading) {
                return _buildLoadingCard();
              } else if (state is AlertLoaded) {
                return _buildAlertCard(state.alerts, context: context);
              } else if (state is AlertError) {
                return Text("Failed to load alerts: ${state.message}");
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildLoadingCard() {
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    color: kNeutralWhite,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: index == 2 ? 0 : 16),
            child: const _RecentAlertSkeleton(),
          ),
        ),
      ),
    ),
  );
}

Widget _buildAlertCard(
  List<AlertData> alerts, {
  required BuildContext context,
}) {
  if (alerts.isEmpty) return const Text("No recent alerts found.");
  alerts.sort((a, b) {
    final aTs = int.tryParse(a.timestamp ?? '0') ?? 0;
    final bTs = int.tryParse(b.timestamp ?? '0') ?? 0;
    return bTs.compareTo(aTs); // Descending
  });

  final topAlerts = alerts.take(3).toList();
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    color: kNeutralWhite,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: topAlerts
            .asMap()
            .entries
            .map(
              (entry) => Padding(
                padding: EdgeInsets.only(
                  bottom: entry.key == topAlerts.length - 1 ? 0 : 16,
                ),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        AppRouteName.alertDetails.name,
                        extra: entry.value,
                      );
                    },
                    child: RecentAlertRow(alert: entry.value),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ),
  );
}

class RecentAlertRow extends StatelessWidget {
  final AlertData alert;

  const RecentAlertRow({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        AlertThumbnail(
          fileName: alert.thumbUrl?[0],
          size: SizeConstants.size1100,
        ),

        const SizedBox(width: 12),

        // Text Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First line: Filename and Category
              Row(
                children: [
                  Expanded(
                    child: Text(
                      truncateFilename(alert.imageUrl?[0] ?? 'IMG_XXXXXX.png'),
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    alert.zoneName ?? 'Traffic',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: kSkyBlue300),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Second line: Alert message and timestamp
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'You have received an alert.\nTap to view.',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  Text(
                    _formatDate(alert.timestamp),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String truncateFilename(
    String filename, {
    int headLength = 8,
    int tailLength = 10,
  }) {
    if (filename.length <= headLength + tailLength) return filename;

    final head = filename.substring(0, headLength);
    final tail = filename.substring(filename.length - tailLength);
    return '$head...$tail';
  }

  String _formatDate(String? timestamp) {
    if (timestamp == null) return '';

    final ts = int.tryParse(timestamp) ?? 0;
    if (ts == 0) return '';

    final dt = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
    final isAm = dt.hour < 12;
    final hour = isAm ? dt.hour : dt.hour - 12;
    return "${dt.day.toString().padLeft(2, '0')}/"
        "${dt.month.toString().padLeft(2, '0')}/"
        "${dt.year.toString().substring(2)}, "
        "${hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')} ${isAm ? 'AM' : 'PM'}";
  }
}

class _RecentAlertSkeleton extends StatelessWidget {
  const _RecentAlertSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: kNeutralGrey1000,
          highlightColor: kNeutralGrey900,
          child: Container(
            width: SizeConstants.size1100,
            height: SizeConstants.size1100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(SizeConstants.size100),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: kNeutralGrey1000,
                highlightColor: kNeutralGrey900,
                child: Container(
                  height: 14,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Shimmer.fromColors(
                baseColor: kNeutralGrey1000,
                highlightColor: kNeutralGrey900,
                child: Container(
                  height: 12,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Shimmer.fromColors(
                baseColor: kNeutralGrey1000,
                highlightColor: kNeutralGrey900,
                child: Container(
                  height: 10,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
