import 'package:flutter/material.dart';
import 'package:intelligenz/widgets/reusable_app_bar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const ReusableAppBar(title: "Application Settings"),
          body: Center(child: Text('Settings Screen')),
        ),
      ],
    );
  }
}
