
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
  List<Expense>? expenses = [];

  void refresh() async {
    print("refresh");
    expenses = await RestDao.downloadAll();
    setState(()  {
      // nothing needed
    });
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: expenses!.length,
        prototypeItem: ListTile(
          title: Text("Expenses"),
        ),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text(expenses![index].date.toString().substring(0, 10)),
            title: Text(expenses![index].description),
            subtitle: Text(expenses![index].location),
            trailing: Text(expenses![index].amount.toString()),
          );
        },
      ),
       floatingActionButton: FloatingActionButton(onPressed: refresh,
           child: const Text("Update")
       ),
     );
  }
}
