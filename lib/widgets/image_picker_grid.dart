import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/services/uploadForm/cubit/upload_form_cubit.dart';

class ImagePickerGrid extends StatelessWidget {
  const ImagePickerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadFormCubit, UploadFormState>(
      builder: (context, state) {
        final images = state.imagePaths;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(4, (index) {
            if (index < images.length) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(images[index]),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: GestureDetector(
                      onTap: () =>
                          context.read<UploadFormCubit>().removeImageAt(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
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
                  final picker = ImagePicker();
                  final image = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    context.read<UploadFormCubit>().addImage(image.path);
                  }
                },
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    color: kNeutralGrey700,
                    radius: const Radius.circular(8),
                    strokeWidth: 1.5,
                    padding: EdgeInsets.all(0),
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
        );
      },
    );
  }
}
