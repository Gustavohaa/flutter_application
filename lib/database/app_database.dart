import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().withLength(min: 5, max: 100).customConstraint('UNIQUE')();
  TextColumn get password => text()();
}

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get status => integer().withDefault(Constant(0))();
  IntColumn get userId => integer().references(Users, #id)();
  DateTimeColumn get deadline => dateTime().nullable()();
}

@DriftDatabase(tables: [Users, Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Usuários
  Future<int> createUser(String email, String password) async {
    return await into(users).insert(
      UsersCompanion(
        email: Value(email),
        password: Value(password),
      ),
    );
  }

  Future<User?> login(String email, String password) async {
    return await (select(users)
          ..where((tbl) =>
              tbl.email.equals(email) & tbl.password.equals(password)))
        .getSingleOrNull();
  }

  // Tarefas
  Future<List<Task>> getTasks(int userId) async {
    return await (select(tasks)..where((tbl) => tbl.userId.equals(userId)))
        .get();
  }

  Future<int> addTask(String name, int userId, {DateTime? deadline}) async {
    return await into(tasks).insert(
      TasksCompanion(
        name: Value(name),
        userId: Value(userId),
        deadline: Value(deadline),
      ),
    );
  }

  Future<void> updateTaskStatus(int taskId, int newStatus) async {
    await (update(tasks)..where((tbl) => tbl.id.equals(taskId))).write(
      TasksCompanion(status: Value(newStatus)),
    );
  }

  Future<void> deleteTask(int taskId) async {
    await (delete(tasks)..where((tbl) => tbl.id.equals(taskId))).go();
  }

  Future<void> updateTaskName(int taskId, String newName) async {
    await (update(tasks)..where((tbl) => tbl.id.equals(taskId))).write(
      TasksCompanion(name: Value(newName)),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'db.sqlite');
    return NativeDatabase(File(dbPath));
  });
}
