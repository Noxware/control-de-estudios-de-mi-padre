import 'package:control_de_estudios_de_papa/cubit/study_form_cubit.dart';
import 'package:control_de_estudios_de_papa/cubit/study_list_cubit.dart';
import 'package:control_de_estudios_de_papa/model/study_field.dart';
import 'package:control_de_estudios_de_papa/screen/study_extractor_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class StudyForm extends StatefulWidget {
  StudyForm({Key? key}) : super(key: key);

  @override
  _StudyFormState createState() => _StudyFormState();
}

class _StudyFormState extends State<StudyForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudyFormCubit, StudyFormState>(
      listener: (context, state) async {
        if (state is StudyFormFail) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Operacion fallida'),
                content: Text(state.error.toString()),
                actions: [
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        }

        if (state is StudyFormSended) {
          await context.read<StudyListCubit>().load();
          Navigator.pop(context);
        }

        if (state is StudyFormReady) {
          final fields = state.lastStudy.fields;
          _formKey.currentState?.patchValue({
            for (final f in fields) f.name: f.value?.toString(),
          });
        }
      },
      builder: (context, state) {
        if (state is StudyFormReady) {
          print('REBUILDING');
          return _ready(context, state);
        }

        return _loading(context);
      },
    );
  }

  Widget _loading(BuildContext context) {
    return Material(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _ready(BuildContext context, StudyFormReady state) {
    final study = state.lastStudy;

    final formFields = <Widget>[
      FormBuilderDateTimePicker(
        name: 'datetime',
        inputType: InputType.date,
        format: DateFormat('dd/MM/yyyy'),
        decoration: InputDecoration(
          labelText: 'Fecha del estudio',
        ),
        initialValue: study.datetime,
        validator: FormBuilderValidators.required(
          context,
          errorText: 'Este campo es obligatorio',
        ),
      ),
      ...study.fields
          .map((f) => [
                SizedBox(height: 16),
                _mapFieldToFormField(f),
                SizedBox(height: 16)
              ])
          .expand((e) => e),
      Container(
        height: 35,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              final map = Map.from(_formKey.currentState!.value);

              final datetime = map.remove('datetime');

              final newFields = study.fields.map((f) {
                return f.copyWith(value: map[f.name]);
              }).toList();

              final newStudy =
                  study.copyWith(datetime: datetime, fields: newFields);

              context.read<StudyFormCubit>().send(newStudy: newStudy);
            } else {
              print("validation failed");
            }
          },
          child: Text('Guardar'),
        ),
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar estudio (${study.name})'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'Extractor de valores') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return BlocProvider.value(
                        value: context.read<StudyFormCubit>(),
                        child: StudyExtractorForm(),
                      );
                    },
                  ),
                );
              }
            },
            itemBuilder: (context) {
              return ['Extractor de valores'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        // No suar lazy list porque los valores del form se pierden
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: formFields,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapFieldToFormField(StudyField field) {
    switch (field.type) {
      case StudyFieldType.text:
        return FormBuilderTextField(
          name: field.name,
          initialValue: field.value,
          decoration: InputDecoration(
            labelText: field.name,
          ),
        );
      case StudyFieldType.number:
        return FormBuilderTextField(
          name: field.name,
          initialValue: field.value?.toString(),
          valueTransformer: (text) =>
              text != null ? double.tryParse(text) : null,
          decoration: InputDecoration(
            labelText: field.name,
          ),
          validator: FormBuilderValidators.numeric(
            context,
            errorText: 'Ingrese un numero valido (usar punto para decimales)',
          ),
          keyboardType: TextInputType.number,
        );
      default:
        throw 'No se como mostrar el campo para este tipo de dato';
    }
  }
}
