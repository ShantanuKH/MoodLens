import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tflite/tflite.dart';

import 'main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Defining camera image, Means the frame that will be recorded by the camera (Users)
  CameraImage? cameraImage;

  // To control the camera
  CameraController? cameracontroller;

  // This will store/hold the output or say prediction
  String output = '';

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadmodel();
  }

  loadCamera() {
    // This cameras will be the list of cameras that we define in the main.dart
    cameracontroller = CameraController(cameras![0], ResolutionPreset.medium);
    cameracontroller!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          // Here we will get the image
          cameracontroller!
              .startImageStream((imageStream) => {cameraImage = imageStream});
          // Here we are calling our function to run the modle
          runModel();
        });
      }
    });
  }

  // Now we will run our model that we created with the help of Teachable Machine
  runModel() async {
    if (cameraImage != null) {
      // Tflite.runModelOnFrame(bytesList: bytesList) -> this will run the model on the frame
      var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) {
            return plane
                .bytes; // This function will return the butes form of the plane
          }).toList(),

          // this we are checking that from every angle and side the image should be taken
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 0,
          // How manu results we want to take and from them pick the best one
          numResults: 2,
          threshold: 0.1,
          asynch:
              true); // We will get the list of planes and so we are taking/mapping it to .toList

      // This will iterate through all the predictions and will set the output to the element to the label, This label will get the final label through the labels.text which is in assets and which we took from teachable machine
      predictions!.forEach((element) {
        setState(() {
          output = element['label'];
        });
      });
    }
  }

  loadmodel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Emotion Detection App"),
      ),
      body: Column(
        children: [
         Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: !cameracontroller!.value.isInitialized
                  ? Container()
                  : AspectRatio(
                      aspectRatio: cameracontroller!.value.aspectRatio,
                      child: CameraPreview(cameracontroller!),
                    ),
            ),
          ),

          Text(
            output,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
