import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/constants/size_constant.dart';
import 'package:intelligenz/core/services/alerts/cubit/alert_cubit.dart';
import 'package:intelligenz/core/services/analytics/cubit/analytics_cubit.dart';
import 'package:intelligenz/core/utils/image_fetch_util.dart';
import 'package:intelligenz/db/analytics/analytics_model.dart';

import 'package:intelligenz/models/alert_response.dart';
import 'package:intelligenz/providers/dio_provider.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ...topAlerts
              .asMap()
              .entries
              .map(
                (entry) => Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key == topAlerts.length - 1 ? 0 : 16,
                  ),
                  child: RecentAlertRow(alert: entry.value),
                ),
              )
              .toList(),
        ],
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
        AlertImage(fileName: alert.imageUrl?[0], size: SizeConstants.size1100),

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

class AlertImage extends StatelessWidget {
  final String? fileName;
  final double size;

  const AlertImage({
    super.key,
    required this.fileName,
    this.size = 100, // fallback size
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SizeConstants.size100),
      child: FutureBuilder<Uint8List?>(
        future: _loadImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return _imgSkeleton();
          }

          if (snapshot.hasData && snapshot.data != null) {
            return Image.memory(
              snapshot.data!,
              width: size,
              height: size,
              fit: BoxFit.cover,
            );
          }

          return _placeholder();
        },
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: size,
      height: size,
      color: kNeutralGrey1000,
      child: const Icon(
        Icons.image_not_supported,
        size: 24,
        color: kNeutralGrey300,
      ),
    );
  }

  Widget _imgSkeleton() {
    return Shimmer.fromColors(
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
    );
  }

  Future<Uint8List?> _loadImage() async {
    if (fileName == null || fileName!.isEmpty) return null;
    final dio = await DioProvider().client;
    return await ImageFetchUtil.fetchImage(fileName!, dio);
  }
}
