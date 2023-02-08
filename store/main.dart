import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:store/settings_page.dart';
import 'calendar_demo.dart';

String? chosenColor;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Settings.init();
  chosenColor = Settings.getValue<String>('key-theme-color', defaultValue: 'Colors.green');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialColor? themeColor;
    if (chosenColor == null) {
      themeColor = Colors.blue;
    } else {
      // This is a kluge: better to store the int, and use Color(intVal)
      themeColor = nameToMaterialColor(chosenColor!);
    }
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: themeColor!,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

  MaterialColor? nameToMaterialColor(String s) {
    switch(s) {
      case 'orange': return Colors.orange;
      case 'green': return Colors.green;
      case 'blue': return Colors.blue;
      default: return Colors.red;
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void showSettings() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => (const SettingsPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showSettings,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
