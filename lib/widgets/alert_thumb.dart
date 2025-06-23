import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/constants/size_constant.dart';
import 'package:intelligenz/core/utils/image_fetch_util.dart';
import 'package:intelligenz/providers/dio_provider.dart';
import 'package:shimmer/shimmer.dart';

class AlertThumbnail extends StatelessWidget {
  final String? fileName;
  final double size;

  const AlertThumbnail({
    super.key,
    required this.fileName,
    this.size = 100, // fallback size
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SizeConstants.size100),
      child: FutureBuilder<Uint8List?>(
        future: _loadImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return _imgSkeleton();
          }

          if (snapshot.hasData && snapshot.data != null) {
            return Image.memory(
              snapshot.data!,
              width: size,
              height: size,
              fit: BoxFit.cover,
            );
          }

          return _placeholder();
        },
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: size,
      height: size,
      color: kNeutralGrey1000,
      child: const Icon(
        Icons.image_not_supported,
        size: 24,
        color: kNeutralGrey300,
      ),
    );
  }

  Widget _imgSkeleton() {
    return Shimmer.fromColors(
      baseColor: kNeutralGrey1000,
      highlightColor: kNeutralGrey900,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeConstants.size100),
        ),
      ),
    );
  }

  Future<Uint8List?> _loadImage() async {
    if (fileName == null || fileName!.isEmpty) return null;
    final dio = await DioProvider().client;
    return await ImageFetchUtil.fetchImage(fileName!, dio);
  }
}
