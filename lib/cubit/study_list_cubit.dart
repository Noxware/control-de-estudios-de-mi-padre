import 'package:bloc/bloc.dart';
import 'package:control_de_estudios_de_papa/model/model.dart';
import 'package:control_de_estudios_de_papa/repository/study_repository.dart';
import 'package:equatable/equatable.dart';

part 'study_list_state.dart';

class StudyListCubit extends Cubit<StudyListState> {
  final StudyRepository _studyRepository;

  StudyListCubit({
    required StudyRepository studyRepository,
  })   : _studyRepository = studyRepository,
        super(const StudyListInitial());

  Future<void> load() async {
    try {
      emit(const StudyListLoading());
      final studies = await _studyRepository.getStudies();
      final templates = await _studyRepository.getStudyTemplates();
      emit(StudyListLoaded(studies: studies, templates: templates));
    } catch (e, st) {
      emit(StudyListError(error: e, stackTrace: st));
      addError(e, st);
    }
  }
}
