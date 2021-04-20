const estudio = '''
RESULTADO ESTUDIO: IONOGRAMA EN SANGRE
Luis Alberto de Herrera 2275 - MONTEVIDEO
Director Tecnico Q.F. Soledad Carballo
Tel. 24871016 int 5252
REBECA CHAVEZ QUIROGA
6286126
JAVIER PROFETI GALLI
2014487-4
092354823
19/04/2021 06:35
SMI - SANATORIO
SERV. SANATORIAL MEDICINA (CAMA COMUN)
Orden: LABORATORIO DE SMI
Nombre:
CI:
Teléfono:
Fecha Ingreso:
Solicita Dr/a.:
Lugar Origen:
Procedencia:
Piso: 5
Habitación: 571
Cama: B
Informe realizado en:
Fecha resultado: 19/04/2021 07:25
Resultado Unidades Valores de referencia
SODIO EN SANGRE 137.1 mmol / l 135-145
M?todo: ELECTRODO SELECTIVO DE IONES
CLORO EN SANGRE 95.4 mmol / l 97-107
M?todo: ELECTRODO SELECTIVO DE IONES
POTASIO      EN SANGRE 3.97 mmol / l 3.8-5.1
M?todo: ELECTRODO SELECTIVO DE IONES
VALIDADO: Lic. Flavia Varela
''';

const campos = ['sodio en sangre', 'potasio en sangre'];

main(List<String> args) {
  List<String> lines;
  lines = estudio.split('\n');
  lines = lines.map((l) {
    return l.trim().toLowerCase().replaceAll(RegExp(r' +'), ' ');
  }).toList();

  final res = <String, double>{};

  for (final c in campos) {
    final l = searchLine(c, lines);

    if (l != null) {
      final n = extractFirstNumber(l);

      if (n != null) {
        res[c] = n;
      }
    }
  }

  print(res);
}

/// Retorna la linea que contiene el string (case-insensitive) o null si no
/// encuentra ninguna que cumpla la condicion.
String? searchLine(String content, List<String> lines) {
  for (final l in lines) {
    if (l.contains(content.toLowerCase())) {
      return l;
    }
  }
}

/// Extrae el primer que encuentre en la linea
double? extractFirstNumber(String line) {
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
