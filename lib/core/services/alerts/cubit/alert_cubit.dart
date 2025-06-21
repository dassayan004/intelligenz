import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligenz/core/services/alerts/alert_repository.dart';
import 'package:intelligenz/models/alert_response.dart';

part 'alert_state.dart';

class AlertCubit extends Cubit<AlertState> {
  final AlertRepository _repository;

  AlertCubit(this._repository) : super(AlertInitial());

  Future<void> fetchAlerts(String analyticsName) async {
    emit(AlertLoading());
    try {
      final alerts = await _repository.getAlertsFromAnalyticsName(
        analyticsName,
      );
      emit(AlertLoaded(alerts));
    } catch (_) {
      emit(AlertError("Failed to load alerts"));
    }
  }
}
