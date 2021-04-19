import 'dart:convert';
import 'dart:io';

import 'package:control_de_estudios_de_papa/model/model.dart';
import 'package:control_de_estudios_de_papa/provider/json_db.dart';

class StudyRepository {
  static Future<Map<String, dynamic>> _dbAsJson() async {
    final dbFile = (await JsonDb.instance()).file;
    final dbContent = await dbFile.readAsString();
    final dbJson = jsonDecode(dbContent) as Map<String, dynamic>;

    return dbJson;
  }

  Future<List<Study>> getStudies() async {
    final dbJson = await _dbAsJson();

    return (dbJson['studies'] as List)
        .map((s) => Study.fromJson(s))
        .toList(growable: false);
  }

  Future<List<Study>> getStudyTemplates() async {
    final dbJson = await _dbAsJson();

    return (dbJson['studyTemplates'] as List)
        .map((s) => Study.fromJson(s))
        .toList(growable: false);
  }

  /*Future<Map<String, List<Study>>> getStudiesGroupedByName() async {
    final studies = await getStudies();
    final res = <String, List<Study>>{};

    for (final s in studies) {
      if (!res.containsKey(s.name)) {
        res[s.name] = [];
      }

      res[s.name]!.add(s);
    }

    return res;
  }*/

  Future<void> createStudy(Study newStudy) async {
    final dbJson = await _dbAsJson();
    (dbJson['studies'] as List).add(newStudy.toJson());
    (await JsonDb.instance()).file.writeAsString(jsonEncode(dbJson));
  }

  /*Future<void> createStudyTemplate(Study template) async {
    final dbJson = await _dbAsJson();
    (dbJson['studyTemplates'] as List).add(template.toJson());
    (await JsonDb.instance()).file.writeAsString(jsonEncode(dbJson));
  }

  Future<void> addTempalteField(Study template) async {
    final dbJson = await _dbAsJson();
    (dbJson['studyTemplates'] as List).add(template.toJson());
    (await JsonDb.instance()).file.writeAsString(jsonEncode(dbJson));
  }*/
}
