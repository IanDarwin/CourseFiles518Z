import 'dart:convert';
import 'dart:io';

import 'expense.dart';

class FileDao {

	String fileName;

	FileDao({this.fileName = "tempFile"});

	void saveExpense(Expense e) async {
		String toSave = jsonEncode(e.toJson());
		print("To save to $fileName: $toSave");
		await File(fileName).writeAsString(toSave);
	}

	Future<Expense> loadExpense() async {
		String readBack = await File(fileName).readAsString();
		Map<String,dynamic> map = jsonDecode(readBack);
		print("Map loaded: $map");
		return Expense.fromJson(map);
	}
}
