import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/services/auth/cubit/auth_cubit.dart';
import 'dart:io';

import 'package:intelligenz/widgets/reusable_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  File? _selectedVideo;
  String? _selectedFilePath;

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _selectedVideo = null;
        _selectedFilePath = image.path;
      });
      debugPrint('Image path: ${image.path}');
    }
  }

  Future<void> _openVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      setState(() {
        _selectedVideo = File(video.path);
        _selectedImage = null;
        _selectedFilePath = video.path;
      });
      debugPrint('Video path: ${video.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final bool isLoading = state is AuthLoading;

        Widget previewWidget;
        if (_selectedImage != null) {
          previewWidget = Image.file(
            _selectedImage!,
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          );
        } else if (_selectedVideo != null) {
          previewWidget = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.videocam, size: 100, color: Colors.grey),
              const SizedBox(height: 10),
              Text(
                'Video selected:\n${_selectedFilePath ?? ''}',
                textAlign: TextAlign.center,
              ),
            ],
          );
        } else {
          previewWidget = const Text('No file selected');
        }

        return Stack(
          children: [
            Scaffold(
              backgroundColor: klBackgroundColor,
              // appBar: AppBar(
              //   title: Text(widget.title),
              //   centerTitle: true,
              //   backgroundColor: klPrimaryColor,
              //   actions: [
              //     IconButton(
              //       icon: const Icon(Icons.logout),
              //       tooltip: 'Logout',
              //       onPressed: () async {
              //         await BlocProvider.of<AuthCubit>(context).logout();
              //       },
              //     ),
              //   ],
              // ),
              appBar: const ReusableAppBar(),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[previewWidget],
                ),
              ),
              floatingActionButton: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: 'cameraBtn',
                    backgroundColor: kButtonColor,
                    shape: const CircleBorder(),
                    onPressed: _openCamera,
                    tooltip: 'Open Camera',
                    child: const Icon(Icons.camera_alt),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: 'videoBtn',
                    backgroundColor: klAccentColor,
                    shape: const CircleBorder(),
                    onPressed: _openVideo,
                    tooltip: 'Open Video',
                    child: const Icon(Icons.videocam),
                  ),
                ],
              ),
            ),

            // Fullscreen loading overlay
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: kNeutralBlack.withAlpha(128),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
