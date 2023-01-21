import 'package:flutter/material.dart';
import 'package:intl_translation/extract_messages.dart';
import 'package:intl_translation/generate_localized.dart';
import 'package:intl_translation/visitors/interpolation_visitor.dart';
import 'package:intl_translation/visitors/message_finding_visitor.dart';
import 'package:intl_translation/visitors/plural_gender_visitor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Internationalization Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const TableDemo(title: 'Flutter Internationalization'),
    );
  }
}

/// A variant of the TableDemo from FlowCase
class TableDemo extends StatefulWidget {

  const TableDemo({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TableDemoState();
  }
}

class _TableDemoState extends State<TableDemo> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          const Text("Basic Table"),
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
          const Text("Table with a bit of style"),
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
                children: const <TableRow>[
                  TableRow(
                      children: <Widget>[
                        Text("Date", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Item", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Amount", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Balance", style: TextStyle(fontWeight: FontWeight.bold)),
                      ]
                  ),
                  TableRow(
                      children: <Widget>[
                        Text("2023-02-15"),
                        Text("Deposit ATM#42"),
                        Text("123.00", textAlign: TextAlign.end),
                        Text("456.00", textAlign: TextAlign.end),
                      ]
                  ),
                  TableRow(
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
          const Text("DataTable"),
          Container(
              padding: const EdgeInsets.all(7),
              child: DataTable(
                border: TableBorder.all(),
                columns: const [
                  DataColumn(label:(Text('Date'))),
                  DataColumn(label:(Text('Item'))),
                  DataColumn(label:(Text('Amount'))),
                  DataColumn(label:(Text('Balance'))),
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
        ]
    );
  }
}


