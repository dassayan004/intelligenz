// lib/screens/alert_details_screen.dart

import 'package:flutter/material.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AlertThumbnail(fileName: alert.thumbUrl?.first, size: 120),
            const SizedBox(height: 12),

            AlertImage(
              fileName: alert.imageUrl?.first,
              width: 300,
              height: 140,
            ),
            const SizedBox(height: 20),
            Text(
              "Alert Details : ${alert.toJson().toString()}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
          ],
        ),
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
}
