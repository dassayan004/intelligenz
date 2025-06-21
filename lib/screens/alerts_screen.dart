import 'package:flutter/material.dart';
import 'package:intelligenz/widgets/alerts_card.dart';
import 'package:intelligenz/widgets/reusable_app_bar.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const ReusableAppBar(title: "Analytics Alert History"),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // DefaultAnalyticsCard(),
                AlertsCard(),
                SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
