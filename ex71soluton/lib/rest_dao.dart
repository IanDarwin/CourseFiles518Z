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
	static final Uri urlAddOne = Uri.http("${host}:${port.toString()}", "/add-expense");

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
		//T If you need to, print(response) to see why we index by 'expense' here
		var ret = jsonDecode(response)['expense'];
		List<Expense> list = [];
		for (var x in ret) {
			var e = Expense.fromJson(x);
			list.add(e);
		}
		return list;
	}

	static Future<int> addExpense(expense) async {
		print("addExpense($expense)");
		print("url = $urlAddOne");
		//T Implement this method
		//-
		http.Response response = await http.post(urlAddOne,
			headers: {"Content-Type": "application/json", "Accept":"text/plain"},
				body: expense.toJson(),
				encoding: Encoding.getByName("utf-8"),

		);
		print("Body is ${response.body}");
		if (response.statusCode == 200) {
			var ret = int.parse(await response.body);
			print(ret);
			return ret;
		} else {
			print("ERROR: got response ${response.statusCode}");
			return 0;
		}
		//+
		//R return 0;
	}

	static Future<void> deleteExpense(int id) async {
		// Optional
		throw Exception("deleteExpense not implemented yet");
	}

}
