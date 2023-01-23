import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String title = 'Fluttter Internationalization Demo';
    return MaterialApp(
      title: title,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: TableDemo(title: title),
    );
  }
}

/// A variant of the TableDemo from FlowCase
class TableDemo extends StatefulWidget {
  final String title;

  const TableDemo({required this.title, super.key});

  @override
  State<StatefulWidget> createState() {
    return _TableDemoState();
  }
}

class _TableDemoState extends State<TableDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
        body: ListView(
        children: [
          const Text('Basic Table'),
          Container(
            height: 200,
            padding: const EdgeInsets.all(7),
            child:Table(
                border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  0: FixedColumnWidth(128),
                  1: FlexColumnWidth(),
                  2: FixedColumnWidth(128),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Container(
                          height: 64,
                          width: 64,
                          color: Colors.red,
                        ),
                      ),
                      Container(
                        height: 32,
                        width: 64,
                        color: Colors.green,
                      ),
                      Container(
                        height: 64,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  const TableRow(children: [
                    SizedBox(height: 64, child: Text("R2C1")),
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Center(child: Text("R2C2"))),
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.bottom,
                        child: Text("R2C3", textAlign: TextAlign.end)),
                  ])
                ]
            ),
          ),

          // SECOND TABLE
          Text(S.of(context).tableTitle),
          Container(
            padding: const EdgeInsets.all(7),
            child: Table(
                border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  0: FixedColumnWidth(80),
                  1: FlexColumnWidth(),
                  2: FixedColumnWidth(80),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                      children: <Widget>[
                        Text(S.of(context).date, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(S.of(context).item, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(S.of(context).amount, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(S.of(context).balance, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ]
                  ),
                  const TableRow(
                      children: <Widget>[
                        Text("2023-02-15"),
                        Text("Deposit ATM#42"),
                        Text("123.00", textAlign: TextAlign.end),
                        Text("456.00", textAlign: TextAlign.end),
                      ]
                  ),
                  const TableRow(
                      children: <Widget>[
                        Text("2023-02-20"),
                        Text("Withdrawal ATM#42"),
                        Text("15.00", textAlign: TextAlign.end),
                        Text("441.00", textAlign: TextAlign.end),
                      ]
                  ),
                ]
            ),
          ),

          // THIRD TABLE
          Text(S.of(context).dataTable),
          Container(
              padding: const EdgeInsets.all(7),
              child: DataTable(
                border: TableBorder.all(),
                columns: [
                  DataColumn(label:(Text(S.of(context).date))),
                  DataColumn(label:(Text(S.of(context).item))),
                  DataColumn(label:(Text(S.of(context).amount))),
                  DataColumn(label:(Text(S.of(context).balance))),
                ],
                rows: const [
                  DataRow(cells: [DataCell(Text('2022-02-15')),
                    DataCell(Text('Deposit ATM#42')),
                    DataCell(Text("123.00")),
                    DataCell(Text("456.00"))
                  ],
                  )
                ],
              )
          )
        ],
                )
    );
  }
}


