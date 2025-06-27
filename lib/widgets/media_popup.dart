import 'package:flutter/material.dart';

class MediaMenuItem extends StatelessWidget {
  const MediaMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: const Icon(Icons.image, color: Colors.blue),
            title: const Text('Image'),
            onTap: () {
              // Navigator.pop(context, 'image');
            },
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 200,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: const Icon(Icons.video_call, color: Colors.red),
            title: const Text('Video'),
            onTap: () {
              // Navigator.pop(context, 'video');
            },
          ),
        ),
      ],
    );
  }
}
