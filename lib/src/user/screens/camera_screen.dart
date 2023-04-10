import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:marketing/src/AppConfig.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription> cameras = [];
  late CameraController cameraController;

  bool cameraLoading = false;
  bool cameraError = false;
  String errorMessage = '';
  int cameraIndex = 0;
  bool flash = false;

  String imagePath = "N/A";

  @override
  void initState() {
    super.initState();
    init(index: 0);
  }

  init({required int index}) {
    setState(() {
      cameraIndex = index;
      cameraLoading = true;
    });
    availableCameras().then((value) {
      cameras = value;
      cameraController = CameraController(
        cameras[index],
        ResolutionPreset.medium,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          cameraLoading = false;
        });
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              errorMessage = 'Camera access denied';
              print('User denied camera access.');
              break;
            default:
              errorMessage = 'Unknown camera error';
              print('Handle other errors.');
              break;
          }
          setState(() {
            cameraLoading = false;
            cameraError = true;
          });
        }
      });
    });
  }

  changeCameraIndex() {
    init(index: cameraIndex == 0 ? 1 : 0);
  }

  changeFlashMode() {
    setState(() {
      flash = !flash;
    });
    if (flash) {
      cameraController.setFlashMode(FlashMode.torch);
    } else {
      cameraController.setFlashMode(FlashMode.off);
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  clickImage() async {
    try {
      final image = await cameraController.takePicture();
      setState(() {
        imagePath = image.path;
      });
    } catch (e) {
      print(e);
    }
  }

  clearImage() {
    setState(() {
      imagePath = "N/A";
    });
  }

  selectImage() {
    Navigator.pop(context, imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cameraLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : cameraError
              ? Center(
                  child: Text(errorMessage),
                )
              : imagePath != "N/A"
                  ? Stack(
                      children: [
                        ClipRRect(
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: IconButton(
                                      onPressed: clearImage,
                                      icon: Icon(
                                        Icons.close,
                                        color: AppConfig.primaryColor5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: IconButton(
                                      onPressed: selectImage,
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : InkWell(
                      onDoubleTap: changeCameraIndex,
                      child: AspectRatio(
                        aspectRatio: MediaQuery.of(context).size.aspectRatio,
                        child: CameraPreview(
                          cameraController,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      'assets/logo.png',
                                      height: 50,
                                    ),
                                    IconButton(
                                      onPressed: changeFlashMode,
                                      icon: Icon(
                                        flash
                                            ? Icons.flash_on
                                            : Icons.flash_off,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context, 'N/A');
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: clickImage,
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: changeCameraIndex,
                                      icon: const Icon(
                                        Icons.sync,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
    );
  }
}
