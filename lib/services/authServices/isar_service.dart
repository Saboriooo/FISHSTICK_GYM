import 'package:isar/isar.dart';
import 'package:fishstick_gym/models/token.dart';
import 'package:path_provider/path_provider.dart';

//Servicio de la base de datos Isar

class IsarService{
 late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {//Abre la base de datos Isar
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([TokenSchema],
          inspector: true, directory: dir.path);
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> createToken(String token, User user, String role) async {//Crea un item de Token:User en la base de datos
    final isar = await db;
    final existingToken = await isar.tokens.where().findFirst();

    if (existingToken != null) {//Si ya existe un token
      existingToken.jwt = token;
      existingToken.user = user;
      existingToken.role = role;
      await isar.writeTxn(() async {
        await isar.tokens.put(existingToken);//Actualiza el token
      });
    } else {//Si no existe un token
      final newToken = Token(jwt: token, user: user, role: role);
      await isar.writeTxn(() async {
        await isar.tokens.put(newToken);//Crea un nuevo token
      });
    }
  }
  
  Future<String?> getToken() async {//Obtiene el token de la base de datos
    final isar = await db;
    final token = await isar.tokens.where().findFirst();
    return token?.jwt;
  }

  Future<User> getUser() async {//Obtiene el usuario de la base de datos
    final isar = await db;
    final token = await isar.tokens.where().findFirst();
    return token!.user;
  }

  Future<String?> getRole() async {//Obtiene el rol del usuario de la base de datos
    final isar = await db;
    final token = await isar.tokens.where().findFirst();

    return token?.role;
  }
}
