import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class LeaderInvoice extends StatefulWidget {
  const LeaderInvoice({super.key});
  static late CameraDescription firstCamera;

  @override
  State<LeaderInvoice> createState() => _LeaderInvoiceState();
}

class _LeaderInvoiceState extends State<LeaderInvoice> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late File _selectedImage;
  bool toggle = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      LeaderInvoice.firstCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  Future<void> _toggleFlashlight() async {
    if (_controller.value.isInitialized) {
      if (_controller.value.flashMode == FlashMode.off) {
        await _controller.setFlashMode(FlashMode.torch);
        setState(() {
          toggle = true;
        });
      } else {
        await _controller.setFlashMode(FlashMode.off);
        setState(() {
          toggle = false;
        });
      }
    }
  }

  Future<void> _selectImageFromLibrary() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: returnedImage.path,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    height: 520, //620
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(30), // Set border radius here
                      border: Border.all(
                        color: Colors.black,
                        width: 8,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CameraPreview(_controller),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            SizedBox(
              height: 25,
            ),
            Stack(
              alignment: Alignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 250),
                  child: Container(
                    alignment: Alignment.center,
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      icon: Icon(
                        toggle
                            ? Icons.flashlight_on_outlined
                            : Icons.flashlight_off_outlined,
                        size: 45,
                        color: toggle ? Colors.yellow : Colors.white,
                      ),
                      highlightColor: Colors.yellow,
                      onPressed: _toggleFlashlight,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      size: 80,
                      color: Colors.white,
                    ),
                    highlightColor: Colors.white,
                    onPressed: () async {
                      try {
                        await _initializeControllerFuture;
                        final image = await _controller.takePicture();
                        if (!context.mounted) return;
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DisplayPictureScreen(
                              imagePath: image.path,
                            ),
                          ),
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 250),
                  child: Container(
                    alignment: Alignment.center,
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.photo_outlined,
                        size: 50,
                        color: Colors.white,
                      ),
                      highlightColor: Colors.white,
                      onPressed: _selectImageFromLibrary,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}
