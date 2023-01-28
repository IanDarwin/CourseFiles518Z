import 'dart:convert';

import 'expense.dart';
import 'package:http/http.dart' as http;

class RestDao {

	static const host =
			//"localhost";
	//T Change to the special host for emulator
	"10.0.2.2";
	static const port = 8100;
	// http NOT https for local testing
	static final Uri url = Uri.http("${host}:${port.toString()}", "/expenses");

	static Future<List<Expense>> uploadAll(List<Expense> expenses) async {

		var request = http.Request('GET', url);
		// request.body = dataObject.toMap(); // Either Map or JSON string
		// var response = await request.send();
		return [];
	}

	static Future<List<Expense>> downloadAll() async {
		print("downloadAll: url = $url");
		var request = await http.get(url);
		var response = await request.body;
		var ret = jsonDecode(response)['expense'];
		print(ret);
		List<Expense> list = [];
		for (var x in ret) {
			var e = Expense.fromJson(x);
			list.add(e);
		}
		return list;
	}

	static Future<int> addExpense(expense) async {
		//T Implement this method
		return 0;
	}

	static Future<void> deleteExpense(int id) async {
		// Optional
		throw Exception("deleteExpense not implemented yet");
	}

}
