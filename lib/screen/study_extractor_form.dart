import 'package:flutter/material.dart';
import 'package:control_de_estudios_de_papa/util/extractor/study_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:control_de_estudios_de_papa/cubit/study_form_cubit.dart';

class StudyExtractorForm extends StatefulWidget {
  const StudyExtractorForm({Key? key}) : super(key: key);

  @override
  _StudyExtractorFormState createState() => _StudyExtractorFormState();
}

class _StudyExtractorFormState extends State<StudyExtractorForm> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Extractor de valores semi-automatico')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  labelText: 'Copiar y pegar texto COMPLETO del estudio aqui',
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                ),
                onChanged: (text) {
                  this.text = text;
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _extract,
              child: Text('Intentar extraer'),
            ),
          ],
        ),
      ),
    );
  }

  void _extract() {
    final formCubit = context.read<StudyFormCubit>();
    final formReady = formCubit.state as StudyFormReady;
    final study = formReady.lastStudy;
    final fields = study.fields;

    final fieldNames = fields.map((f) => f.name).toList();
    final extractor = StudyTextExtractor(text: text, fieldNames: fieldNames);
    final extractedValues = extractor.fieldValues;

    print(extractedValues);

    final newFields = fields.map((f) {
      final value = extractedValues[f.name];
      return f.copyWith(value: value ?? f.value);
    }).toList();

    final newStudy = study.copyWith(fields: newFields);
    formCubit.set(newStudy: newStudy);
    Navigator.pop(context);
  }
}
