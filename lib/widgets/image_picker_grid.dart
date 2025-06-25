import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/services/uploadForm/cubit/upload_form_cubit.dart';
import 'package:intelligenz/core/utils/pick_image_geo.dart';

class ImagePickerGrid extends StatelessWidget {
  final bool isLoading;
  const ImagePickerGrid({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadFormCubit, UploadFormState>(
      builder: (context, state) {
        final List<ImageWithLocation> images = state.imagesData;
        final totalBoxes = 4;
        if (isLoading) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalBoxes, (_) {
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          );
        }
        return SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalBoxes, (index) {
              if (index < images.length) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(images[index].path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: -6,
                      right: -6,
                      child: GestureDetector(
                        onTap: () => context
                            .read<UploadFormCubit>()
                            .removeImageAt(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: kNeutralWhite,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: kNeutralBlack.withOpacity(0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: kNeutralGrey900,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return GestureDetector(
                  onTap: () async {
                    await pickImageWithLocation(context);
                  },
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      color: kNeutralGrey700,
                      radius: const Radius.circular(8),
                      strokeWidth: 1.5,
                      padding: EdgeInsets.zero,
                      dashPattern: const [6, 3],
                    ),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add_circle_rounded,
                          color: kNeutralGrey900,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                );
              }
            }),
          ),
        );
      },
    );
  }
}
