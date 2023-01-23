import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AnotherDemoApp());
}

class AnotherDemoApp extends StatelessWidget {
  const AnotherDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DemoHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key, required this.title});

  final String title;

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {

  @override
  Widget build(BuildContext context) {
    debugPrint("In _DemoHomePageState.build()");
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => debugPrint("Help Button pressed"),
                    child: const Text('Help button'),
                  ),
                  //const Spacer(flex: 30),
                  ElevatedButton(
                    onPressed: () => debugPrint("Camera Button pressed"),
                    child: const Text('Take Picture'),
                  ),
                ],
              ),
              // XXX Need Image here
            ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => debugPrint("FAB pressed"),
          tooltip: 'Do nothing',
          child: const Icon(Icons.add),
        )
    );
  }
}
