import 'package:bloc/bloc.dart';
import 'package:control_de_estudios_de_papa/model/model.dart';
import 'package:control_de_estudios_de_papa/repository/study_repository.dart';
import 'package:equatable/equatable.dart';

part 'study_form_state.dart';

class StudyFormCubit extends Cubit<StudyFormState> {
  final StudyRepository _studyRepository;

  StudyFormCubit({required StudyRepository studyRepository})
      : _studyRepository = studyRepository,
        super(const StudyFormInitial());

  void init({required Study template}) {
    emit(StudyFormReady(lastStudy: template));
  }

  Future<void> send({required Study newStudy}) async {
    try {
      emit(const StudyFormSending());
      await _studyRepository.createStudy(newStudy);
      emit(const StudyFormSended());
    } catch (e, st) {
      emit(StudyFormFail(error: e, stackTrace: st));
      emit(StudyFormReady(lastStudy: newStudy));
      addError(e, st);
    }
  }

  void set({required Study newStudy}) {
    emit(StudyFormReady(lastStudy: newStudy));
  }

  @override
  void onChange(Change<StudyFormState> change) {
    print(change);
    super.onChange(change);
  }
}
