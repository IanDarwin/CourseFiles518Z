import 'package:files_db/expense.dart';
import 'package:files_db/file_dao.dart';
import 'package:test/test.dart';

main() async {
	test("Write then read is idempotent", () async {
		Expense e = Expense(DateTime(2025, 05, 05), "Lunch", "William's", 24.95);
		FileDao(fileName: "tempFile").saveExpense(e);
		Expense e2 = await FileDao(fileName: 'tempFile').loadExpense();
		expect(e == e2, true);
	});
}
