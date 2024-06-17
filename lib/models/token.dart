import 'package:isar/isar.dart';
part 'token.g.dart';

//Modelo de Token y Usuario

@collection 
class Token { //Modelo de Token
    Id? id;
    String? jwt;
    User user;
    String? role;

    Token({
        required this.jwt,
        required this.user,
        required this.role,
    });
}

@embedded
class User {//Modelo de Usuario
    int? id;
    String? username;
    String? email;
    String? provider;
    bool? confirmed;
    bool? blocked;
    DateTime? createdAt;
    DateTime? updatedAt;

    User({ //Constructor de la clase User
        this.id,
        this.username,
        this.email,
        this.provider,
        this.confirmed,
        this.blocked,
        this.createdAt,
        this.updatedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) { //Método para convertir un JSON en un objeto de tipo User
        return User(
            id: json['id'],
            username: json['attributes']['username'],
            email: json['attributes']['email'],
            provider: json['attributes']['provider'],
            confirmed: json['attributes']['confirmed'],
            blocked: json['attributes']['blocked'],
            createdAt: DateTime.parse(json['attributes']['createdAt']),
            updatedAt: DateTime.parse(json['attributes']['updatedAt']),
        );
    }
}
