// ignore_for_file: must_be_immutable

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marketing/src/user/controller/maps_controller.dart';
import 'package:marketing/src/user/controller/visit_controller.dart';
import 'package:marketing/src/user/service/lcn_service.dart';
import 'package:marketing/src/user/widgets/connection_status.dart';
import 'package:marketing/src/user/widgets/sync_status.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
    required this.mapsController,
  }) : super(key: key);
  MapsController mapsController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VisitController visitController;

  @override
  void initState() {
    super.initState();
    visitController = Get.find<VisitController>();
    LocalNotificationService.initialize(context);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('onMessage: ${message.data}');
      if (!kIsWeb) {
        LocalNotificationService.display(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('onMessageOpenedApp: ${message.data}');
      if (!kIsWeb) {
        LocalNotificationService.display(message);
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? value) {
      if (value != null) {
        Get.toNamed(value.data['payload']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          const ConnectionStatus(),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/location.png",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Flexible(
                                child: Text(
                                  widget.mapsController.originAdress.value,
                                  style: GoogleFonts.firaSans(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.blue.withOpacity(0.6),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SyncStatus(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              markers: Set<Marker>.of(widget.mapsController.markers.values),
              polylines:
              Set<Polyline>.of(widget.mapsController.polylines.values),
              initialCameraPosition: widget.mapsController.cameraPosition.value,
              mapType: MapType.terrain,
              onMapCreated: (cont) {
                widget.mapsController.registerLocationListner(
                  cont,
                  context,
                );
              },
              myLocationEnabled: true,
              onCameraMove: (position) {
                widget.mapsController
                    .setCameraPosition(cameraPosition: position);
              },
            ),
          ),
          Container(
            color: Colors.transparent,
            height: 70,
          )
        ],
      );
    });
  }
}
