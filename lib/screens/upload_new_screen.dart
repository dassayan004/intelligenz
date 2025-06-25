import 'package:flutter/material.dart';
import 'package:intelligenz/widgets/image_picker_grid.dart';
import 'package:intelligenz/widgets/reusable_app_bar.dart';

class UploadNewScreen extends StatelessWidget {
  const UploadNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReusableAppBar(title: "Upload New Items"),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: UploadFormContent(),
      ),
    );
  }
}

class UploadFormContent extends StatelessWidget {
  const UploadFormContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        ImagePickerGrid(),
        SizedBox(height: 24),
        MediaButtonsRow(),
        SizedBox(height: 24),
        // DescriptionField(),
        SizedBox(height: 24),
        // ActionButtons(),
      ],
    );
  }
}

class MediaButtonsRow extends StatelessWidget {
  const MediaButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.videocam),
            label: const Text('Video'),
            onPressed: () {
              // TODO: Implement video picker
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.image),
            label: const Text('Image'),
            onPressed: () {
              // TODO: Implement gallery image picker
            },
          ),
        ),
      ],
    );
  }
}
