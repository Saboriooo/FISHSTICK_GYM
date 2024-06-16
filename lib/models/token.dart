import 'package:isar/isar.dart';
part 'token.g.dart';

@collection 
class Token {
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
class User {
    int? id;
    String? username;
    String? email;
    String? provider;
    bool? confirmed;
    bool? blocked;
    DateTime? createdAt;
    DateTime? updatedAt;
    

    User({
        this.id,
        this.username,
        this.email,
        this.provider,
        this.confirmed,
        this.blocked,
        this.createdAt,
        this.updatedAt,

    });

}
