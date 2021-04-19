part of 'study_form_cubit.dart';

abstract class StudyFormState extends Equatable {
  const StudyFormState();

  @override
  List<Object?> get props => [];
}

class StudyFormInitial extends StudyFormState {
  const StudyFormInitial();
}

class StudyFormReady extends StudyFormState {
  final Study lastStudy;

  const StudyFormReady({required this.lastStudy});

  @override
  List<Object?> get props => [lastStudy];
}

class StudyFormSending extends StudyFormState {
  const StudyFormSending();
}

class StudyFormSended extends StudyFormState {
  const StudyFormSended();
}

class StudyFormFail extends StudyFormState {
  final Object error;
  final StackTrace? stackTrace;

  const StudyFormFail({required this.error, this.stackTrace});

  @override
  List<Object?> get props => [error, stackTrace];
}
