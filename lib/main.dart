import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/study_list_cubit.dart';
import 'repository/study_repository.dart';
import 'screen/study_list.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => StudyRepository(),
      child: BlocProvider(
        create: (context) => StudyListCubit(
          studyRepository: RepositoryProvider.of<StudyRepository>(context),
        )..load(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Control de estudios de papa',
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          home: StudyList(),
        ),
      ),
    );
  }
}
