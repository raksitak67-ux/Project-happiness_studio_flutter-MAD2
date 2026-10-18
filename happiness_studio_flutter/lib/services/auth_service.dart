import '../models/user.dart';
import 'app_database.dart';

class AuthService {
  final _db = AppDatabase.instance;

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final db = await _db.database;
    try {
      await db.insert('users', AppUser(
        name: name.trim(),
        email: email.trim().toLowerCase(),
        password: password,
      ).toMap());
      return null;
    } catch (_) {
      return 'สมัครไม่สำเร็จ อีเมลนี้อาจถูกใช้แล้ว';
    }
  }

  Future<AppUser?> login(String email, String password) async {
    final db = await _db.database;
    final rows = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email.trim().toLowerCase(), password],
      limit: 1,
    );
    return rows.isEmpty ? null : AppUser.fromMap(rows.first);
  }
}
