import 'package:camera/camera.dart';
import 'package:emotiondectector/home.dart';
import 'package:flutter/material.dart';

List<CameraDescription>? cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras =
      await availableCameras(); // In this step we will ensure that all the available cameras are initialize to this list or assign to this list
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
