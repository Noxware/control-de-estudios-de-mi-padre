class StudyTextExtractor {
  final String text;
  final List<String> fieldNames;
  final Map<String, dynamic> fieldValues = {};

  StudyTextExtractor({required this.text, required this.fieldNames}) {
    // Se separa el texto en lineas normalizadas.
    //
    // Las lineas normalizadas estan trimeadas, lowercaseadas y usan
    // espacios simples en vez de multiples.
    List<String> lines;
    lines = text.split('\n');
    lines = lines.map((l) {
      return l.trim().toLowerCase().replaceAll(RegExp(r' +'), ' ');
    }).toList();

    // Se itera sobre cada campo conocido
    for (final f in fieldNames) {
      // Se busca una linea en la lista de lineas que contenga el nombre del
      // campo (case-insensitive).
      final l = _searchLine(f, lines);

      // Si se encontro
      if (l != null) {
        // Extraer el primer numero de esa linea
        final n = _extractFirstNumber(l);

        // Si se encontro un primer numero, registrarlo junto al nombre del
        // campo.
        if (n != null) {
          fieldValues[f] = n;
        }
      }
    }
  }

  /// Retorna la linea que contiene el string (case-insensitive) o null si no
  /// encuentra ninguna que cumpla la condicion.
  String? _searchLine(String content, List<String> lines) {
    for (final l in lines) {
      if (l.contains(content.toLowerCase())) {
        return l;
      }
    }
  }

  /// Extrae el primer numero que encuentre en la linea o null si no hay
  double? _extractFirstNumber(String line) {
    // Copia
    var l = line;

    // Dejar solo numeros espacios y puntos
    l = l.replaceAll(RegExp(r'[^0-9. ]'), '');

    // Remover espacios iniciales y finales
    l = l.trim();

    // Dejar solo un espacio maximo entre cada cosa
    l = l.replaceAll(RegExp(r' +'), ' ');

    // Aislar los numeros como strings
    var ns = l.split(' ');

    // Si no hay elementos retornar null
    if (ns.isEmpty) {
      return null;
    }

    // Retornar el primer elemento como numero, o null si no es un numero
    return double.tryParse(ns.first);
  }
}
