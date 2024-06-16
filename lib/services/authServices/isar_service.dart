import 'package:isar/isar.dart';
import 'package:fishstick_gym/models/token.dart';
import 'package:path_provider/path_provider.dart';

class IsarService{
 late Future<Isar> db;

  IsarService() {
    db = openDB();
  }
  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([TokenSchema],
          inspector: true, directory: dir.path);
    }
    return Future.value(Isar.getInstance());
  }
  Future<void> createToken(String token, User user, String role) async {
    final isar = await db;
    final existingToken = await isar.tokens.where().findFirst();

    if (existingToken != null) {
      existingToken.jwt = token;
      existingToken.user = user;
      existingToken.role = role;
      await isar.writeTxn(() async {
        await isar.tokens.put(existingToken);
      });
    } else {
      final newToken = Token(jwt: token, user: user, role: role);
      await isar.writeTxn(() async {
        await isar.tokens.put(newToken);
      });
    }
  }
  
  Future<String?> getToken() async {
    final isar = await db;
    final token = await isar.tokens.where().findFirst();
    return token?.jwt;
  }

  Future<User> getUser() async {
    final isar = await db;
    final token = await isar.tokens.where().findFirst();
    return token!.user;
  }

  Future<String?> getRole() async {
    final isar = await db;
    final token = await isar.tokens.where().findFirst();

    return token?.role;
  }
}
