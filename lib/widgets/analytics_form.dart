import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/constants/size_constant.dart';
import 'package:intelligenz/core/services/analytics/cubit/analytics_cubit.dart';
import 'package:intelligenz/core/utils/theme/radio_field_theme.dart';

class AnalyticsRadioForm extends StatefulWidget {
  const AnalyticsRadioForm({super.key});

  @override
  State<AnalyticsRadioForm> createState() => _AnalyticsRadioFormState();
}

class _AnalyticsRadioFormState extends State<AnalyticsRadioForm> {
  String? _selectedHashId;

  @override
  void initState() {
    super.initState();
    context.read<AnalyticsCubit>().fetchAnalyticsList();
  }

  void _onAnalyticsSelected(String? value) {
    debugPrint('Selected hashId: $value');
    setState(() => _selectedHashId = value);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, state) {
        if (state is AnalyticsListLoaded) {
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
              const SizedBox(height: 24),
              Container(
                height: 302,
                decoration: BoxDecoration(
                  color: kNeutralWhite,
                  borderRadius: BorderRadius.circular(SizeConstants.size100),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.analyticsList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final analytic = state.analyticsList[index];
                    return CustomCupertinoRadio<String>(
                      value: analytic.hashId ?? '',
                      groupValue: _selectedHashId ?? '',
                      label: analytic.analyticName ?? '',
                      onChanged: _onAnalyticsSelected,
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedHashId == null
                      ? null
                      : () {
                          context.read<AnalyticsCubit>().selectAnalytics(
                            _selectedHashId!,
                          );
                        },
                  child: const Text('Continue'),
                ),
              ),
            ],
          );
        } else if (state is AnalyticsError) {
          return Center(child: Text(state.message));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
