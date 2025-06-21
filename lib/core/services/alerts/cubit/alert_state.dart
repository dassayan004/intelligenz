part of 'alert_cubit.dart';

abstract class AlertState {}

class AlertInitial extends AlertState {}

class AlertLoading extends AlertState {}

class AlertLoaded extends AlertState {
  final List<AlertData> alerts;

  AlertLoaded(this.alerts);
}

class AlertError extends AlertState {
  final String message;

  AlertError(this.message);
}
