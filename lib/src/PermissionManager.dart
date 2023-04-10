import 'package:flutter/services.dart';
import 'package:marketing/src/user/models/Sim.dart';

class PermissionManager {
  static MethodChannel channel =
      const MethodChannel('com.magadh.marketing/sim');

  Future<bool> checkPermission(String permission) async {
    if (PermissionTypes.PERMISSIONS.contains(permission)) {
      return await channel.invokeMethod('checkpermissionstatus', {
        "type": permission,
      });
    } else {
      throw Exception('Permission not found');
    }
  }

  Future requestPermission(String permission) async {
    if (PermissionTypes.PERMISSIONS.contains(permission)) {
      return await channel.invokeMethod('requestPermission', {
        "type": permission,
      });
    } else {
      throw Exception('Permission not found');
    }
  }

  Future<int> getBatteryLevel() async {
    final int result = await channel.invokeMethod('getBatteryLevel');
    return result;
  }

  Future<List<Sim>> getSimNumbers() async {
    String? result = await channel.invokeMethod('getSimNumbers');

    List<Sim> sims = [];
    if (result != null) {
      List simNumbers = result.split("@@");

      if (simNumbers.contains("")) {
        simNumbers.removeAt(0);
      }

      for (var element in simNumbers) {
        List simData = element.split("-");
        Sim sim = Sim(
          slot: int.parse(simData[0]),
          carrierName: simData[1],
          number: simData[2],
          subsId: int.parse(simData[3]),
        );

        sims.add(sim);
      }
      return sims;
    } else {
      return sims;
    }
  }

  Future sendSms(String number, String message, int slot) async {
    return await channel.invokeMethod('sendSms', {
      "phone": number,
      "message": message,
      "slot": slot,
    });
  }

  Future startLocationService() async {
    return await channel.invokeMethod('startLocationService');
  }

  Future stopLocationService() async {
    return await channel.invokeMethod('stopLocationService');
  }
}

class PermissionTypes {
  static String CAMERA = 'camera';
  static String BACKGROUND_LOCATION = 'backgroundLocation';
  static String LOCATION = 'location';
  static String STORAGE = 'storage';
  static String MIC = 'mic';
  static String PHONE_STATE = 'phoneState';
  static String PHONE_NUMBER = 'phoneNumber';
  static String SMS = 'sms';

  static List<String> PERMISSIONS = [
    CAMERA,
    BACKGROUND_LOCATION,
    LOCATION,
    STORAGE,
    MIC,
    PHONE_STATE,
    PHONE_NUMBER,
    SMS
  ];
}



/* 

===============================
I/System.out(22123): 0
I/System.out(22123): 3
I/System.out(22123): Jio 4G
I/System.out(22123): 4
I/System.out(22123): android.graphics.Bitmap@4a1e891
I/System.out(22123): ===============================
I/System.out(22123): 1
I/System.out(22123): 0
I/System.out(22123): Jio 4G
I/System.out(22123): 4
I/System.out(22123): android.graphics.Bitmap@ef263f6



*/