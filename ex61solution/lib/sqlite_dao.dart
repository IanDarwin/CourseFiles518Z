import 'package:sqflite/sqflite.dart';

import 'expense.dart';

class SqliteDao {

	String fileName;

	SqliteDao({this.fileName = "tempDB"});

		// The database when opened.
		late Database db;

		// Open the database.
		Future<void> open() async {
			print("LocalDbProvider.open($fileName)");
			db = await openDatabase(fileName,
				version: 1,
				onCreate: _onCreate,
				onUpgrade: (db, oldVer, newVer) => print("Upgrade neither needed nor supported yet"),
			);
		}

Future<void> _onCreate(Database database, int version) async {
	print("In onCreate; base = $database");
	await database.execute('''
create table expense ( 
  id integer primary key autoincrement, 
  date text not null,
  description text not null,
  location text not null,
  amount double not null);
''');
}

	Future<Expense> saveExpense(Expense expense) async {
		expense.id = await db.insert('expense', expense.toMap());
		return expense;
	}

	Future<Expense> loadExpense(int id) async {
    final List<Map> maps = await db.query('expense',
				where: 'id = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Expense.fromJson(maps.first);
    }
		throw Exception("ERROR: Lookup by pkey failed to find the entry!");
  }
}