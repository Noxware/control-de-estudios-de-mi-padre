import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

class JsonDb {
  static JsonDb? _instance;
  final File file;

  JsonDb._(this.file);

  static Future<JsonDb> instance() async {
    final file = kDebugMode ? File('D:\\db.json') : File('db.json');

    if (kDebugMode && _instance == null && await file.exists()) {
      await file.delete();
    }

    if (!await file.exists()) {
      await file.create();
      await file.writeAsString(jsonEncode(_jsonDbDefaultContent));
    }

    if (_instance == null) {
      _instance = JsonDb._(file);
    }

    return _instance!;
  }

  Future<Map<String, dynamic>> getJson() async {
    final dbContent = await file.readAsString();
    final dbJson = jsonDecode(dbContent) as Map<String, dynamic>;

    return dbJson;
  }

  Future<void> setJson(Map<String, dynamic> json) async {
    final content = jsonEncode(json);
    file.writeAsString(content);
  }
}

const _jsonDbDefaultContent = {
  "studyTemplates": [
    {
      "name": "Hemograma",
      "datetime": null,
      "fields": [
        {
          "name": "Globulos blancos",
          "type": "number",
          "min": 4.8,
          "max": 10.8,
        },
        {
          "name": "Globulos rojos",
          "type": "number",
          "min": 4.5,
          "max": 5.9,
        },
        {
          "name": "Hemoglobina en sangre",
          "type": "number",
          "min": 14,
          "max": 18,
        },
        {
          "name": "Hematocrito",
          "type": "number",
          "min": 40,
          "max": 52,
        },
        {
          "name": "Volumen corpuscular medio",
          "type": "number",
          "min": 80,
          "max": 96,
        },
        {
          "name": "Hemoglobina corpuscular media",
          "type": "number",
          "min": 28,
          "max": 33,
        },
        {
          "name": "Conc. Corpuscular Media de HB",
          "type": "number",
          "min": 32,
          "max": 35,
        },
        {
          "name": "Recuento plaquetario",
          "type": "number",
          "min": 132,
          "max": 409,
        },
        {
          "name": "Linfocitos %",
          "type": "number",
          "min": 20,
          "max": 40,
        },
        {
          "name": "Monocitos %",
          "type": "number",
          "min": 2,
          "max": 12,
        },
        {
          "name": "Neutrofilos %",
          "type": "number",
          "min": 40,
          "max": 65,
        },
        {
          "name": "Eosinofilos %",
          "type": "number",
          "min": 2,
          "max": 4,
        },
        {
          "name": "Basofilos %",
          "type": "number",
          "min": 0,
          "max": 1,
        },

        //////////////////

        {
          "name": "Linfocitos #",
          "type": "number",
          "min": 1,
          "max": 4,
        },
        {
          "name": "Monocitos #",
          "type": "number",
          "min": 0,
          "max": 1.5,
        },
        {
          "name": "Neutrofilos #",
          "type": "number",
          "min": 1.5,
          "max": 8,
        },
        {
          "name": "Eosinofilos #",
          "type": "number",
          "min": 0,
          "max": 0.65,
        },
        {
          "name": "Basofilos #",
          "type": "number",
          "min": 0,
          "max": 0.15,
        },

        //////

        {
          "name": "Ancho de dist. eritrocitaria",
          "type": "number",
          "min": 11.5,
          "max": 14.5,
        },
        {
          "name": "Volumen plaquetario medio",
          "type": "number",
          "min": 7.4,
          "max": 10.4,
        },
      ]
    },
    {
      "name": "Ferritina",
      "datetime": null,
      "fields": [
        {
          "name": "Ferritina",
          "type": "number",
          "value": null,
          "min": 23,
          "max": 200,
        },
      ]
    },
    /*{
      "name": "Hemocultivo",
      "datetime": null,
      "fields": [
        {
          "name": "Informe",
          "type": "text",
        },
      ]
    },*/
    /*{
      "name": "Urocultivo",
      "datetime": null,
      "fields": [
        {
          "name": "Informe",
          "type": "text",
        },
      ]
    },*/
    {
      "name": "Urea en sangre",
      "datetime": null,
      "fields": [
        {
          "name": "Urea en sangre",
          "type": "number",
          "min": 0.1,
          "max": 0.45,
        },
      ]
    },
    {
      "name": "Proteina C Reactiva",
      "datetime": null,
      "fields": [
        {
          "name": "Proteina C Reactiva",
          "type": "number",
          "min": 0,
          "max": 5,
        },
      ]
    },
    {
      "name": "Dimeros D",
      "datetime": null,
      "fields": [
        {
          "name": "Dimeros D",
          "type": "number",
          "min": 0,
          "max": 0.5,
        },
      ]
    },
    {
      "name": "Creatinina en sangre",
      "datetime": null,
      "fields": [
        {
          "name": "Creatinina en sangre",
          "type": "number",
          "min": 0.71,
          "max": 1.21,
        },
      ]
    },
    {
      "name": "Ionograma en sangre",
      "datetime": null,
      "fields": [
        {
          "name": "Sodio en sangre",
          "type": "number",
          "min": 135,
          "max": 145,
        },
        {
          "name": "Cloro en sangre",
          "type": "number",
          "min": 97,
          "max": 107,
        },
        {
          "name": "Potasio en sangre",
          "type": "number",
          "min": 3.8,
          "max": 5.1,
        },
      ]
    },
    {
      "name": "Glicemia",
      "datetime": null,
      "fields": [
        {
          "name": "Glicemia",
          "type": "number",
          "min": 0.7,
          "max": 1.1,
        },
      ]
    },
  ],
  "studies": []
};
