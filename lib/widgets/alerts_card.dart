import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/constants/router_constant.dart';
import 'package:intelligenz/core/constants/size_constant.dart';
import 'package:intelligenz/core/services/alerts/cubit/alert_cubit.dart';
import 'package:intelligenz/core/services/analytics/cubit/analytics_cubit.dart';
import 'package:intelligenz/db/analytics/analytics_model.dart';

import 'package:intelligenz/models/alert_response.dart';
import 'package:intelligenz/widgets/alert_thumb.dart';
import 'package:shimmer/shimmer.dart';

class AlertsCard extends StatefulWidget {
  const AlertsCard({super.key});

  @override
  State<AlertsCard> createState() => _AlertsCardState();
}

class _AlertsCardState extends State<AlertsCard> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsCubit>().loadSelectedAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AnalyticsCubit, AnalyticsState>(
      listener: (context, state) {
        if (state is AnalyticsLoaded) {
          final AnalyticsModel model = state.selectedAnalytics;
          context.read<AlertCubit>().fetchAlerts(model.analyticsName);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: kNeutralGrey1000,
            highlightColor: kNeutralGrey900,
            child: Container(
              height: 10,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: index == 2 ? 0 : 16),
              child: const _RecentAlertSkeleton(),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildAlertCard(
  List<AlertData> alerts, {
  required BuildContext context,
}) {
  if (alerts.isEmpty) return const Text("No recent alerts found.");

  // alerts.sort((a, b) {
  //   final aTs = int.tryParse(a.timestamp ?? '0') ?? 0;
  //   final bTs = int.tryParse(b.timestamp ?? '0') ?? 0;
  //   return bTs.compareTo(aTs); // Descending
  // });

  // final topAlerts = alerts.take(3).toList();
  final Map<String, List<AlertData>> groupedAlerts = {};

  for (final alert in alerts) {
    final label = _formatAlertDateGroup(alert.timestamp);
    groupedAlerts.putIfAbsent(label, () => []).add(alert);
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: groupedAlerts.entries.map((entry) {
      final label = entry.key;
      final alertList = entry.value;

      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: kNeutralWhite,
        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              ...alertList.asMap().entries.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key == alertList.length - 1 ? 0 : 16,
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
              ),
            ],
          ),
        ),
      );
    }).toList(),
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

String _formatAlertDateGroup(String? timestamp) {
  if (timestamp == null) return '';

  final ts = int.tryParse(timestamp) ?? 0;
  if (ts == 0) return '';

  final alertDate = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
  final now = DateTime.now();

  final isToday =
      alertDate.year == now.year &&
      alertDate.month == now.month &&
      alertDate.day == now.day;

  final isYesterday =
      alertDate.year == now.year &&
      alertDate.month == now.month &&
      alertDate.day == now.day - 1;

  if (isToday) return 'Today';
  if (isYesterday) return 'Yesterday';

  return _ddmmyy(alertDate); // e.g. 16/04/24
}

String _ddmmyy(DateTime dt) {
  return "${dt.day.toString().padLeft(2, '0')}/"
      "${dt.month.toString().padLeft(2, '0')}/"
      "${dt.year.toString().substring(2)}";
}
