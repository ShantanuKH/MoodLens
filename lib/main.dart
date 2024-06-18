import 'package:camera/camera.dart';
import 'package:emotiondectector/home.dart';
import 'package:flutter/material.dart';

List<CameraDescription>? cameras;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
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
