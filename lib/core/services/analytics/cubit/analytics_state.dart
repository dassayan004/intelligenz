part of 'analytics_cubit.dart';

abstract class AnalyticsState {}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final String selectedAnalytics;
  AnalyticsLoaded({required this.selectedAnalytics});
}

class AnalyticsListLoaded extends AnalyticsState {
  final List<AnalyticsList> analyticsList;
  AnalyticsListLoaded({required this.analyticsList});
}

class AnalyticsError extends AnalyticsState {
  final String message;
  AnalyticsError(this.message);
}
