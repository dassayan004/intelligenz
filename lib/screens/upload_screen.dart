import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intelligenz/core/constants/hive_constants.dart';
import 'package:intelligenz/core/services/upload/cubit/upload_state.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/services/upload/cubit/upload_cubit.dart';
import 'package:intelligenz/core/utils/theme/refresh_indicator.dart';
import 'package:intelligenz/db/upload/upload_model.dart';
import 'package:intelligenz/models/upload_response.dart';

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
      body: ValueListenableBuilder(
        valueListenable: Hive.box<UploadModel>(uploadBox).listenable(),
        builder: (context, Box<UploadModel> box, _) {
          final uploads = box.values.toList().reversed.toList();
          if (uploads.isEmpty) {
            return const Center(child: Text("No uploads found."));
          }

          return TRefreshIndicator(
            onRefresh: () async {
              context.read<UploadCubit>().fetchAllUploads();
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [_buildUploadCard(uploads, context: context)],
            ),
          );
        },
      ),
    );
  }
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

Widget _buildUploadCard(
  List<UploadModel> uploads, {
  required BuildContext context,
}) {
  final Map<String, List<UploadModel>> groupedUploads = {};
  for (final upld in uploads) {
    final label = _formatAlertDateGroup(upld.timestamp.toString());
    groupedUploads.putIfAbsent(label, () => []).add(upld);
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: groupedUploads.entries.map((entry) {
      final label = entry.key;
      final uploads = entry.value;

      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: kNeutralWhite,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              ...uploads.asMap().entries.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key == uploads.length - 1 ? 0 : 16,
                  ),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => showUploadDetailsModal(context, entry.value),
                      child: RecentUploadRow(upload: entry.value),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

class RecentUploadRow extends StatelessWidget {
  final UploadModel upload;

  const RecentUploadRow({super.key, required this.upload});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Thumbnail
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(upload.filepath),
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(width: 12),

        // Filename, size, time, date, category
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                truncateFilename(getFilenameFromPath(upload.filepath)),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    _formatFileSize(upload.filesize),
                    style: theme.textTheme.labelSmall,
                  ),
                  const SizedBox(width: 12),

                  Text(
                    _formatDate(upload.timestamp.toString()),
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                upload.analyticName, // or `upload.analyticHashId ?? 'Traffic'`
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: kSkyBlue300,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Circular Progress (dummy 75% for now)
        _buildStatusIndicator(context, upload),
      ],
    );
  }

  String getFilenameFromPath(String path) {
    return p.basename(path);
  }

  String truncateFilename(
    String filename, {
    int headLength = 8,
    int tailLength = 10,
  }) {
    if (filename.length <= headLength + tailLength) return filename;

    final head = filename.substring(0, headLength);
    final tail = filename.substring(filename.length - tailLength);
    return '$head...$tail';
  }

  String _formatFileSize(int? bytes) {
    if (bytes == null) return '0 KB';

    final kb = bytes / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(1)} KB';
    } else {
      final mb = kb / 1024;
      return '${mb.toStringAsFixed(1)} MB';
    }
  }

  String _formatDate(String? timestamp, {bool showTime = true}) {
    if (timestamp == null) return '';
    final ts = int.tryParse(timestamp) ?? 0;
    if (ts == 0) return '';

    final dt = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
    final date =
        "${dt.day.toString().padLeft(2, '0')}/"
        "${dt.month.toString().padLeft(2, '0')}/"
        "${dt.year.toString().substring(2)}";

    if (!showTime) return date;

    final isAm = dt.hour < 12;
    final hour = isAm ? dt.hour : dt.hour - 12;
    final time =
        "${hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')} ${isAm ? 'AM' : 'PM'}";

    return "$date, $time";
  }
}

Widget _buildStatusIndicator(BuildContext context, UploadModel upload) {
  final state = context.watch<UploadCubit>().state;
  int progress = 0;

  if (state is UploadListLoaded) {
    final key = upload.key;
    if (key != null) {
      progress = state.progressMap[key] ?? 0;
      // print('Progress for $key → $progress%');
    }
  }
  switch (upload.status) {
    case UploadStatus.uploading:
      return Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              value: progress / 100,
              strokeWidth: 4,
              backgroundColor: kNeutralGrey1000,
              valueColor: const AlwaysStoppedAnimation<Color>(kSunsetOrange500),
            ),
          ),
          Text(
            '$progress%',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      );

    case UploadStatus.uploaded:
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: kSuccessColor, width: 3),
        ),
        alignment: Alignment.center,
        child: Text(
          'Done',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: kSuccessColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

    case UploadStatus.failed:
      return GestureDetector(
        onTap: () {
          context.read<UploadCubit>().retryUpload(upload.key as int);
        },
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kSunsetOrange1000,
            border: Border.all(color: kErrorColor, width: 3),
          ),
          alignment: Alignment.center,
          child: Text(
            'Retry',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: kErrorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
  }
}

String _formatAlertDateGroup(String? timestamp) {
  if (timestamp == null) return '';

  final ts = int.tryParse(timestamp) ?? 0;
  if (ts == 0) return '';

  final alertDate = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
  final now = DateTime.now();

  final isToday =
      alertDate.year == now.year &&
      alertDate.month == now.month &&
      alertDate.day == now.day;

  final isYesterday =
      alertDate.year == now.year &&
      alertDate.month == now.month &&
      alertDate.day == now.day - 1;

  if (isToday) return 'Today';
  if (isYesterday) return 'Yesterday';

  return DateFormat('dd MMM yyyy').format(alertDate);
}
