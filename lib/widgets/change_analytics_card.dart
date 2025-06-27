import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/constants/size_constant.dart';
import 'package:intelligenz/core/services/analytics/cubit/analytics_cubit.dart';
import 'package:intelligenz/core/utils/theme/radio_field_theme.dart';
import 'package:intelligenz/db/analytics/analytics_model.dart';
import 'package:intelligenz/models/analytics_response.dart';

class ChangeAnalyticsCard extends StatefulWidget {
  const ChangeAnalyticsCard({super.key});

  @override
  State<ChangeAnalyticsCard> createState() => _ChangeAnalyticsCardState();
}

class _ChangeAnalyticsCardState extends State<ChangeAnalyticsCard> {
  AnalyticsList? _selectedAnalytic;
  AnalyticsModel? _defaultSelectedModel;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AnalyticsCubit>();
    cubit.loadSelectedAnalytics();
    cubit.fetchAnalyticsList();
  }

  void _onAnalyticsSelected(AnalyticsList analytic) {
    debugPrint('Selected: ${analytic.hashId} - ${analytic.analyticName}');
    setState(() => _selectedAnalytic = analytic);
    context.read<AnalyticsCubit>().selectAnalytics(analytic);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Default analytics changed to "${analytic.analyticName}"',
        ),
        behavior: SnackBarBehavior.floating,

        duration: const Duration(seconds: 2),
        backgroundColor: kSuccessColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AnalyticsCubit, AnalyticsState>(
          listenWhen: (previous, current) => current is AnalyticsLoaded,
          listener: (context, state) {
            if (state is AnalyticsLoaded) {
              _defaultSelectedModel = state.selectedAnalytics;
            }
          },
        ),
      ],
      child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        buildWhen: (previous, current) =>
            current is AnalyticsListLoaded || current is AnalyticsError,
        builder: (context, state) {
          Widget content;

          if (state is AnalyticsListLoaded) {
            final list = state.analyticsList;

            // Set default analytic if not selected
            if (_selectedAnalytic == null && _defaultSelectedModel != null) {
              final matched = list.firstWhere(
                (a) => a.hashId == _defaultSelectedModel!.hashId,
                orElse: () => list.first,
              );
              _selectedAnalytic = matched;
            }

            content = AnalyticsRadioList(
              analyticsList: list,
              selectedAnalytic: _selectedAnalytic,
              onSelected: _onAnalyticsSelected,
            );
          } else if (state is AnalyticsError) {
            content = Center(child: Text(state.message));
          } else {
            content = _analyticsSkeletonList(context);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _analyticsTitleText(context),
              const SizedBox(height: 16),
              content,
            ],
          );
        },
      ),
    );
  }
}

class AnalyticsTitleText extends StatelessWidget {
  const AnalyticsTitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Change your default analytics',
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}

Widget _analyticsTitleText(BuildContext context) {
  return Text(
    'Change your default analytics',
    style: Theme.of(context).textTheme.headlineSmall,
  );
}

class AnalyticsRadioList extends StatelessWidget {
  final List<AnalyticsList> analyticsList;
  final AnalyticsList? selectedAnalytic;
  final ValueChanged<AnalyticsList> onSelected;

  const AnalyticsRadioList({
    super.key,
    required this.analyticsList,
    required this.selectedAnalytic,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
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
        itemCount: 5,
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
