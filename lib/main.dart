import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marketing/src/bindings/bindings.dart';
import 'package:marketing/src/user/controller/sync_service.dart';
import 'package:marketing/src/user/models/rtlLocation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import './src/AppConfig.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as geo;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
@pragma('vm:entry-point')
void callbackDispatcher() async {
  SyncService syncService = SyncService();
  Workmanager().executeTask((task, inputData) async {
    return await syncService.sync();
  });
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

// ignore: slash_for_doc_comments
/**
 * =====================TESTING==========================
 *        Testing Background Service Using             ||
 *            flutter_background_service               ||
 * ======================================================
 * 
 * 
 * 
 * 
 */

Future sendLocation({required List<Map<String, dynamic>> data}) async {
  try {
    http.Response res = await http.post(
      Uri.parse('${AppConfig.host}/location-log/many'),
      body: data,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print(res.body);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

// Future<void> initService() async {
//   /**
//    * This function is used for initialize flutter_background_service
//    */

//   FlutterBackgroundService service = FlutterBackgroundService();
//   AndroidConfiguration androidConfiguration = AndroidConfiguration(
//     onStart: onStart,
//     isForegroundMode: true,
//     autoStartOnBoot: true,
//     autoStart: false,
//   );
//   await service.configure(
//     iosConfiguration: IosConfiguration(),
//     androidConfiguration: androidConfiguration,
//   );
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//   await Hive.initFlutter();
//   Hive.registerAdapter(RTLocationAdapter());
//   Box<RTLocation> location = await Hive.openBox<RTLocation>('rtLocations');
//   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   String userId = sharedPreferences.getString('userId') ?? '';
//   DateTime now = DateTime.now();
//   int exitTime =
//       DateTime(now.year, now.month, now.day, 21, 0, 0).millisecondsSinceEpoch;
//   bool alive = false;

//   Connectivity connectivity = Connectivity();
//   connectivity.onConnectivityChanged.listen((event) async {
//     if (event == ConnectivityResult.none) {
//       alive = false;
//       if (service is AndroidServiceInstance) {
//         await service.setForegroundNotificationInfo(
//           title: 'Marketing Background Service',
//           content: 'No Internet Connection',
//         );
//       }
//     } else {
//       alive = true;
//       if (service is AndroidServiceInstance) {
//         await service.setForegroundNotificationInfo(
//           title: 'Marketing Background Service',
//           content: 'Internet Connection Available',
//         );
//       }
//     }
//   });

//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((Map<String, dynamic>? event) {
//       service.setAsForegroundService();
//     });
//     service.on('setAsBackground').listen((Map<String, dynamic>? event) {
//       service.setAsBackgroundService();
//     });
//   }

//   service.on('stopService').listen((Map<String, dynamic>? event) {
//     service.stopSelf();
//   });

//   geo.Geolocator.getPositionStream(
//     locationSettings: const geo.LocationSettings(
//       accuracy: geo.LocationAccuracy.high,
//       distanceFilter: 1,
//     ),
//   ).listen((event) async {
//     print(event.speed);
//     if (service is AndroidServiceInstance) {
//       await service.setForegroundNotificationInfo(
//         title: 'Marketing Background Service',
//         content: 'Location Changed: ${event.latitude} ${event.longitude}',
//       );
//     }

//     if (exitTime < DateTime.now().millisecondsSinceEpoch) {
//       service.stopSelf();
//     } else {
//       if (event.speed >= 1) {
//         if (!alive) {
//           location.add(
//             RTLocation(
//               lat: event.latitude,
//               lng: event.longitude,
//               userId: userId,
//             ),
//           );
//         } else {
//           List<Map<String, dynamic>> localData =
//               location.values.map((e) => e.toMap()).toList();
//           if (localData.isNotEmpty) {
//             if (kDebugMode) {
//               print('Sending data from local storage');
//             }
//             await sendLocation(data: localData);
//             if (kDebugMode) {
//               print('data sended to server from local storeage');
//             }
//             await location.clear();
//           } else {
//             if (kDebugMode) {
//               print('Sending data from current location');
//             }
//             List<Map<String, dynamic>> data = [
//               {
//                 'lat': event.latitude,
//                 'lng': event.longitude,
//                 'userId': userId,
//                 'time': DateTime.now().millisecondsSinceEpoch.toString(),
//               }
//             ];
//             await sendLocation(data: data);
//           }
//         }
//       }
//     }
//     print('Location Changed: ${event.latitude} ${event.longitude}');
//   });
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  await AppConfig.register();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(MagadhApp());
}

class MagadhApp extends StatefulWidget {
  const MagadhApp({super.key});

  @override
  State<MagadhApp> createState() => _MagadhAppState();
}

class _MagadhAppState extends State<MagadhApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      initialBinding: InitialBindings(),
      debugShowCheckedModeBanner: false,
      enableLog: false,
      title: AppConfig.appName,
      theme: AppConfig.lightTheme,
      getPages: AppConfig.pages,
      initialRoute: AppConfig.SPLASH_ROUTE,
    );
  }
}
