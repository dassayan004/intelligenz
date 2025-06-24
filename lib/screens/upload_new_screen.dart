import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intelligenz/widgets/reusable_app_bar.dart';

class UploadNewScreen extends StatelessWidget {
  final String imagePath;

  const UploadNewScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReusableAppBar(title: "Upload New Items"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Upload New Item'),
            const SizedBox(height: 20),
            Image.file(
              File(imagePath),
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text('Path: $imagePath'),
          ],
        ),
      ),
    );
  }
}
