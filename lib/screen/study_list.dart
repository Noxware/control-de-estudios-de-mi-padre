import 'package:control_de_estudios_de_papa/cubit/study_list_cubit.dart';
import 'package:control_de_estudios_de_papa/model/study.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'study_view.dart';

class StudyList extends StatelessWidget {
  const StudyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estudios'),
      ),
      body: BlocBuilder<StudyListCubit, StudyListState>(
        builder: (context, state) {
          if (state is StudyListError) {
            return Text(
                '${state.error.toString()}\n\n${state.stackTrace.toString()}');
          }

          if (state is StudyListLoaded) {
            return _loaded(context, state);
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _loaded(BuildContext context, StudyListLoaded state) {
    final templates = state.templates;
    final studies = List<Study>.from(state.studies);
    studies.sort((s1, s2) {
      return s1.datetime!.compareTo(s2.datetime!);
    });
    final studiesByName = _groupStudiesByName(studies);
    final studyNames = studiesByName.keys.toList();
    final templateNames = templates.map((t) => t.name).toList();
    templateNames.sort();

    final rows = templateNames.map((n) {
      final lastDt = studiesByName[n]?.last.datetime;

      return DataRow(
        onSelectChanged: (_) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return StudyView(name: n);
            },
          ));
        },
        cells: [
          DataCell(Text(n)),
          // TODO: Realmente checkar que este sea el ultimo a la fecha
          DataCell(Text(lastDt != null
              ? '${lastDt.day}/${lastDt.month}/${lastDt.year}'
              : '-')),
          DataCell(Text(studiesByName[n]?.length.toString() ?? '0')),
        ],
      );
    }).toList();

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text('Nombre')),
            DataColumn(label: Text('Ultimo')),
            DataColumn(label: Text('Cantidad')),
          ],
          rows: rows,
        ),
      ),
    );
  }

  static Map<String, List<Study>> _groupStudiesByName(List<Study> studies) {
    final res = <String, List<Study>>{};

    for (final s in studies) {
      if (!res.containsKey(s.name)) {
        res[s.name] = [];
      }

      res[s.name]!.add(s);
    }

    return res;
  }
}
