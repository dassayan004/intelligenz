import 'package:flutter/material.dart';
import 'package:intelligenz/widgets/reusable_app_bar.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const ReusableAppBar(title: "Your Upload History"),
          body: Center(child: Text('Upload Screen')),
        ),
      ],
    );
  }
}
