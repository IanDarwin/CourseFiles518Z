import 'package:files_db/expense.dart';
import 'package:files_db/sqlite_dao.dart';
import 'package:test/test.dart';

main() async {
	test("Write then read is idempotent", () async {
		Expense e = Expense(DateTime(2025, 05, 05), "Lunch", "William's", 24.95);
		SqliteDao(fileName: "tempFile").saveExpense(e);
		final dao = SqliteDao(fileName: 'tempFile');
		await dao.open();
		Expense e2 = await dao.loadExpense(1);
		expect(e == e2, true);
	});
}
