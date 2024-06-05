import 'package:bitirme/view/edit_invoice_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});
  static late CameraDescription firstCamera;

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _flashToggle = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      InvoicePage.firstCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 229, 225),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.08,
            ),
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    height: screenHeight * 0.63, //620
                    width: screenWidth * 0.9,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(30), // Set border radius here
                      border: Border.all(
                        color: Color.fromARGB(255, 157, 203, 201),
                        width: 8,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CameraPreview(_controller), //burası sıkıntılı
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            SizedBox(
              height: screenHeight * 0.025,
            ),
            Stack(
              alignment: Alignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: screenWidth * 0.55),
                  child: Container(
                    alignment: Alignment.center,
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 49, 102, 101),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _flashToggle
                            ? Icons.flashlight_on_outlined
                            : Icons.flashlight_off_outlined,
                        size: 45,
                        color: _flashToggle
                            ? Colors.yellow
                            : Color.fromARGB(255, 157, 203, 201),
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
                    color: Color.fromARGB(255, 49, 102, 101),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      size: 80,
                      color: Color.fromARGB(255, 157, 203, 201),
                    ),
                    highlightColor: Color.fromARGB(255, 157, 203, 201),
                    onPressed: () async {
                      try {
                        await _initializeControllerFuture;
                        final image = await _controller.takePicture();
                        if (!context.mounted) return;
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditInvoicePage(
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
                  padding: EdgeInsets.only(left: screenWidth * 0.55),
                  child: Container(
                    alignment: Alignment.center,
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 49, 102, 101),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.photo_outlined,
                        size: 50,
                        color: Color.fromARGB(255, 157, 203, 201),
                      ),
                      highlightColor: Color.fromARGB(255, 157, 203, 201),
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

  Future<void> _toggleFlashlight() async {
    if (_controller.value.isInitialized) {
      if (_controller.value.flashMode == FlashMode.off) {
        await _controller.setFlashMode(FlashMode.torch);
        setState(() {
          _flashToggle = true;
        });
      } else {
        await _controller.setFlashMode(FlashMode.off);
        setState(() {
          _flashToggle = false;
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
          builder: (context) => EditInvoicePage(
            imagePath: returnedImage.path,
          ),
        ),
      );
    }
  }
}
