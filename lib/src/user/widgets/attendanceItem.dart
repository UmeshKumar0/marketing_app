// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/home_controller.dart';
import 'package:marketing/src/user/models/odometers.dart';

class AttendanceItem extends StatelessWidget {
  AttendanceItem({
    super.key,
    required this.date,
    required this.homeController,
  });
  String date;
  HomeController homeController;

  Future<Odometers?> getOdometerDetails({
    required String date,
    required HomeController homeController,
  }) async {
    try {
      Odometers? odometer = await homeController.apiController.getOdometers(
        from: date,
        online: Get.find<CloudController>().alive.value,
      );
      if (odometer != null) {
        return odometer;
      } else {
        throw Exception('No Odometer Found');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getOdometerDetails(date: date, homeController: homeController),
      builder: (context, snapshot) {
        var odometers;

        if (snapshot.hasData) {
          odometers = snapshot.data as Odometers;
        }
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Attendance Details',
                      style: GoogleFonts.firaSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
              if (snapshot.hasError)
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    snapshot.error.toString(),
                    style: GoogleFonts.firaSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              else if (snapshot.hasData)
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (snapshot.connectionState == ConnectionState.done) ...[
                  ListTile(
                    leading: Icon(
                      Icons.track_changes_outlined,
                      color: AppConfig.primaryColor7,
                    ),
                    title: Text(
                      '${odometers.endReading == null ? odometers.startReading : (odometers.endReading! - odometers.startReading!)} KM',
                      style: GoogleFonts.firaSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Start Reading Image',
                                style: GoogleFonts.firaSans(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                              content: SizedBox(
                                height: 300,
                                width: 300,
                                child: Image.network(
                                  '${AppConfig.SERVER_IP}/${odometers.startReadingImage}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '404 Image not found',
                                        style: GoogleFonts.firaSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          });
                    },
                    leading: Icon(
                      Icons.speed,
                      color: AppConfig.primaryColor7,
                    ),
                    title: Text(
                      'Start Reading: ${odometers.startReading}',
                      style: GoogleFonts.firaSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'tap here to view image',
                      style: GoogleFonts.firaSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Colors.blue.withOpacity(0.7),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Start End Image',
                                style: GoogleFonts.firaSans(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                              content: SizedBox(
                                height: 300,
                                width: 300,
                                child: Image.network(
                                  '${AppConfig.SERVER_IP}/${odometers.endReadingImage}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '404 Image not found',
                                        style: GoogleFonts.firaSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          });
                    },
                    leading: Icon(
                      Icons.speed,
                      color: AppConfig.primaryColor7,
                    ),
                    title: Text(
                      'End Reading: ${odometers.endReading ?? '----'}',
                      style: GoogleFonts.firaSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'tap here to view image',
                      style: GoogleFonts.firaSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Colors.blue.withOpacity(0.7),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.attach_money,
                      color: AppConfig.primaryColor7,
                    ),
                    title: Text(
                      'Odometer Status',
                      style: GoogleFonts.firaSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      odometers.endReading == null
                          ? 'Odometer is not yet closed'
                          : 'Odometer is closed',
                    ),
                  ),
                  odometers.endReading != null
                      ? ListTile(
                          leading:
                              Icon(Icons.speed, color: AppConfig.primaryColor7),
                          title: Text(
                            'Odometer Reading',
                            style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            (odometers.endReading! - odometers.startReading!)
                                .toString(),
                            style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : Container(),
                ] else
                  Container()
              else ...[
                Container(
                  alignment: Alignment.center,
                  child: Text('Data not found', style: GoogleFonts.roboto()),
                )
              ]
            ],
          ),
        );
      },
    );
  }
}
