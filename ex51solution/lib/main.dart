import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

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
  XFile? imageFile;
  CameraController? cameraController;
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
                    onPressed: () => _doTakePicture(),
                    child: const Text('Take Picture'),
                  ),
                ],
              ),
              imageFile == null ?
              const Text("No picture yet") :
              // Constrain the size so we don't overflow:
              Container(
                width: 200,
                height: 300,
                alignment: Alignment.center,
                child: Image.file(File(imageFile!.path)),
              ),
            ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => debugPrint("FAB pressed"),
          tooltip: 'Do nothing',
          child: const Icon(Icons.add),
        )
    );
  }

  void _doTakePicture() async  {
    debugPrint("in _doTakePicture()");
    late CameraDescription camera;
    var cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      camera = cameras.first;
    }

    cameraController =
        CameraController(camera, ResolutionPreset.medium);
    await cameraController!.initialize();
    if (!cameraController!.value.isInitialized) {
      debugPrint('Error: select a camera first.');
      return null;
    }

    if (cameraController!.value.isTakingPicture) {
      // Capture already in the works, give up
      return null;
    }

    late final XFile file;
    try {
      debugPrint("About to takePicture()");
      file = await cameraController!.takePicture();
      debugPrint("Image is in file $file");
    } on CameraException catch (e) {
      debugPrint("NO PICTURE Error: $e");
      return null;
    }
    if (mounted) {
      setState(() {
        debugPrint("Image is in file $file");
        imageFile = file;
      });
      debugPrint('Picture saved to ${file.path}');
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    cameraController!.dispose();
    super.dispose();
  }
}
