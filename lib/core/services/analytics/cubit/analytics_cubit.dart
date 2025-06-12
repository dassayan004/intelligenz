import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligenz/core/services/analytics/analytics_repository.dart';
import 'package:intelligenz/models/analytics_response.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final AnalyticsRepository _repository;
  AnalyticsCubit(this._repository) : super(AnalyticsInitial()) {
    loadSelectedAnalytics();
  }

  Future<bool> loadSelectedAnalytics() async {
    final hashId = await _repository.getHashId();
    emit(AnalyticsLoaded(selectedAnalytics: hashId ?? ''));
    debugPrint('Hash is logged in: $hashId');
    return hashId != null && hashId.isNotEmpty;
  }

  Future<void> fetchAnalyticsList() async {
    try {
      final list = await _repository.getAnalytics();
      debugPrint('Analytics list: $list');
      emit(AnalyticsListLoaded(analyticsList: list));
    } catch (e) {
      emit(AnalyticsError('Failed to load analytics list'));
    }
  }

  Future<void> selectAnalytics(String value) async {
    await _repository.setHashId(value);
    emit(AnalyticsLoaded(selectedAnalytics: value));
  }

  Future<void> clear() async {
    await _repository.clearHashId();
    debugPrint('hash out');
    emit(AnalyticsInitial());
  }
}
