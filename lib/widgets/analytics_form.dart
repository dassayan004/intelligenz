import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligenz/core/services/analytics/cubit/analytics_cubit.dart';

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
    // Optional: if you want to update UI after debugging, uncomment below
    setState(() => _selectedHashId = value);
    context.read<AnalyticsCubit>().selectAnalytics(value ?? '');
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
              ...state.analyticsList.map((analytic) {
                return RadioListTile<String>(
                  value: analytic.hashId ?? '',
                  groupValue: _selectedHashId,
                  title: Text(analytic.analyticName ?? ''),
                  onChanged: _onAnalyticsSelected,
                );
              }),
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
