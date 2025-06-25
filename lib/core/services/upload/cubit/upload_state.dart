import 'package:equatable/equatable.dart';
import 'package:intelligenz/db/upload/upload_model.dart';

abstract class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object> get props => [];
}

class UploadInitial extends UploadState {}

class UploadInProgress extends UploadState {}

class UploadSuccess extends UploadState {}

class UploadListLoaded extends UploadState {
  final List<UploadModel> uploads;

  const UploadListLoaded(this.uploads);

  @override
  List<Object> get props => [uploads];
}

class UploadFailure extends UploadState {
  final String error;

  const UploadFailure(this.error);

  @override
  List<Object> get props => [error];
}
