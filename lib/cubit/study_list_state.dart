part of 'study_list_cubit.dart';

abstract class StudyListState extends Equatable {
  const StudyListState();

  @override
  List<Object?> get props => [];
}

class StudyListInitial extends StudyListState {
  const StudyListInitial();
}

class StudyListLoading extends StudyListState {
  const StudyListLoading();
}

class StudyListLoaded extends StudyListState {
  final List<Study> studies;
  final List<Study> templates;

  const StudyListLoaded({required this.studies, required this.templates});

  @override
  List<Object?> get props => [studies];
}

class StudyListError extends StudyListState {
  final Object error;
  final StackTrace? stackTrace;

  const StudyListError({required this.error, this.stackTrace});

  @override
  List<Object?> get props => [error, stackTrace];
}
