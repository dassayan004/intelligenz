import 'package:flutter/material.dart';
import 'package:intelligenz/widgets/change_analytics_widget.dart';
import 'package:intelligenz/widgets/recent_alerts.dart';
import 'package:intelligenz/widgets/reusable_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReusableAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            DefaultAnalyticsCard(),
            SizedBox(height: 36),
            RecentAlertsCard(),
          ],
        ),
      ),
    );
  }
}
