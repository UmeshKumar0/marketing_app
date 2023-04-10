// ignore_for_file: unused_catch_clause

import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/api_controller.dart';
import 'package:marketing/src/user/controller/cloud_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/models/index.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:marketing/src/user/widgets/map_shopItem.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsController extends GetxController {
  // Variables ......................
  late StorageController _storageController;
  late CloudController _cloudController;
  RxDouble speed = 0.00.obs;

  Rx<CameraPosition> cameraPosition = const CameraPosition(
    target: LatLng(
      25.593819,
      85.160530,
    ),
    zoom: 16,
  ).obs;
  RxString mapState = AppConfig.LOADING_STATE.obs;
  Rx<String> originAdress = "".obs;
  late GoogleMapController googleMapController;
  String errorMessage = '';
  RxMap<MarkerId, Marker> markers = {
    const MarkerId("mymark"): const Marker(
      markerId: MarkerId("mymark"),
      position: LatLng(25.593819, 85.160530),
    )
  }.obs;
  RxList<LatLng> points = <LatLng>[].obs;

  RxMap<PolylineId, Polyline> polylines = {
    const PolylineId("myline"): const Polyline(
      polylineId: PolylineId("myline"),
      points: [
        LatLng(25.593819, 85.160530),
        LatLng(25.593819, 85.160530),
      ],
    )
  }.obs;

  Rx<LatLong> origin = LatLong(
    longitude: 85.160530,
    latitude: 25.593819,
  ).obs;
  Rx<LatLong> oldOrigin = LatLong(
    longitude: 28.49598954830213,
    latitude: 77.08895210110825,
  ).obs;

  RxBool permissionStatus = false.obs;
  late ApiController _apiController;
  late Timer _timer;
  // Variables--------------------------
  ApiController get apiController => _apiController;
  MapsController() {
    _apiController = Get.find<ApiController>();
    _storageController = Get.find<StorageController>();
    _cloudController = Get.find<CloudController>();
    _storageController.getNearByOfflineShops(
      origin: origin.value,
      radius: 2000,
    );
    syncShopsInPrediocally();
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel();
    googleMapController.dispose();
    _apiController.dispose();
    _cloudController.dispose();
    _storageController.dispose();
  }

  void init() async {
    PermissionStatus location = await Permission.location.status;
    if (location.isDenied) {
      try {
        await Permission.location.request();
        init();
      } catch (e) {
        errorMessage = e.toString();
        mapState.value = AppConfig.ERROR_STATE;
      }
    } else {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      origin.value = LatLong(
        longitude: position.longitude,
        latitude: position.latitude,
      );

      oldOrigin.value = LatLong(
        longitude: position.longitude,
        latitude: position.latitude,
      );

      try {
        await getShops();

        mapState.value = AppConfig.IDEAL_STATE;
      } on HttpException catch (e) {
        mapState.value = AppConfig.ERROR_STATE;
        errorMessage = e.message;
      } catch (e) {
        mapState.value = AppConfig.ERROR_STATE;
        errorMessage = e.toString();
      }
    }
  }

  void registerLocationListner(
    GoogleMapController cntlr,
    BuildContext context,
  ) async {
    googleMapController = cntlr;
    Geolocator.getPositionStream().listen((event) async {
      setOrigin(
        latLong: LatLong(
          longitude: event.longitude,
          latitude: event.latitude,
        ),
      );
      if (event.speed >= 0.7) {
        points.add(
          LatLng(
            event.latitude,
            event.longitude,
          ),
        );
        polylines.value = {
          const PolylineId("myline"): Polyline(
            color: Colors.pink,
            polylineId: const PolylineId("myline"),
            points: points,
          )
        };
        polylines.refresh();
      }

      _storageController.setLatLong(
          latlong: "${event.latitude},${event.longitude}");
      speed.value = event.speedAccuracy;
      final distance = Geolocator.distanceBetween(
        event.latitude,
        event.longitude,
        oldOrigin.value.latitude,
        oldOrigin.value.longitude,
      );
      if (distance > 200) {
        try {
          await getShops();

          mapState.value = AppConfig.IDEAL_STATE;
        } on HttpException catch (e) {
          mapState.value = AppConfig.ERROR_STATE;
          errorMessage = e.message;
        } catch (e) {
          mapState.value = AppConfig.ERROR_STATE;
          errorMessage = e.toString();
        }
      }
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              event.latitude,
              event.longitude,
            ),
            zoom: cameraPosition.value.zoom,
          ),
        ),
      );
    });
    mapState.value = AppConfig.IDEAL_STATE;
  }

  setCameraPosition({required CameraPosition cameraPosition}) {
    this.cameraPosition.value = cameraPosition;
  }

  void loadFullAdress() async {
    try {
      originAdress.value =
          (await _storageController.getAddress(latLong: origin.value))!;
    } on HttpException catch (e) {
      originAdress.value = 'NOT FOUND';
    } catch (e) {
      originAdress.value = 'NOT FOUND';
    }
  }

  void setOrigin({required LatLong latLong}) {
    origin.value = LatLong(
      longitude: latLong.longitude,
      latitude: latLong.latitude,
    );
  }

  syncShopsInPrediocally() async {
    try {
      _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        getShops();
      });
    } on HttpException catch (e) {
      mapState.value = AppConfig.ERROR_STATE;
      errorMessage = e.message;
    } catch (e) {
      mapState.value = AppConfig.ERROR_STATE;
      errorMessage = e.toString();
    }
  }

  getShops() async {
    oldOrigin.value = origin.value;
    loadFullAdress();
    try {
      List<Shops> shopsA = _cloudController.alive.value == true
          ? await _apiController.getShopsByKm(
              distance: 2000,
              online: true,
            )
          : await _storageController.getNearByOfflineShops(
              origin: origin.value, radius: 2000);
      List<Shops> shops2 = _cloudController.alive.value == true
          ? await _apiController.getPersonalShops()
          : _storageController.personalShopBox.values.toList();

      shopsA.addAll(shops2);

      Map<MarkerId, Marker> markers = {};
      Uint8List bytes = await getBytesFromAsset("assets/createShop.png", 90);
      final BitmapDescriptor icon = BitmapDescriptor.fromBytes(bytes);

      if (shopsA.isNotEmpty) {
        for (var element in shopsA) {
          markers[MarkerId(element.sId as String)] = Marker(
            markerId: MarkerId(element.sId as String),
            position: LatLng(element.location!.coordinates![1],
                element.location!.coordinates![0]),
            icon: icon,
            onTap: () {
              Get.bottomSheet(
                MapShopItem(
                  shops: element,
                  storageController: _storageController,
                ),
              );
            },
          );
        }
        this.markers.clear();
        this.markers.value = markers;
      }
    } catch (e) {
      if (e.toString() == "TOKEN_EXPIRE") {
        if (_timer.isActive) {
          _timer.cancel();
        }
      }
      rethrow;
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
