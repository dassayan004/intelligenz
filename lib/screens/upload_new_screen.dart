import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intelligenz/core/constants/router_constant.dart';
import 'package:intelligenz/core/constants/size_constant.dart';
import 'package:intelligenz/core/services/analytics/cubit/analytics_cubit.dart';
import 'package:intelligenz/core/services/upload/cubit/upload_cubit.dart';
import 'package:intelligenz/core/services/uploadForm/cubit/upload_form_cubit.dart';
import 'package:intelligenz/core/utils/pick_image_geo.dart';
import 'package:intelligenz/core/utils/theme/elevated_btn_theme.dart';
import 'package:intelligenz/widgets/image_picker_grid.dart';
import 'package:intelligenz/widgets/reusable_app_bar.dart';

class UploadNewScreen extends StatefulWidget {
  final String imagePath;
  const UploadNewScreen({super.key, required this.imagePath});

  @override
  State<UploadNewScreen> createState() => _UploadNewScreenState();
}

class _UploadNewScreenState extends State<UploadNewScreen> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadImageAndLocation();
  }

  Future<void> _loadImageAndLocation() async {
    await context.read<UploadFormCubit>().addImageAndFetchLocation(
      widget.imagePath,
    );
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReusableAppBar(title: "Upload New Items"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: UploadFormContent(isLoading: _isLoading),
      ),
    );
  }
}

class UploadFormContent extends StatelessWidget {
  final bool isLoading;
  const UploadFormContent({super.key, required this.isLoading});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImagePickerGrid(isLoading: isLoading),
        const SizedBox(height: 24),
        MediaButtonsRow(isLoading: isLoading),
        const SizedBox(height: 24),
        const DescriptionField(),
        const SizedBox(height: 24),
        ActionButtons(isLoading: isLoading),
      ],
    );
  }
}

class MediaButtonsRow extends StatelessWidget {
  final bool isLoading;
  const MediaButtonsRow({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.videocam, size: 24),
            label: const Text('Video'),
            onPressed: isLoading
                ? null
                : () {
                    // TODO: Implement video picker
                  },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.camera_alt_rounded, size: 24),
            label: const Text('Image'),
            onPressed: isLoading
                ? null
                : () async {
                    await pickImageWithLocation(context);
                  },
          ),
        ),
      ],
    );
  }
}

class DescriptionField extends StatelessWidget {
  const DescriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadFormCubit, UploadFormState>(
      builder: (context, state) {
        final currentLength = state.description.length;
        const maxLength = 200;
        final remaining = maxLength - currentLength;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add a description (optional)",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontSize: SizeConstants.size300,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLength: 200,
              maxLines: 4,
              onChanged: context.read<UploadFormCubit>().updateDescription,
              decoration: InputDecoration(
                hintText: "Write something...",
                counterText: "$remaining characters remaining",
              ),
            ),
          ],
        );
      },
    );
  }
}

class ActionButtons extends StatelessWidget {
  final bool isLoading;
  const ActionButtons({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () async {
                    final state = context.read<UploadFormCubit>().state;
                    final analyticsCubitState = context
                        .read<AnalyticsCubit>()
                        .state;

                    if (analyticsCubitState is AnalyticsLoaded) {
                      unawaited(
                        context.read<UploadCubit>().submitUpload(
                          state,
                          analyticsCubitState.selectedAnalytics.hashId,
                          analyticsCubitState.selectedAnalytics.analyticsName,
                        ),
                      );
                      context.goNamed(AppRouteName.uploads.name);
                    } else {
                      debugPrint(
                        "⚠️ Analytics not loaded. Submission skipped or handled differently.",
                      );
                    }
                  },
            child: const Text("Continue"),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: TElevatedButtonTheme.lightSecondaryElevatedButtonTheme.style,
            onPressed: isLoading
                ? null
                : () {
                    Navigator.of(context).pop();
                  },
            child: const Text("Cancel"),
          ),
        ),
      ],
    );
  }
}
