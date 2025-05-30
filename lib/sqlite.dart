// abstraction
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Models/model_Appointment.dart';
import 'Models/model_user.dart';


abstract class ITableMigration {
  Future<void> createTable(Database db);
}

// migrations
class UserTableMigration implements ITableMigration {
  @override
  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        password TEXT,
        type TEXT
      )
    ''');
  }
}

class AppointmentTableMigration implements ITableMigration {
  @override
  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE appointments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        name TEXT,
        address TEXT,
        time TEXT,
        date TEXT,
        notes TEXT,
        status TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }
}

// initialization
class DatabaseInitializer {
  final List<ITableMigration> migrations;
  DatabaseInitializer(this.migrations);

  Future<void> initialize(Database db) async {
    for (var migration in migrations) {
      await migration.createTable(db);
    }
  }
}

// services
class UserService {
  final Database db;
  UserService(this.db);

  Future<void> insertUser(User user) async {
    await db.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    final maps = await db.query('users');
    return maps.map((map) {
      return User(
        id: map['id'] as int?,
        name: map['name'] as String? ?? '',
        email: map['email'] as String? ?? '',
        password: map['password'] as String? ?? '',
        type: map['type'] as String? ?? '',
      );
    }).toList();
  }


  Future<String?> getUserNameById(int userId) async {
    final result = await db.query('users', where: 'id = ?', whereArgs: [userId]);
    return result.isNotEmpty ? result.first['name'] as String? : null;
  }

  Future<String?> getUsersNameById(int userId) async {
    final result = await db.query('users', where: 'id = ? AND type = ?', whereArgs: [userId, 'admin']);
    return result.isNotEmpty ? result.first['name'] as String? : null;
  }
}

class AppointmentService {
  final Database db;
  AppointmentService(this.db);

  Future<void> insertAppointment(Appointment appointment) async {
    await db.insert('appointments', appointment.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Appointment>> getAppointments() async {
    final maps = await db.query('appointments');
    return List.generate(maps.length, (i) => Appointment.fromMap(maps[i]));
  }

  Future<List<Appointment>> getAppointmentsByUserId(int userId) async {
    final maps = await db.query('appointments', where: 'user_id = ?', whereArgs: [userId]);
    return maps.map((map) => Appointment.fromMap(map)).toList();
  }

  Future<void> deleteAppointment(int id) async {
    await db.delete('appointments', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateAppointment(Appointment appointment) async {
    await db.update('appointments', appointment.toMap(), where: 'id = ?', whereArgs: [appointment.id]);
  }

  Future<List<Appointment>> searchAppointments(String keyword) async {
    final maps = await db.query('appointments', where: 'name LIKE ?', whereArgs: ['%$keyword%']);
    return List.generate(maps.length, (i) => Appointment.fromMap(maps[i]));
  }
}

// main helper
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  final DatabaseInitializer _initializer = DatabaseInitializer([
    UserTableMigration(),
    AppointmentTableMigration(),
  ]);

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await _initializer.initialize(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // upgrade logic here if needed
        }
      },
    );
  }

  Future<UserService> getUserService() async {
    final db = await database;
    return UserService(db);
  }

  Future<AppointmentService> getAppointmentService() async {
    final db = await database;
    return AppointmentService(db);
  }
}
