// lib/screens/alert_details_screen.dart

import 'package:flutter/material.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/widgets/alert_image.dart';
import 'package:intelligenz/widgets/alert_thumb.dart';
import 'package:intelligenz/widgets/reusable_app_bar.dart';

import '../models/alert_response.dart';

class AlertDetailsScreen extends StatelessWidget {
  final AlertData alert;

  const AlertDetailsScreen({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReusableAppBar(title: "Analytics Alert Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailsHeader(alert, context),
            const SizedBox(height: 24),
            SizedBox(
              width:
                  MediaQuery.of(context).size.width -
                  48, // full width inside padding
              child: AlertImage(
                fileName: alert.imageUrl?.first,
                width: double.infinity,
                height: 200,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: MediaQuery.of(context).size.width - 48,
              child: _detailsSection(alert, context),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _detailsHeader(AlertData alert, BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      AlertThumbnail(fileName: alert.thumbUrl?.first, size: 80),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Main Heading", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Row(
              children: [
                Text("Category", style: Theme.of(context).textTheme.bodySmall),
                Text(
                  ": ${alert.zoneName}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: kSkyBlue300),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "Created on: ${_formatDate(alert.timestamp)}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _detailsSection(AlertData alert, BuildContext context) {
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    color: kNeutralWhite,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          _infoBlock("Analytic ID", alert.analyticId?.toString(), context),
          _infoBlock("Camera Name", alert.cameraName, context),
          _infoBlock("Camera ID", alert.cameraId.toString(), context),
          _infoBlock("Analytic Type", alert.analyticType, context),
          _infoBlock("Zone ID", alert.zoneId?.toString(), context),
          _infoBlock("Timestamp", alert.timestamp, context),
        ],
      ),
    ),
  );
}

Widget _infoBlock(String label, String? value, BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: klTextMedium),
        ),
        const SizedBox(height: 4),
        Text(
          value ?? '{}',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: klTextMedium, height: 1.29),
        ),
      ],
    ),
  );
}

String _formatDate(String? timestamp) {
  if (timestamp == null) return '';
  final ts = int.tryParse(timestamp) ?? 0;
  final dt = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
  final isAm = dt.hour < 12;
  final hour = isAm ? dt.hour : dt.hour - 12;
  return "${dt.day.toString().padLeft(2, '0')}/"
      "${dt.month.toString().padLeft(2, '0')}/"
      "${dt.year.toString().substring(2)}, "
      "${hour.toString().padLeft(2, '0')}:"
      "${dt.minute.toString().padLeft(2, '0')} ${isAm ? 'AM' : 'PM'}";
}
