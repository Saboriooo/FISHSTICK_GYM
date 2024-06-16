class Course {
  final int id;
  final String nombre;
  final String capacidad;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;

  Course({
    required this.id,
    required this.nombre,
    required this.capacidad,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('attributes')) {
      return Course(
        id: json['id'],
        nombre: json['attributes']['Nombre'],
        capacidad: json['attributes']['Capacidad'],
        createdAt: DateTime.parse(json['attributes']['createdAt']),
        updatedAt: DateTime.parse(json['attributes']['updatedAt']),
        publishedAt: DateTime.parse(json['attributes']['publishedAt']),
      );
    } else {
      return Course(
        id: json['id'],
        nombre: json['Nombre'],
        capacidad: json['Capacidad'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        publishedAt: DateTime.parse(json['publishedAt'])
      );
    }
  }


}
