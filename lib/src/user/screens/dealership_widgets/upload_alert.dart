import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/dealership_controller.dart';

class UploadAlert extends StatefulWidget {
  UploadAlert({
    super.key,
    required this.keyString,
    required this.dealerShipController,
  });
  String keyString;
  DealerShipController dealerShipController;

  @override
  State<UploadAlert> createState() => _UploadAlertState();
}

class _UploadAlertState extends State<UploadAlert> {
  bool document = false;
  String filePath = "N/A";
  TextEditingController textEditingController = TextEditingController();
  pickPdf() async {
    String path = await widget.dealerShipController.pickFile();
    setState(() {
      filePath = path;
    });
  }

  pickImageFromCamera() async {
    String path = await widget.dealerShipController
        .pickImageFile(imageSource: ImageSource.camera);
    setState(() {
      filePath = path;
    });
  }

  pickImageFromGallery() async {
    String path = await widget.dealerShipController
        .pickImageFile(imageSource: ImageSource.gallery);
    setState(() {
      filePath = path;
    });
  }

  clearImage() {
    setState(() {
      filePath = "N/A";
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              widget.keyString,
              style: GoogleFonts.poppins(
                color: AppConfig.primaryColor7,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.clear,
              color: AppConfig.primaryColor7,
            ),
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Upload Document type of ${widget.keyString}',
            style: GoogleFonts.firaSans(),
          ),
          Text(
            'In case if you don\'t have any document of this type, enable the checkbox below and enter reason for not having this document',
            style: GoogleFonts.firaSans(
              color: Colors.redAccent.withOpacity(0.7),
            ),
          ),
          filePath == "N/A"
              ? Switch(
                  value: document,
                  onChanged: (value) => setState(() {
                    document = value;
                  }),
                )
              : Flexible(
                  child: Text(
                    filePath,
                    style: GoogleFonts.firaSans(
                      color: Colors.green,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
          if (document)
            TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: 'Enter reason for not having this document',
                hintStyle: GoogleFonts.firaSans(
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
      actions: document
          ? [
              ElevatedButton.icon(
                onPressed: () {
                  widget.dealerShipController.pushDocs(
                    docs: Docs(
                      key: widget.keyString,
                      url: "N/A",
                      reason: textEditingController.text,
                      uploaded: false,
                      reason_status: true,
                    ),
                  );
                  Get.back();
                },
                icon: const Icon(Icons.check),
                label: const Text("Done"),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.clear),
                label: const Text("Back"),
              ),
            ]
          : filePath != "N/A"
              ? [
                  ElevatedButton.icon(
                    onPressed: () {
                      widget.dealerShipController.pushDocs(
                        docs: Docs(
                          key: widget.keyString,
                          url: filePath,
                          uploaded: false,
                          reason_status: false,
                        ),
                      );
                      Get.back();
                    },
                    icon: const Icon(Icons.check),
                    label: const Text("Done"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text("Cancle"),
                  ),
                ]
              : [
                  ElevatedButton.icon(
                    onPressed: () async {
                      await pickPdf();
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text("Upload PDF"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await pickImageFromGallery();
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("Upload IMG"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await pickImageFromCamera();
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Click Image"),
                  ),
                ],
    );
  }
}
