
import 'dart:math';

import 'package:ex71solution/rest_dao.dart';
import 'package:flutter/material.dart';

import 'expense.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ex73Solution',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Ex71Solution Home Page'),
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
  List<Expense>? expenses = [];
  int n = 1;

  void _refresh() async {

    //T call RestDao.downloadAll() asynchronously, save result in expenses
    //-
    expenses = await RestDao.downloadAll();
    //+
    setState(() => {});
  }

  void _add() async {
    print("Add");
    Expense expense = Expense(DateTime.now(), "Item #${++n}", "Someplace", 123.45);
    RestDao.addExpense(expense);
    expenses!.add(expense);
    //T Call setState with a null handler, similar to in refresh()
    //T (Reminder: setState call is needed to make the widget rebuild)
    //-
    setState(() {});
    //+
  }

  @override
  Widget build(BuildContext context) {
    print("_MyHomePageState::build()");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(icon: const Icon(Icons.refresh),
              onPressed: () async => _refresh()),
       ],
      ),
      //T Note that we're using a ListView builder here instead of
      // a StreamBuilder, just to make this simpler.
      body: ListView.builder(
        itemCount: expenses!.length,
        // prototypeItem is an optional efficiency tweak
        prototypeItem: const ListTile(
          title: Text("Expenses"),
        ),
        itemBuilder: (context, index) {
          //T Create a ListTile for each Expense
          // Have each expense item in the list generate a ListTile
          // with date in the leading (use toString() and substring
          // to make it look nice), description for title,
          // location for subtitle, and amount for trailing
          //R return Text("Just here to make it compile").
          //-
          return ListTile(
            leading: Text(expenses![index].date.toString().substring(0, 10)),
            title: Text(expenses![index].description),
            subtitle: Text(expenses![index].location),
            trailing: Text(expenses![index].amount.toString()),
          );
          //+
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
    );
  }
}

