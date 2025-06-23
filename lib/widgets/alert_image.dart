import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/constants/size_constant.dart';
import 'package:intelligenz/core/utils/image_fetch_util.dart';
import 'package:intelligenz/providers/dio_provider.dart';
import 'package:shimmer/shimmer.dart';

class AlertImage extends StatelessWidget {
  final String? fileName;
  final double width;
  final double height;

  const AlertImage({
    super.key,
    required this.fileName,
    this.width = 180,
    this.height = 100,
    // fallback size
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
              width: width,
              height: height,
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
      width: width,
      height: height,
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
        width: width,
        height: height,
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
