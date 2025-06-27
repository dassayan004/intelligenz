import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/services/auth/cubit/auth_cubit.dart';

class VideoIntervalDropdown extends StatelessWidget {
  const VideoIntervalDropdown({super.key});

  final List<int> intervals = const [5, 10, 20, 30];

  Future<int?> _loadSavedInterval(BuildContext context) async {
    final cubit = context.read<AuthCubit>();
    final savedValueStr = await cubit.getVideoLocationInterval();
    final savedValue = (savedValueStr);
    return intervals.contains(savedValue) ? savedValue : null;
  }

  void _onChanged(BuildContext context, int? newValue) {
    if (newValue == null) return;
    context.read<AuthCubit>().setVideoLocationInterval(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: _loadSavedInterval(context),
      builder: (context, snapshot) {
        final selectedInterval = snapshot.data;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Video Interval',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: kNeutralBlack,
              ),
            ),
            const SizedBox(height: 4),
            DropdownButtonFormField2<int>(
              isExpanded: true,
              dropdownStyleData: DropdownStyleData(
                elevation: 1,
                offset: const Offset(0, -5),
                decoration: BoxDecoration(
                  color: kNeutralWhite,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              value: selectedInterval,
              items: intervals
                  .map(
                    (value) => DropdownMenuItem<int>(
                      value: value,
                      child: Text('${value}s'),
                    ),
                  )
                  .toList(),
              onChanged: (value) => _onChanged(context, value),
              hint: const Text('Select interval'),
            ),
          ],
        );
      },
    );
  }
}
