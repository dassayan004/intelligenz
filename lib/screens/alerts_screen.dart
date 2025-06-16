import 'package:flutter/material.dart';
import 'package:intelligenz/widgets/reusable_app_bar.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const ReusableAppBar(title: "Analytics Alert History"),
          body: Center(child: Text('Alert Screen')),
        ),
      ],
    );
  }
}
