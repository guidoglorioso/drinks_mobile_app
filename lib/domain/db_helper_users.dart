import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelperUsers {
  // Singleton
  static final DbHelperUsers _instance = DbHelperUsers._internal();

  DbHelperUsers._internal();

  static DbHelperUsers get instance => _instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE users(
              idUser INTEGER PRIMARY KEY AUTOINCREMENT,
              userName VARCHAR(30),
              email VARCHAR(40) UNIQUE,
              psw VARCHAR(30),
              pictureUrl VARCHAR(200)
            );
          ''');
      },
    );
  }

  Future<bool> addUser(
    String username,
    String email,
    String psw,
    String url,
  ) async {
    if (_database == null) {
      return false;
    }
    final db = await database;

    int check = await db.rawInsert(
      '''
            INSERT INTO users (userName, email, psw, pictureUrl)
            VALUES (?,?,?,?);
     ''',
      [username, email, psw, url],
    );

    return (check > 0);
  }

  Future<bool> editUser(
    int idUser,
    String newUsername,
    String newEmail,
    String newPsw,
    String newUrl,
  ) async {
    final db = await database;

    int check = await db.rawUpdate(
      '''
        UPDATE users SET userName = ? , email = ?, psw = ?, pictureUrl = ? WHERE idUser = ?;
    ''',
      [newUsername, newEmail, newPsw, newUrl, idUser],
    );
    return (check > 0);
  }

  Future<Map<String, dynamic>?> getUserBy(String columna, dynamic valor) async {
    const columnasPermitidas = ['idUser', 'email'];

    if (!columnasPermitidas.contains(columna)) {
      throw ArgumentError(
        'Intento de búsqueda por columna no válida o peligrosa: $columna',
      );
    }

    final db = await database;

    List<Map<String, dynamic>> resultado = await db.rawQuery(
      '''
    SELECT * FROM users WHERE $columna = ? LIMIT 1;
  ''',
      [valor],
    );

    if (resultado.isNotEmpty) {
      return resultado.first; // Retorna el mapa del usuario encontrado
    }

    return null;
  }

  Future<List<Map<String, dynamic>>>? getDb() async {
    final db = await database;

    List<Map<String, dynamic>> resultado = await db.rawQuery('''
        SELECT * FROM users;
        ''');
    return resultado;
  }
}
