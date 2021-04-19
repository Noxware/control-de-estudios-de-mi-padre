import 'package:equatable/equatable.dart';

/// Tipo de dato/campo
enum StudyFieldType {
  number,
  text,
}

/// Metodo para convertir
extension StudyFieldTypeExtension on StudyFieldType {
  String toJson() {
    return this.toString().split('.')[1];
  }
}

/// Un campo del estudio
class StudyField extends Equatable {
  final StudyFieldType type;
  final String name;
  final dynamic value;
  final double? max;
  final double? min;

  const StudyField({
    required this.type,
    required this.name,
    required this.value,
    this.max,
    this.min,
  });

  @override
  List<Object?> get props => [
        type,
        name,
        value,
        max,
        min,
      ];

  Map<String, dynamic> toJson() {
    return {
      'type': type.toJson(),
      'name': name,
      'value': value,
      'max': max,
      'min': min,
    };
  }

  factory StudyField.fromJson(Map<String, dynamic> json) {
    return StudyField(
      type: _mapStringToType(json['type']),
      name: json['name'],
      value: json['value'],
      max: json['max']?.toDouble(),
      min: json['min']?.toDouble(),
    );
  }

  static StudyFieldType _mapStringToType(String s) {
    switch (s) {
      case 'text':
        return StudyFieldType.text;
      case 'number':
        return StudyFieldType.number;
      default:
        throw 'Tipo de field no reconocido "$s"';
    }
  }

  StudyField copyWith({
    StudyFieldType? type,
    String? name,
    dynamic? value,
    double? max,
    double? min,
  }) {
    return StudyField(
      type: type ?? this.type,
      name: name ?? this.name,
      value: value ?? this.value,
      max: max ?? this.max,
      min: min ?? this.min,
    );
  }
}
