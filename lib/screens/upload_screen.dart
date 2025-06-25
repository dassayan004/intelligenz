import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/services/upload/cubit/upload_cubit.dart';
import 'package:intelligenz/core/services/upload/cubit/upload_state.dart';
import 'package:intelligenz/db/upload/upload_model.dart';

import 'package:intelligenz/widgets/reusable_app_bar.dart';
import 'dart:convert';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  void initState() {
    super.initState();

    context.read<UploadCubit>().fetchAllUploads(); // ✅ Called once
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReusableAppBar(title: "Your Upload History"),
      body: BlocBuilder<UploadCubit, UploadState>(
        builder: (context, state) {
          if (state is UploadListLoaded) {
            if (state.uploads.isEmpty) {
              return const Center(child: Text("No uploads found."));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<UploadCubit>().fetchAllUploads();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.uploads.length,
                itemBuilder: (context, index) {
                  final upload = state.uploads[index];
                  final jsonString = const JsonEncoder.withIndent(
                    '  ',
                  ).convert(upload.toJson());

                  return GestureDetector(
                    onTap: () => showUploadDetailsModal(context, upload),
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(jsonString),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is UploadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UploadFailure) {
            return Center(child: Text("❌ ${state.error}"));
          } else {
            return const Center(child: Text("Loading uploads..."));
          }
        },
      ),
    );
  }
}

extension UploadModelExtension on UploadModel {
  Map<String, dynamic> toJson() => {
    'filepath': filepath,
    'filesize': filesize,
    'fileType': fileType,
    'analyticHashId': analyticHashId,
    'description': description,
    'latitude': latitude,
    'longitude': longitude,
    'locations': locations.map((e) => e.toJson()).toList(),
    'startTimestamp': startTimestamp,
    'endTimestamp': endTimestamp,
    'timestamp': timestamp,
    'apiResponse': apiResponse,
    'status': status.name,
  };
}

extension LocationEntryExtension on LocationEntry {
  Map<String, dynamic> toJson() => {
    'timestamp': timestamp,
    'lat': lat,
    'long': long,
  };
}

void showUploadDetailsModal(BuildContext context, UploadModel upload) {
  final jsonString = const JsonEncoder.withIndent(
    '  ',
  ).convert(upload.toJson());
  final theme = Theme.of(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: kNeutralWhite,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: SelectableText(
                  jsonString,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
