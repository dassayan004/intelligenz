import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/constants/size_constant.dart';
import 'package:intelligenz/core/services/analytics/cubit/analytics_cubit.dart';
import 'package:intelligenz/core/utils/theme/radio_field_theme.dart';
import 'package:intelligenz/models/analytics_response.dart';
import 'package:shimmer/shimmer.dart';

class AnalyticsRadioForm extends StatefulWidget {
  const AnalyticsRadioForm({super.key});

  @override
  State<AnalyticsRadioForm> createState() => _AnalyticsRadioFormState();
}

class _AnalyticsRadioFormState extends State<AnalyticsRadioForm> {
  AnalyticsList? _selectedAnalytic;

  @override
  void initState() {
    super.initState();
    context.read<AnalyticsCubit>().fetchAnalyticsList();
  }

  void _onAnalyticsSelected(AnalyticsList analytic) {
    debugPrint('Selected: ${analytic.hashId} - ${analytic.analyticName}');
    setState(() => _selectedAnalytic = analytic);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, state) {
        if (state is AnalyticsListLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _analyticsHeader(context),
              const SizedBox(height: 24),
              _analyticsRadioList(
                context: context,
                analyticsList: state.analyticsList,
                selectedAnalytic: _selectedAnalytic,
                onSelected: _onAnalyticsSelected,
              ),
              const SizedBox(height: 24),
              _analyticsSubmitButton(
                context: context,
                selectedAnalytic: _selectedAnalytic,
              ),
            ],
          );
        } else if (state is AnalyticsError) {
          return Center(child: Text(state.message));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _analyticsHeader(context),
            const SizedBox(height: 24),
            _analyticsSkeletonList(context),
          ],
        );
      },
    );
  }
}

Widget _analyticsHeader(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Last step, let’s set a default analytics',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      Text(
        '(can be changed later)',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}

Widget _analyticsRadioList({
  required BuildContext context,
  required List<AnalyticsList> analyticsList,
  required AnalyticsList? selectedAnalytic,
  required ValueChanged<AnalyticsList> onSelected,
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(SizeConstants.size100),
    ),
    color: kNeutralWhite,
    elevation: 0,
    child: SizedBox(
      height: 302,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: analyticsList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final analytic = analyticsList[index];
          return CustomCupertinoRadio<String>(
            value: analytic.hashId ?? '',
            groupValue: selectedAnalytic?.hashId ?? '',
            label: analytic.analyticName ?? '',
            onChanged: (_) => onSelected(analytic),
          );
        },
      ),
    ),
  );
}

Widget _analyticsSubmitButton({
  required BuildContext context,
  required AnalyticsList? selectedAnalytic,
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: selectedAnalytic == null
          ? null
          : () {
              context.read<AnalyticsCubit>().selectAnalytics(selectedAnalytic);
            },
      child: const Text('Continue'),
    ),
  );
}

Widget _analyticsSkeletonList(BuildContext context) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(SizeConstants.size100),
    ),
    color: kNeutralWhite,
    elevation: 0,
    child: SizedBox(
      height: 302,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: kNeutralGrey1000,
            highlightColor: kNeutralGrey900,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: kNeutralWhite,
              ),
            ),
          );
        },
      ),
    ),
  );
}
