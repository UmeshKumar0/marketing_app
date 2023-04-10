import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/models/dealership_form/pdf_args.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PDFArgs pdf = ModalRoute.of(context)!.settings.arguments as PDFArgs;
    print('${AppConfig.SERVER_IP}${pdf.link}');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          pdf.link,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: pdf.cloud
          ? pdf.link.split('.').last != 'pdf'
              ? Image.network('${AppConfig.SERVER_IP}${pdf.link}')
              : SfPdfViewer.network('${AppConfig.SERVER_IP}${pdf.link}')
          : SfPdfViewer.file(
              File(pdf.link),
            ),
    );
  }
}
