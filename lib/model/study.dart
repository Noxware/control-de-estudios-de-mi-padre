import 'package:equatable/equatable.dart';

import 'study_field.dart';

/// Un estudio
class Study extends Equatable {
  final String name;
  final DateTime? datetime;
  final List<StudyField> fields;

  const Study({
    required this.name,
    required this.datetime,
    required this.fields,
  });

  @override
  List<Object?> get props => [name, datetime, fields];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'datetime': datetime?.toString(),
      'fields': fields.map((f) => f.toJson()).toList(growable: false),
    };
  }

  factory Study.fromJson(Map<String, dynamic> json) {
    return Study(
      name: json['name'],
      datetime:
          json['datetime'] != null ? DateTime.parse(json['datetime']) : null,
      fields:
          (json['fields'] as List).map((f) => StudyField.fromJson(f)).toList(),
    );
  }

  Study copyWith({
    String? name,
    DateTime? datetime,
    List<StudyField>? fields,
  }) {
    return Study(
      name: name ?? this.name,
      datetime: datetime ?? this.datetime,
      fields: fields ?? this.fields,
    );
  }
}
