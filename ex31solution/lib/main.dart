import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ex31solution',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Ex31solution'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        //T Create your UI as the "body:" attribute here (replacing this Text)
        //R body: Text("Write me!"),
        //-
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                width: 300,
                height: 300,
                child: FlutterLogo(),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text("One"),
                      onPressed: () => debugPrint("One"),
                    ),
                    ElevatedButton(
                      child: const Text("Two"),
                      onPressed: () => debugPrint("Two"),
                    ),
                  ]),
              ElevatedButton(
                child: const Text("Three"),
                onPressed: () => debugPrint("Three"),
              ),

            ]
        ),
	//+
        floatingActionButton: FloatingActionButton(
          onPressed: () => debugPrint("Add"),
          tooltip: 'Add',
          child: const Icon(Icons.add),
        )
    );
  }
}
