import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligenz/core/services/analytics/analytics_repository.dart';
import 'package:intelligenz/db/analytics/analytics_model.dart';
import 'package:intelligenz/models/analytics_response.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final AnalyticsRepository _repository;
  AnalyticsCubit(this._repository) : super(AnalyticsInitial()) {
    loadSelectedAnalytics();
  }

  Future<bool> loadSelectedAnalytics() async {
    final selected = await _repository.getSelectedAnalytics();
    if (selected != null) {
      emit(AnalyticsLoaded(selectedAnalytics: selected));
      debugPrint(
        'Selected analytic: ${selected.hashId}, ${selected.analyticsName}',
      );
      return true;
    }
    emit(AnalyticsInitial());
    return false;
  }

  Future<void> fetchAnalyticsList() async {
    try {
      final list = await _repository.getAnalytics();

      emit(AnalyticsListLoaded(analyticsList: list));
    } catch (e) {
      emit(AnalyticsError('Failed to load analytics list'));
    }
  }

  Future<void> selectAnalytics(AnalyticsList value) async {
    final model = AnalyticsModel(
      hashId: value.hashId!,
      analyticsName: value.analyticName!,
    );
    await _repository.setSelectedAnalytics(model);

    emit(AnalyticsLoaded(selectedAnalytics: model));
  }

  Future<void> clear() async {
    await _repository.clearSelectedAnalytics();
    debugPrint('Selected analytic cleared');
    emit(AnalyticsInitial());
  }
}
