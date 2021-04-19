import 'package:control_de_estudios_de_papa/cubit/study_form_cubit.dart';
import 'package:control_de_estudios_de_papa/cubit/study_list_cubit.dart';
import 'package:control_de_estudios_de_papa/repository/study_repository.dart';
import 'package:control_de_estudios_de_papa/screen/study_form.dart';
import 'package:control_de_estudios_de_papa/util/extension/string.dart';
import 'package:control_de_estudios_de_papa/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudyView extends StatelessWidget {
  final String name;

  const StudyView({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (context) => StudyFormCubit(
                  studyRepository:
                      RepositoryProvider.of<StudyRepository>(context),
                )..init(
                    template: (context.read<StudyListCubit>().state
                            as StudyListLoaded)
                        .templates
                        .firstWhere((t) => t.name == this.name)),
                child: StudyForm(),
              );
            },
          ));
        },
      ),
    );
  }

  Widget _loaded(BuildContext context, StudyListLoaded state) {
    // Lista de esutdios filtrada y ordenada a conveniencia
    final studiesMod =
        state.studies.reversed.where((s) => s.name == this.name).toList();

    studiesMod.sort((s1, s2) {
      return s2.datetime!.compareTo(s1.datetime!);
    });

    // Ultimos fields del estudio conocidos
    final fields =
        state.templates.firstWhere((t) => t.name == this.name).fields;

    // Generar una fila por cada field (por ejemplo una row para globulos blancos)
    final rows = List.generate(fields.length, (fieldIndex) {
      final cells = [
        // El primer elemento es el nombre del campo
        DataCell(Text(fields[fieldIndex].name)),

        // Luego hay que generar las cells para cada resultado de este tipo en todos los estudios
        ...studiesMod.map((s) {
          try {
            // Busco el field con el mismo nombre en el estudio
            final field =
                s.fields.firstWhere((f) => f.name == fields[fieldIndex].name);

            // Textos para el tooltip
            final tooltipText = [
              if (field.min != null && field.max != null)
                '\nValores de referencia\n\n',
              if (field.min != null) 'Min: ${field.min}\n',
              if (field.max != null) 'Max: ${field.max}\n',
            ].join('');

            // Agrego el valor a la tabla en la posicion correspondiente
            return DataCell(
              Tooltip(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (field.value != null)
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: _isValueOutOfRange(field)
                              ? Colors.red
                              : Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    SizedBox(width: 8),
                    Text(field.value != null ? field.value.toString() : '-'),
                  ],
                ),
                message: tooltipText,
                waitDuration: _isValueOutOfRange(field)
                    ? Duration.zero
                    : Duration(days: 365),
              ),
            );
          } on StateError catch (e) {
            // Pongo esto si no se encontre el campo en este estudio
            return DataCell(Text('-'));
          }
        }),
      ];

      return DataRow(
        cells: cells,
        onSelectChanged: (_) {
          '${fields[fieldIndex].name} ${this.name}'.google();
        },
      );
    });

    final columns = studiesMod.map((s) {
      final dt = s.datetime;

      return DataColumn(
        label: Text('${dt!.day}/${dt.month}/${dt.year}'),
      );
    }).toList();

    columns.insert(0, DataColumn(label: Container()));

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          columns: columns,
          rows: rows,
        ),
      ),
    );
  }

  static bool _isValueOutOfRange(StudyField f) {
    final hasValue = f.value != null;
    final hasMin = f.min != null;
    final hasMax = f.max != null;

    final tooLow = hasValue && hasMin && f.value < f.min;
    final tooHigh = hasValue && hasMax && f.value > f.max;

    return tooLow || tooHigh;
  }
}
