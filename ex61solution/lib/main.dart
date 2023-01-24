import 'dart:io';

import 'package:files_db/expense.dart';
import 'package:files_db/file_dao.dart';
import 'package:files_db/sqlite_dao.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Expense currentExpense;
  late Future<Directory> appSupportDir;
  late FileDao fileDao;
  final SqliteDao sqliteDao = SqliteDao(fileName: "ex61db");

  @override
  void initState() {
    debugPrint("initState");
    currentExpense = _genExpense();
    appSupportDir = getApplicationSupportDirectory();
    sqliteDao.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: [
        Container(
          height: 300,
          color: Colors.white30,
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            padding: const EdgeInsets.all(10),
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            children: [
              ElevatedButton(onPressed: _fileSave, child: const Text("File Save")),
              ElevatedButton(onPressed: _fileLoad, child: const Text("File Load")),
              ElevatedButton(onPressed: _dbSave, child: const Text("DB Save")),
              ElevatedButton(onPressed: _dbLoad, child: const Text("DB Load")),
              ElevatedButton(onPressed: _expReset, child: const Text("Reset")),
              ElevatedButton(onPressed: _expClear, child: const Text("Clear")),
            ],
          ),
        ),
        Container(
          height: 300,
          color: Colors.white30,
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            padding: const EdgeInsets.all(10),
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            children: [
              const Text("Date"), Text(currentExpense.date.toString()),
              const Text("Description"), Text(currentExpense.description),
              const Text("Location"), Text(currentExpense.location),
              const Text("Amount"), Text(currentExpense.amount.toString()),
            ],
          ),
        )
      ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'More',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Expense _genExpense() {
    return Expense(DateTime.now(), "Breakfast at Tiffany's",
        "Tiffany's Cafe", 123.45);
  }

  _fileSave() async {
    fileDao = FileDao(fileName: "${(await appSupportDir).path}/tempname");
    fileDao.saveExpense(currentExpense);
    setState(() {});
  }
  _fileLoad() async {
    fileDao = FileDao(fileName: "${(await appSupportDir).path}/tempname");
    currentExpense = await fileDao.loadExpense();
    setState(() {});
  }
  _dbSave() async {
    sqliteDao.open();
   currentExpense = await sqliteDao.saveExpense(currentExpense);
    setState(() {});
  }
  _dbLoad() async {
    sqliteDao.open();
    currentExpense = await sqliteDao.loadExpense(1);
    setState(() {});
  }
  _expReset() {
    setState(() => currentExpense = _genExpense());
  }
  _expClear() {
    setState(() => currentExpense = Expense(DateTime.now(), "", "", 0.0));
  }
}
