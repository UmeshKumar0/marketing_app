import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/dealership_controller.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/maps_controller.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:marketing/src/user/models/LatLon.dart';
import 'package:marketing/src/user/models/attendanceData.dart';
import 'package:marketing/src/user/models/cp_shop.dart';
import 'package:marketing/src/user/models/create_reminder.dart';
import 'package:marketing/src/user/models/create_visit.dart';
import 'package:marketing/src/user/models/dealership_form/dealership_from.dart';
import 'package:marketing/src/user/models/dealership_form/tempgstdetails.dart';
import 'package:marketing/src/user/models/deviceInfo.dart';
import 'package:marketing/src/user/models/image_model.dart';
import 'package:marketing/src/user/models/leave_create_model.dart';
import 'package:marketing/src/user/models/leave_model.dart';
import 'package:marketing/src/user/models/meetings/created_meetings.dart';
import 'package:marketing/src/user/models/meetings/meeting_model.dart';
import 'package:marketing/src/user/models/meetings/meeting_user.dart';
import 'package:marketing/src/user/models/mymeeting_model.dart';
import 'package:marketing/src/user/models/odometers.dart';
import 'package:marketing/src/user/models/reminder_model.dart';
import 'package:marketing/src/user/models/shopCreate.dart';
import 'package:marketing/src/user/models/shop_image.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:marketing/src/user/models/teams_model.dart';
import 'package:marketing/src/user/models/ticket_model.dart';
import 'package:marketing/src/user/models/types.dart';
import 'package:marketing/src/user/models/user_model.dart';
import 'package:marketing/src/user/models/user_notification.dart';
import 'package:marketing/src/user/models/visit_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

class ApiController extends GetxController {
  late StorageController _storageController;
  ApiController() {
    _storageController = Get.find<StorageController>();
  }

  StorageController get storageController => _storageController;
  loadAllShop() async {
    try {
      String lastTime = await _storageController.getLastTimeStamp();
      final url = Uri.parse(lastTime == '0'
          ? '${AppConfig.host}/shops/shop-offline'
          : '${AppConfig.host}/shops/shop-offline?timestamp=$lastTime');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_storageController.userModel.value.token}',
      });
      if (response.statusCode != 200) {
        throw HttpException('Error in loading shops');
      } else {
        final responseData = await json.decode(response.body)['data'];
        if (json.decode(response.body)['count'] <
            _storageController.shopBox.length) {
          _storageController.shopBox.clear();
          await _storageController.setLastTimeStamp(value: '0');
          loadAllShop();
        } else {
          for (var shop in responseData) {
            Shops shops = Shops.fromJson(shop);
            await _storageController.setShopsInDB(shops: shops);
          }
        }
        DateTime timeStamp = DateTime.now();
        await _storageController.setLastTimeStamp(
          value: timeStamp.millisecondsSinceEpoch.toString(),
        );
      }
    } catch (e) {
      await apiCrashLogs(
        user: _storageController.userModel.value.user!.sId.toString(),
        date: DateTime.now().toLocal().toString(),
        action: "loadAllShops",
        description: "This api used for sync all shops in local from server",
        error: e.toString(),
      );
      rethrow;
    }
  }

  apiCrashLogs({
    required String user,
    required String date,
    required String action,
    required String description,
    required String error,
  }) async {
    try {
      await http.post(
        Uri.parse('${AppConfig.SERVER_IP}/api/logs'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'user': user,
          'date': date,
          'action': action,
          'description': description,
          'error': error,
        }),
      );
      return;
    } catch (e) {
      return;
    }
  }

  Future<bool> checkNumber({required String number}) async {
    try {
      final url = Uri.parse('${AppConfig.host}/users/check/$number'.toString());
      http.Response response = await http.get(url);
      if (response.statusCode == 404) {
        return true;
      } else if (response.statusCode != 200 && response.statusCode != 404) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        return false;
      }
    } catch (e) {
      await apiCrashLogs(
        user: _storageController.userModel.value.user!.sId.toString(),
        date: DateTime.now().toLocal().toString(),
        action: "checkNumber",
        description: "This api used for check that number is registerd or not",
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> login({required String phone}) async {
    try {
      final url = Uri.parse('${AppConfig.host}/users/login');

      http.Response response = await http.post(url, body: {
        "phone": phone,
      });

      if (response.statusCode != 200) {
        await apiCrashLogs(
          user: "Not Found",
          date: DateTime.now().toLocal().toString(),
          action: "login",
          description: "This api used for login user",
          error: json.decode(response.body)['message'],
        );
        throw HttpException(json.decode(response.body)['message']);
      } else {
        return true;
      }
    } catch (e) {
      await apiCrashLogs(
        user: _storageController.userModel.value.user!.sId.toString(),
        date: DateTime.now().toLocal().toString(),
        action: "login",
        description: "This api used for login user",
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<UserModel> verify({
    required String phone,
    required String otp,
  }) async {
    try {
      MyDeviceInfo myDeviceInfo =
          await _storageController.getDeviceInfo(userId: "N/A", token: "N/A");

      final url = Uri.parse('${AppConfig.host}/users/login/verify');
      Permission locationPermission = Permission.location;
      Permission cameraPermission = Permission.camera;
      Permission location = Permission.locationAlways;

      List data = [
        {"key": "CAMERA", "value": await cameraPermission.isGranted},
        {"key": "LOCATION", "value": await locationPermission.isGranted},
        {"key": "LOCATION_ALWAYS", "value": await location.isGranted},
      ];
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          "phone": phone,
          "otp": otp,
          "device": myDeviceInfo.deviceName,
          "permissions": data,
        }),
      );

      if (response.statusCode != 200) {
        await apiCrashLogs(
          user: "Not Found",
          date: DateTime.now().toLocal().toString(),
          action: "verify user number",
          description: "This api used for sync all shops in local from server",
          error: json.decode(response.body)['message'],
        );
        throw HttpException(json.decode(response.body)['message']);
      } else {
        UserModel userModel = UserModel.fromJson(json.decode(response.body));
        await _storageController.setUsermodel(userModel: userModel);
        return userModel;
      }
    } catch (e) {
      await apiCrashLogs(
        user: "Not Found",
        date: DateTime.now().toLocal().toString(),
        action: "verifyusernumber",
        description: "This api used for verify number of user",
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<UserModel?> userProfile() async {
    return _storageController.userModel.value;
  }

  Future<User> userprofile() async {
    try {
      final url = Uri.parse('${AppConfig.host}/users/token/verify');
      http.Response response = await http.get(url, headers: {
        'Authorization': 'Bearer ${_storageController.userModel.value.token}',
      });
      if (response.statusCode != 200) {
        await apiCrashLogs(
          user: _storageController.userModel.value.user!.sId.toString(),
          date: DateTime.now().toLocal().toString(),
          action: "userprofile",
          description: "This api used for fetch user profile",
          error: json.decode(response.body)['message'],
        );
        throw HttpException(json.decode(response.body)['message']);
      }

      await _storageController.setUser(
        user: User.fromJson(
          json.decode(response.body),
        ),
      );
      storageController
          .setPermission(List.from(json.decode(response.body)['permissions']));
      return User.fromJson(json.decode(response.body));
    } catch (e) {
      await apiCrashLogs(
        user: _storageController.userModel.value.user!.sId.toString(),
        date: DateTime.now().toLocal().toString(),
        action: "userprofile",
        description: "This api used for fetch user profile",
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<List> getShops({
    required String skip,
    required String limit,
    required String name,
    required bool online,
  }) async {
    try {
      if (online) {
        Map<String, String> headers = await _storageController.getHeaders();
        final url = Uri.parse(
            '${AppConfig.host}/shops?skip=$skip&limit=$limit&name=$name');
        http.Response response = await http.get(url, headers: headers);
        if (response.statusCode != 200) {
          throw HttpException(json.decode(response.body)['message']);
        } else {
          if (json.decode(response.body)['data'].length > 0) {
            final data = json.decode(response.body)['data'];
            List<Shops> shops = [];
            data.forEach((e) {
              shops.add(Shops.fromJson(e));
            });

            return shops;
          } else {
            throw HttpException('No More data found');
          }
        }
      } else {
        List<ShopCreate> createShops =
            _storageController.shopCreateBox.values.toList();
        List<Shops> shopsB = [];
        if (createShops.isNotEmpty) {
          for (var element in createShops) {
            shopsB.add(
              Shops(
                sId: element.id,
                name: element.name,
                address: element.shopAddress,
                pincode: element.shopPincode,
                phone: element.shopPhone,
                email: element.shopEmail,
                location: Locations(
                  type: 'Point',
                  coordinates: [
                    double.parse(element.locationModel!.latitude.toString()),
                    double.parse(element.locationModel!.longitude.toString()),
                  ],
                ),
                status: 'new',
                mapAddress: element.shopAddress,
                ownerName: element.shopOwner,
                profile: Profile(thumbnail: 'N/A', url: 'N/A'),
                uploaded: false,
              ),
            );
          }
        }
        List<Shops> shops = _storageController.personalShopBox.values.toList();

        shops.addAll(shopsB);
        int s = double.parse(skip).toInt() * int.parse(limit);
        int e = s + int.parse(limit);
        if (e <= shops.length) {
          return shops.sublist(s, e);
        } else {
          return shops.sublist(s, shops.length);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Shops>> getShopsByKm({
    required double distance,
    required bool online,
  }) async {
    try {
      if (online) {
        Map<String, String> headers = await _storageController.getHeaders();
        List<String> loc = headers['location']!.split(',');
        final url = Uri.parse(
            '${AppConfig.host}/shops?longitude=${loc[1]}&latitude=${loc[0]}&limit=1000&maxDistance=${distance / 1000}');

        http.Response response = await http.get(url, headers: headers);

        if (response.statusCode != 200) {
          throw HttpException(json.decode(response.body)['message']);
        } else {
          if (json.decode(response.body)['data'].length > 0) {
            final data = json.decode(response.body)['data'];
            List<Shops> shops = [];
            data.forEach((e) {
              shops.add(Shops.fromJson(e));
            });

            return shops;
          } else {
            return [];
          }
        }
      } else {
        List<Shops> shops = await _storageController.getNearByOfflineShops(
            origin: Get.find<MapsController>().origin.value, radius: distance);
        return shops;
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Shops>> getPersonalShops() async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      final url = Uri.parse('${AppConfig.host}/shops?limit=1000');
      http.Response response = await http.get(url, headers: headers);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        if (json.decode(response.body)['data'].length > 0) {
          final data = json.decode(response.body)['data'];
          List<Shops> shops = [];
          for (var e in data) {
            shops.add(Shops.fromJson(e));
          }
          await _storageController.setPersonalShops(shops: shops);
          return shops;
        } else {
          _storageController.personalShopBox.clear();
          return [];
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Shops> getShopById({
    required String id,
    required bool online,
  }) async {
    try {
      if (online) {
        Map<String, String> headers = await _storageController.getHeaders();
        final url = Uri.parse('${AppConfig.host}/shops/$id');
        http.Response response = await http.get(url, headers: headers);

        if (response.statusCode != 200) {
          throw HttpException(json.decode(response.body)['message']);
        } else {
          return Shops.fromJson(json.decode(response.body));
        }
      } else {
        return _storageController.shopBox.get(id)!;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future moveVisitToUploadedShop({
    required String syncId,
    required String shopId,
  }) async {
    /* 
     This function is used for move visit from withoutUploadedShopVisit to withUploadedShopVisit
    */
    for (var element in _storageController.createVisitBox.values) {
      if (element.shop == syncId) {
        /* 

            Updating shopId & shopUploaded status in visit

        */
        element.shop = shopId;
        element.shopUploaded = true;
        _storageController.createVisitBox.put(element.syncId, element);
      }
    }
    return;
  }

  Future uploadShopImage({
    required ShopCreate shopCreate,
    required String? shopId,
    required String? visitId,
  }) async {
    /* 
      This function is used for move images of shop to image model
      for syncing....
    */
    if (shopCreate.shopImg != null && shopCreate.shopImg!.length > 1) {
      for (int i = 1; i < shopCreate.shopImg!.length; i++) {
        /* 
          Moving image of shop create in image model 
          image model will be synced later.
        */

        String syncId =
            '${_storageController.userModel.value.user!.sId}/image/${DateTime.now().millisecondsSinceEpoch}';
        _storageController.imageModelBox.put(
          syncId,
          ImageModel(
            imagePath: shopCreate.shopImg![i],
            shopId: shopId,
            visitId: visitId,
            syncId: syncId,
          ),
        );
      }
    }
  }

  Future<String> readResponse(HttpClientResponse response) {
    final completer = Completer<String>();
    final contents = StringBuffer();
    response.transform(utf8.decoder).listen((data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }

  Future<List<ShopImage>> getImages({
    required String id,
    required String skip,
    required String limit,
  }) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = await http.get(
        Uri.parse(
            '${AppConfig.host}/images?shopId=$id&skip=$skip&limit=$limit'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      }
      final data = json.decode(response.body)['data'];
      List<ShopImage> images = [];
      if (data.length > 0) {
        data.forEach((e) {
          images.add(ShopImage.fromJson(e));
        });
      }

      return images;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VisitModel>> getVisits({
    String? startDate,
    String? endDate,
    String? shopId,
    required bool online,
  }) async {
    List<VisitModel> visits = [];
    try {
      if (online) {
        Map<String, String> headers = await _storageController.getHeaders();
        final url = shopId != null
            ? Uri.parse('${AppConfig.host}/visits?shopId=$shopId')
            : Uri.parse(
                '${AppConfig.host}/visits?startDateQuery=$startDate&endDateQuery=$endDate');
        http.Response response = await http.get(url, headers: headers);

        if (response.statusCode != 200) {
          throw HttpException(json.decode(response.body)['message']);
        } else {
          if (json.decode(response.body)['data'].length > 0) {
            json.decode(response.body)['data'].forEach((e) {
              visits.add(VisitModel.fromJson(e));
            });
            await _storageController.setVisitsData(visits: visits);
            return visits;
          } else {
            return [];
          }
        }
      } else {
        if (shopId != null) {
          visits = _storageController.visitModelBox.values
              .where((element) =>
                  element.shop != null && element.shop!.sId == shopId)
              .toList();
        } else {
          visits = _storageController.visitModelBox.values
              .where((element) =>
                  DateTime.parse(element.createdAt as String)
                      .isAfter(DateTime.parse(startDate!)) &&
                  DateTime.parse(element.createdAt as String)
                      .isBefore(DateTime.parse(endDate!)))
              .toList();
          List<VisitModel> v = [];
          DateTime start = DateTime.parse(startDate.toString());
          DateTime end = DateTime.parse(endDate.toString());

          for (var element in _storageController.createVisitBox.values) {
            DateTime dateTime = DateTime.parse(element.time.toString());
            if (dateTime.isAfter(start) && dateTime.isBefore(end)) {
              v.add(
                VisitModel(
                  location: UserLocation(
                    latitude: double.parse(element.latitude.toString()),
                    longitude: double.parse(element.longitude.toString()),
                  ),
                  name: element.name,
                  phone: element.phone,
                  type: element.type,
                  reason: element.reason,
                  sId: "N/A",
                  remarks: element.remarks,
                  shop: ShopModel(
                    address: "Shop Address",
                    name: "N/A",
                    phone: "N/A",
                    sId: "N/A",
                  ),
                  emp: Emp(
                    name: "N/A",
                    sId: "N/A",
                  ),
                  createdAt: element.time,
                  images: element.image
                      .map(
                        (e) => VisitImages(thumbnailUrl: e, url: e),
                      )
                      .toList(),
                ),
              );
              visits.addAll(v);
            }
          }
        }
        return visits;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Reminders>> getReminders({
    required String key,
    required String value,
    required bool online,
  }) async {
    List<Reminders> reminders = [];
    try {
      if (online) {
        Map<String, String> headers = await _storageController.getHeaders();
        final url = Uri.parse('${AppConfig.host}/reminders?$key=$value');
        http.Response response = await http.get(url, headers: headers);
        if (response.statusCode != 200) {
          throw HttpException(json.decode(response.body)['message']);
        } else {
          if (json.decode(response.body)['data'].length > 0) {
            json.decode(response.body)['data'].forEach((e) {
              reminders.add(Reminders.fromJson(e));
            });
            await _storageController.setReminder(reminders: reminders);
            return reminders;
          } else {
            return [];
          }
        }
      } else {
        if (key == 'reminderDate') {
          reminders = _storageController.reminderBox.values
              .where((element) => DateTime.parse(element.date as String)
                  .isAfter(DateTime.parse(value)))
              .toList();
        } else if (key == 'shopId') {
          reminders = _storageController.reminderBox.values
              .where((element) => element.shop!.sId == value)
              .toList();
        } else {
          reminders = _storageController.reminderBox.values
              .where((element) => element.visit!.sId == value)
              .toList();
        }

        return reminders;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future gettodayattendancestatus({
    required bool alive,
  }) async {
    try {
      if (alive) {
        Map<String, String> headers = await _storageController.getHeaders();
        print(headers);
        String date = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ).millisecondsSinceEpoch.toString();

        final url = Uri.parse(
            '${AppConfig.host}/attendance?userId=${_storageController.userModel.value.user?.sId}&startDateQuery=$date');
        http.Response response = await http.get(
          url,
          headers: headers,
        );

        final data = json.decode(response.body)['data'];
        if (response.statusCode != 200) {
          throw HttpException(json.decode(response.body)['message']);
        } else {
          if (json.decode(response.body)['data'].length > 0) {
            if (data[0]['markedAbsent'] == true) {
              _storageController.setOdometerStatus(AppConfig.ABSENT);
            } else if (data[0]['value'] == 0.5) {
              _storageController.setOdometerStatus(AppConfig.HALFDAY);
            } else {
              await getTodayOdometer();
            }
          } else {
            _storageController.setOdometerStatus(AppConfig.NOTMARKED);
          }
        }
      } else {
        await _storageController.getOdometerStatus();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future getTodayOdometer() async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      String date = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).toString();

      final url = Uri.parse(
          '${AppConfig.host}/odometers?userId=${_storageController.userModel.value.user?.sId}&startDateQuery=$date');
      http.Response response = await http.get(
        url,
        headers: headers,
      );
      final data = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(data['message']);
      } else {
        if (data['data'].length > 0) {
          if (data['data'][0]['startReading'] != null &&
              data['data'][0]['endReading'] != null) {
            _storageController.setOdometerStatus(
              AppConfig.COMPLETE,
            );
            FlutterBackgroundService().invoke('stopService');
          } else {
            _storageController.setOdometerStatus(
              AppConfig.PRESENT,
            );
            FlutterBackgroundService().startService();
          }
        } else {
          _storageController.setOdometerStatus(AppConfig.NOTMARKED);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future changeReminderStatus({required String remId}) async {
    try {
      final url = Uri.parse('${AppConfig.host}/reminders/$remId');

      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      http.Response response = await http.patch(
        url,
        body: {
          "status": "COMPLETED",
        },
        headers: headers,
      );
      final data = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(data['message']);
      } else {}
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VisitType>> getTypes({
    required bool online,
  }) async {
    /* 
      This function use for fetch types of visit create.
    */
    try {
      if (online) {
        /* 

          This will execute when use is connected with internet
        
        */
        final url = Uri.parse('${AppConfig.host}/constants?key=VISIT_TYPE');
        http.Response response = await http.get(url);

        if (response.statusCode != 200) {
          throw HttpException(json.decode(response.body)['message']);
        } else {
          if (json.decode(response.body).length > 0) {
            List<VisitType> types = [];
            json.decode(response.body).forEach((e) {
              types.add(VisitType.fromJson(e));
            });
            await _storageController.setVisitTypesInLocal(
              visitTypes: types,
            );

            return types;
          } else {
            return [];
          }
        }
      } else {
        /* 
          This block will execute when user is not connected with internet

          This will fetch data from local database.
        */
        return await _storageController.getVisitTypesFromLocal();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> createVisitsFromLocal({
    required CreateVisit createVisit,
    required bool online,
    required bool instant,
  }) async {
    try {
      /* 
      * 1. create visit
      * 2. create reminder
       First this will store visit data in local storage
       then it will check if there is internet connection
        if there is internet connection then it will send data to server
        also it will delete data from local storage after sending data to server
        

        MapsController mapsController = Get.find<MapsController>(); this code only used for get current location
        from mapsController
    
      */

      MapsController mapsController = Get.find<MapsController>();
      createVisit.latitude = mapsController.origin.value.latitude.toString();
      createVisit.longitude = mapsController.origin.value.longitude.toString();
      /*

      No Longer need of this code...
      if (createVisit.withOutShop) {
        createVisit.shop =
            (_storageController.createVisitBox.length + 1).toString();
      }
      
      This code is used to create shop id for offline visit but now we are not using this code because
      now we are using unique sync id for sync data with server

      */
      bool inserted =
          await _storageController.setCreateVisitBox(createVisit: createVisit);
      Workmanager().registerOneOffTask(
        'SYNC_ONE',
        "SYNC_ONE",
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future createReminderInLocal({
    required CreateReminder createReminder,
  }) async {
    await _storageController.createReminderBox
        .put(createReminder.syncId, createReminder);

    return;
  }

  registerDevice({required MyDeviceInfo myDeviceInfo}) async {
    try {
      final url = Uri.parse(AppConfig.NOTIFICATION_HOST);

      http.Response response = await http.post(url, body: {
        'device_id': myDeviceInfo.deviceId,
        'device_type': myDeviceInfo.deviceType,
        'device_name': myDeviceInfo.deviceName,
        'userId': myDeviceInfo.userId,
        'token': myDeviceInfo.token,
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        return;
      } else {
        throw HttpException(json.decode(response.body)['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Odometers?> getOdometers({
    required String from,
    required bool online,
  }) async {
    try {
      if (online) {
        var d = from.split('-');
        d = d.map((e) => e.length == 1 ? '0$e' : e).toList();

        String endDate =
            DateTime.parse(d.join('-')).add(const Duration(days: 1)).toString();
        final url = Uri.parse(
            '${AppConfig.host}/odometers?userId=${_storageController.userModel.value.user?.sId}&startDateQuery=${d.join('-')}&endDateQuery=$endDate');
        Map<String, String> headers = await _storageController.getHeaders();
        http.Response response = await http.get(url, headers: headers);
        if (response.statusCode != 200) {
          throw HttpException(json.decode(response.body)['message']);
        } else {
          if (json.decode(response.body)['data'].length > 0) {
            List<Odometers> odometers = [];
            json.decode(response.body)['data'].forEach((e) {
              odometers.add(Odometers.fromJson(e));
            });
            await _storageController.setOdometersInBox(
              key: from,
              odometers: odometers[0],
            );
            return odometers[0];
          } else {
            return null;
          }
        }
      } else {
        return _storageController.odometerBox.get(from);
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future updateImageProfile({required String imagePath}) async {
    try {
      final url = Uri.parse('${AppConfig.host}/users/profile/upload');
      http.MultipartRequest request = http.MultipartRequest('PATCH', url);
      request.headers['authorization'] =
          'Bearer ${_storageController.userModel.value.token}';
      request.headers['location'] = _storageController.latLong;

      request.fields['userId'] =
          _storageController.userModel.value.user!.sId as String;
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imagePath,
      ));
      final res = await request.send();
      http.Response response = await http.Response.fromStream(res);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        User user = await userprofile();
        _storageController.setUserProfile(user: user);
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AttendanceData> getAttendance({
    required String month,
    required String year,
    required bool online,
  }) async {
    try {
      if (online) {
        month = (int.parse(month) - 1).toString();

        Map<String, String> headers = await _storageController.getHeaders();
        http.Response response = await http.get(
          Uri.parse(
            '${AppConfig.host}/attendance/reports/app?month=$month&year=$year',
          ),
          headers: headers,
        );

        if (response.statusCode != 200) {
          throw HttpException(json.decode(response.body)['message']);
        } else {
          await _storageController.setAttandanceData(
            attendanceData: AttendanceData(
              data: json.decode(response.body)['data'],
              distance: json.decode(response.body)['distance'].toString(),
            ),
          );
          print(json.decode(response.body)['data']);
          print(json.decode(response.body)['distance'].toString());
          return AttendanceData(
            data: json.decode(response.body)['data'],
            distance: json.decode(response.body)['distance'].toString(),
          );
        }
      } else {
        AttendanceData? attendance =
            _storageController.attendanceBox.get('today');

        if (attendance == null) throw HttpException('No Data Found');
        return attendance;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getProductsAndBrand({required bool product}) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = product == true
          ? await http.get(
              Uri.parse('${AppConfig.host}/constants?key=PRODUCTS'),
              headers: headers,
            )
          : await http.get(
              Uri.parse('${AppConfig.host}/constants?key=BRANDS'),
              headers: headers,
            );
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        List<String> list = [];
        if (json.decode(response.body).length > 0) {
          json.decode(response.body).forEach((e) {
            list.add(e['value']);
          });
        }
        product == true
            ? await _storageController.saveProducts(list)
            : await _storageController.saveBrands(list);

        return list;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getTeamsByUserId({required String userId}) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = await http.get(
          Uri.parse('${AppConfig.host}/users/teams?userId=$userId'),
          headers: headers);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        return User.fromJson(json.decode(response.body)['data']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserTeam>> getTeams({required bool online}) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      if (online) {
        http.Response response = await http.get(
          Uri.parse('${AppConfig.host}/users/teams'),
          headers: headers,
        );
        if (response.statusCode != 200) {
          throw HttpException(json.decode(response.body)['message']);
        } else {
          List<UserTeam> teams = [];
          if (json.decode(response.body).length > 0) {
            for (var e in json.decode(response.body)) {
              await _storageController.setTeams(userTeam: UserTeam.fromJson(e));
              teams.add(UserTeam.fromJson(e));
            }

            return teams;
          } else {
            await _storageController.clearTeams();
            return [];
          }
        }
      } else {
        return _storageController.userteamBox.values.toList();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future getUserNotification({
    required bool online,
  }) async {
    try {
      if (online) {
        _storageController.setNotificationLoading(value: true);
        final url = Uri.parse(
            '${AppConfig.NOTIFICATION_HOST}/${_storageController.userModel.value.user!.sId}');
        http.Response response = await http.get(url);
        if (response.statusCode != 200) {
          throw HttpException(json.decode(response.body)['message']);
        } else {
          List<UserNotification> notifications = [];
          if (json.decode(response.body).length > 0) {
            json.decode(response.body).forEach((e) {
              notifications.add(UserNotification.fromJson(e));
            });

            _storageController.setUserNotification(
              userNotification: notifications,
            );
          }

          _storageController.setNotificationLoading(value: false);
        }
      } else {
        _storageController.loadUserNotification();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future markAsReadNotification({
    required String notificationId,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.NOTIFICATION_HOST}/$notificationId');
      http.Response response = await http.put(url);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        _storageController.markReadNotificationById(id: notificationId);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future deleteAllNotifications({
    required List<String> ids,
  }) async {
    try {
      final url = Uri.parse(AppConfig.NOTIFICATION_HOST);
      http.Response response = await http.delete(url, body: {
        'id': ids.join(','),
      });
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        deleteAllNotifications(ids: ids);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> logout() async {
    try {
      MyDeviceInfo deviceInfo =
          await _storageController.getDeviceInfo(userId: "N/A", token: "N/A");

      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      http.Response response = await http.post(
          Uri.parse('${AppConfig.host}/users/logout'),
          headers: headers,
          body: {
            "device": deviceInfo.deviceName,
          });
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        await _storageController.removetoken();
        return true;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getGstStatus({
    required String gstin,
  }) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = await http.get(
        Uri.parse('${AppConfig.host}/dealers/verify/$gstin'),
        headers: headers,
      );
      print(response.body);
      if (response.statusCode != 200) {
        return json.decode(response.body)['message'];
      } else {
        if (json.decode(response.body)['status'] == false) {
          return 'Invalid GSTIN (GST Number not registered with us)';
        } else {
          return 'Valid GSTIN (GST Number registered with us)';
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<DealershipForm> verifyandgetgstdetails({required String gstin}) async {
    /* 

      this function used for verify gstin and get details of gstin
    
    */
    try {
      /* getting headers */
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = await http.get(
          Uri.parse('${AppConfig.host}/dealers/verify/$gstin'),
          headers: headers);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        /* Here we are checking if status of this gst number is true or false
          if it is true that means dealer already created or server

          if it is false that means dealer not created or server
          we have to create dealer on server with this gst number
        */

        if (json.decode(response.body)['status'] == false) {
          TempGSTDetals tempGSTDetals =
              TempGSTDetals.fromJson(json.decode(response.body));

          /* Here we are checking that status of this gst is ACT {active} or NOT 
          if it is not ACT that means gst number is bloked so we don't have to perform 
          dealer creation on server with this gst number.
          */
          if (tempGSTDetals.dealer!.status == 'ACT') {
            return DealershipForm(
              status: false,
              dealer: DealerShip(
                address: tempGSTDetals.dealer!.addrLoc,
                counterName: tempGSTDetals.dealer!.tradeName,
                firmName: tempGSTDetals.dealer!.tradeName,
                gstNumber: gstin,
                pincode: '${tempGSTDetals.dealer!.addrPncd}',
                panNumber: gstin.substring(1, 12),
                taluka: tempGSTDetals.dealer!.addrSt,
                tradeLicense: tempGSTDetals.dealer!.gstin,
                dateOfTradeLicense:
                    DateTime.parse(tempGSTDetals.dealer!.dtReg.toString())
                        .millisecondsSinceEpoch,
              ),
            );
          } else {
            /* Throwing exception that gst number is not active */
            throw HttpException("Dealer is not active");
          }
        } else {
          return DealershipForm.fromJson(json.decode(response.body));
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<BitmapDescriptor> downloadResizePictureCircle(
    String imageUrl, {
    int size = 150,
    bool addBorder = false,
    Color borderColor = Colors.white,
    double borderSize = 10,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color;

    final double radius = size / 2;

    //make canvas clip path to prevent image drawing over the circle
    final Path clipPath = Path();
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        const Radius.circular(100)));
    /* clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size * 8 / 10, size.toDouble(), size * 3 / 10),
        Radius.circular(100))); */
    canvas.clipPath(clipPath);

    print('${AppConfig.SERVER_IP}/$imageUrl');
    //paintImage
    http.Response response =
        await http.get(Uri.parse('${AppConfig.SERVER_IP}/$imageUrl'));

    final Uint8List imageUint8List = response.bodyBytes;
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();
    paintImage(
        fit: BoxFit.cover,
        alignment: Alignment.center,
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        image: imageFI.image);

    if (addBorder) {
      paint.color = borderColor;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = borderSize;
      canvas.drawCircle(Offset(radius, radius), radius, paint);
    }

    //convert canvas as PNG bytes
    final image = await pictureRecorder
        .endRecording()
        .toImage(size, (size * 1.1).toInt());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    //convert PNG bytes as BitmapDescriptor
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<List<String>> getDocumentKeys() async {
    try {
      /* This function is used to get all document keys from server */
      http.Response response = await http
          .get(Uri.parse('${AppConfig.host}/constants?key=DEALER_DOCUMENTS'));

      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        /* Document keys are like BANK_STATEMENT, PAN_CARD, ADHAR_CARD etc */
        List<String> documentsKeys = [];
        json.decode(response.body).forEach((e) {
          documentsKeys.add(e['value']);
        });
        return documentsKeys;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future createDealerShipForm({required DealerShip dealerShipForm}) async {
    try {
      /* here we are creating dealer on server */

      /* Getting headers from storage controller */
      Map<String, String> headers = await _storageController.getHeaders();

      /* we have to remove Content-Type from headers because we are sending multipart request */
      headers.remove('Content-Type');

      http.Response response = await http.post(
        Uri.parse('${AppConfig.host}/dealers'),
        headers: headers,
        body: {
          "counter_name": dealerShipForm.counterName,
          "firm_name": dealerShipForm.firmName,
          "address": dealerShipForm.address,
          "taluka": dealerShipForm.taluka,
          "pincode": dealerShipForm.pincode,
          "phone": dealerShipForm.phone,
          "landline": dealerShipForm.landline,
          "email": dealerShipForm.email,
          "counter_potential": dealerShipForm.counterPotential.toString(),
          "target_quantity": dealerShipForm.targetQuantity.toString(),
          "space_available": dealerShipForm.spaceAvailable.toString(),
          "gst_number": dealerShipForm.gstNumber,
          "pan_number": dealerShipForm.panNumber,
          "bank_name": dealerShipForm.bankName,
          "branch_name": dealerShipForm.branchName,
          "account_number": dealerShipForm.accountNumber,
          "cc_limits": dealerShipForm.ccLimits.toString(),
          "ifsc_code": dealerShipForm.ifscCode,
          "micr_code": dealerShipForm.micrCode,
          "trade_license": dealerShipForm.tradeLicense,
          "date_of_trade_license": dealerShipForm.dateOfTradeLicense.toString(),
          "validity_of_trade_license":
              dealerShipForm.validityOfTradeLicense.toString(),
          "cheque_number": dealerShipForm.chequeNumber.toString(),
          "cheque_date": dealerShipForm.chequeDate.toString(),
          "sd_amount": dealerShipForm.sdAmount.toString(),
          "partner_name": dealerShipForm.partnerName,
        },
      );

      if (response.statusCode != 201) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        /* 

          Here we are returning object of dealerShip after completion of dealer creation
        
        */
        return DealerShip.fromJson(json.decode(response.body)['dealer']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DealershipForm> uploadDocuments({
    required Map<String, Docs> docs,
    required String userId,
  }) async {
    /* 
      uploadDocuments function is used to upload documents of dealer
    */
    try {
      http.MultipartRequest request = http.MultipartRequest(
        'PATCH',
        Uri.parse('${AppConfig.host}/dealers/$userId/documents'),
      );

      /* Getting headers from storage controller */
      Map<String, String> headers = await _storageController.getHeaders();

      /* Here we are upoloading documents one by one */
      docs.forEach((key, value) async {
        /* 
        
          Checking if document is already uploaded for current document
          key or not if it false then we will upload that document on server
        
        */
        if (value.uploaded == false) {
          /* Checking url of document is null or not */
          if (value.url != "N/A") {
            /* 
              Here we are getting file from url of document
              and then we are adding that file to request
            */
            http.MultipartFile file = await http.MultipartFile.fromPath(
              value.key,
              value.url.toString(),
            );
            request.files.add(file);
          }
        }

        request.fields['title'] = value.key;
        request.fields['reason'] = value.reason;
      });

      /* Adding headers to request */
      request.headers.addAll(headers);

      /* Sending request to server */
      final res = await request.send();
      http.Response response = await http.Response.fromStream(res);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        return DealershipForm.fromJson(json.decode(response.body));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DealerShip> updateDealer({
    Object? body,
    required String id,
  }) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = await http.patch(
        Uri.parse('${AppConfig.host}/dealers/$id'),
        headers: headers,
        body: json.encode(body),
      );
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        DealerShip dealershipForm =
            DealerShip.fromJson(json.decode(response.body));
        return dealershipForm;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DealerShip> uploadSignAndImage({
    required String sign,
    required String image,
    required String id,
  }) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      http.MultipartRequest request = http.MultipartRequest(
        'PATCH',
        Uri.parse('${AppConfig.host}/dealers/$id'),
      );
      request.headers.addAll(headers);
      http.MultipartFile signFile = await http.MultipartFile.fromPath(
        'sign',
        sign,
      );
      http.MultipartFile imageFile = await http.MultipartFile.fromPath(
        'image',
        image,
      );
      request.files.add(signFile);
      request.files.add(imageFile);
      final res = await request.send();
      http.Response response = await http.Response.fromStream(res);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        DealerShip dealerShip = DealerShip.fromJson(json.decode(response.body));
        return dealerShip;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CPShop> getShopByCpCode({required String cpCode}) async {
    try {
      final url = Uri.parse(
          'https://mgdh.in/api/partner/search?search=$cpCode&emp=${_storageController.userModel.value.user!.emp}');
      http.Response response =
          await http.get(url, headers: {"token": "MaGaDh!2#4%6&8(0"});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true && data['data'].length > 0) {
          return CPShop.fromJson(data['data'][0]);
        } else {
          throw HttpException('No shop found');
        }
      } else {
        throw HttpException(json.decode(response.body)['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future getMeetingUsers({
    required String? startDate,
    required String? endDate,
  }) async {
    /* 
      getMeetingUser is used for get meetings with users 
      we are getting user from this api and then we are showing
    */
    try {
      final url = Uri.parse(
          '${AppConfig.host}/meetings/mistri/app?startTime=$startDate&endTime=$endDate');

      Map<String, String> headers = await _storageController.getHeaders();
      print(headers);
      http.Response response = await http.get(url, headers: headers);
      print(response.body);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        if (json.decode(response.body)['users'].length > 0) {
          Map<String, MeetingUser> users = {};
          json.decode(response.body)['users'].forEach((user) {
            MeetingUser u = MeetingUser.fromJson(user);
            users[u.sId.toString()] = u;
          });
          await storageController.setMeetingsUsers(users: users);
        }

        await storageController.meetingModelBox.clear();
        if (json.decode(response.body)['meetings'].length > 0) {
          Map<String, MeetingModel> meeting = {};
          json.decode(response.body)['meetings'].forEach((meet) {
            MeetingModel m = MeetingModel.fromJson(meet);
            m.synced = true;
            if (m.requestedUser != null) {
              meeting[
                  '${DateTime.fromMillisecondsSinceEpoch(m.date as int).toString().split(' ').first}-${m.requestedUser}'] = m;
            }
          });
          await storageController.setMeetingsInMeetingModel(
            meetings: meeting,
          );
          return;
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  createMeetingInLocalDatabase({required MeetingModel meeting}) async {
    try {
      /* 
        This function used for create meeting for using in local database
      */
      Map<String, MeetingModel> meetings = {};
      /* 
        Creating key with date and requested user id
      */
      String key =
          '${DateTime.fromMillisecondsSinceEpoch(meeting.date as int).toString().split(' ').first}-${meeting.requestedUser}';

      meetings[key] = meeting;
      /* 
        Setting meetings in local database
      */
      if (_storageController.meetingModelBox.get(key) == null) {
        await storageController.setMeetingsInMeetingModel(meetings: meetings);
        Workmanager().cancelByUniqueName('SYNC_ONE');
        Workmanager().registerOneOffTask(
          'SYNC_ONE',
          "SYNC_ONE",
          constraints: Constraints(
            networkType: NetworkType.connected,
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg:
                'Meeting already created on this date for ${meeting.requestedUser}');
      }

      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LeaveModel>> getAllLeavesofUser() async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = await http.get(
        Uri.parse('${AppConfig.host}/user-leave'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        if (json.decode(response.body)['data'].length > 0) {
          List<LeaveModel> leaves = [];
          json.decode(response.body)['data'].forEach((leave) {
            leaves.add(LeaveModel.fromJson(leave));
          });
          return leaves;
        } else {
          return [];
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getLeaveTypes() async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = await http.get(
        Uri.parse('${AppConfig.host}/constants?key=USER_LEAVE_TYPE'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        if (json.decode(response.body).length > 0) {
          List<String> leaveTypes = [];
          json.decode(response.body).forEach((leaveType) {
            leaveTypes.add(leaveType['value']);
          });
          return leaveTypes;
        } else {
          return [];
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future applyForLeave({required LeaveCreate leave}) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      http.Response response = await http.post(
        Uri.parse('${AppConfig.host}/user-leave'),
        headers: headers,
        body: {
          'leaveType': leave.leaveType,
          'startDate':
              DateTime.parse(leave.startDate).millisecondsSinceEpoch.toString(),
          'endDate':
              DateTime.parse(leave.endDate).millisecondsSinceEpoch.toString(),
          'reason': leave.reason,
        },
      );
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        return;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<MyMeetingModel>> getassignedMeetings() async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = await http.get(
        Uri.parse('${AppConfig.host}/meetings/mistri/app/requested-user'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        if (json.decode(response.body).length > 0) {
          List<MyMeetingModel> meetings = [];
          json.decode(response.body).forEach((meeting) {
            meetings.add(MyMeetingModel.fromJson(meeting));
          });
          return meetings;
        } else {
          return [];
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CreatedMeetings>> getCreatedMeetings(
      {required int startTime, required int endTime}) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = await http.get(
        Uri.parse(
            '${AppConfig.host}/meetings/mistri/app?startTime=$startTime&endTime=$endTime'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        if (json.decode(response.body)['meetings'].length > 0) {
          List<CreatedMeetings> meetings = [];
          json.decode(response.body)['meetings'].forEach((meeting) {
            print(meeting);
            meetings.add(CreatedMeetings.fromJson(meeting));
          });
          return meetings;
        } else {
          return [];
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  updateMeeting({
    required String meetingId,
    required String status,
    required List<Map<String, String>> body,
  }) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      http.Response response = await http.patch(
        Uri.parse('${AppConfig.host}/meetings/mistri/app/$meetingId/approve'),
        headers: headers,
        body: {
          "status": status,
          "userResponse": json.encode(body),
        },
      );
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        return status;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> responseFormFields() async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = await http.get(
        Uri.parse('${AppConfig.host}/constants?key=MEETING_USER_RESPONSE'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        if (json.decode(response.body).length > 0) {
          List<String> leaveTypes = [];
          json.decode(response.body).forEach((leaveType) {
            leaveTypes.add(leaveType['value']);
          });
          return leaveTypes;
        } else {
          return [];
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future uploadMeetingImage({
    required String imagePath,
    required String meetingId,
    required String shopId,
  }) async {
    /* 
       This function is responsible for uploading images of visit or shop.
       If we send image only with shopId then it will upload image in shop gallery
       If we send image with visitId then it will upload image in visit gallery
    
    */
    try {
      /* 
        Sending multipart request to server

      */
      final url = Uri.parse('${AppConfig.host}/images');
      http.MultipartRequest request = http.MultipartRequest('POST', url);
      request.headers['authorization'] =
          'Bearer ${_storageController.userModel.value.token}';
      request.fields['meetingId'] = meetingId;
      request.fields['shopId'] = shopId;
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imagePath,
      ));

      final res = await request.send();
      http.Response response = await http.Response.fromStream(res);

      if (response.statusCode != 201) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  // Only used for instant create odometer
  Future createattendance({
    required String startReading,
    required LatLong startCoordinate,
    required String imagePath,
    required String date,
    required bool completed,
    required String time,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.host}/odometers');
      http.MultipartRequest request = completed
          ? http.MultipartRequest('PATCH', url)
          : http.MultipartRequest('POST', url);
      request.headers['authorization'] =
          'Bearer ${_storageController.userModel.value.token}';

      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'image',
        imagePath,
      );

      request.files.add(multipartFile);
      request.fields['date'] = date;
      request.fields[completed ? 'endReading' : 'startReading'] = startReading;
      request.fields[completed ? 'endCoordinate' : 'startCoordinate'] =
          '{ "latitude": ${startCoordinate.latitude}, "longitude": ${startCoordinate.longitude} }';
      request.fields['time'] = time;
      final res = await request.send();
      http.Response response = await http.Response.fromStream(res);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await gettodayattendancestatus(alive: true);
        return;
      } else {
        print(response.body);
        throw HttpException(json.decode(response.body)['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  postHelpRequest({
    required List<String> images,
    required String? recPath,
    required String? title,
    required String? description,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.host}/tickets');
      http.MultipartRequest request = http.MultipartRequest('POST', url);
      request.headers['authorization'] =
          'Bearer ${_storageController.userModel.value.token}';
      request.fields['title'] = title ?? 'SOME ISSUES';
      request.fields['description'] = description ?? 'SOME ISSUES';
      for (String path in images) {
        if (path != 'ADD_IMAGE_WIDGET') {
          request.files.add(await http.MultipartFile.fromPath('image', path));
        }
      }
      if (recPath != null) {
        request.files
            .add(await http.MultipartFile.fromPath('recording', recPath));
      }
      final res = await request.send();
      http.Response response = await http.Response.fromStream(res);
      if (response.statusCode == 200) {
        return;
      } else {
        throw HttpException(json.decode(response.body)['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  getTickets() async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = await http.get(
        Uri.parse('${AppConfig.host}/tickets/app'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        if (json.decode(response.body)['data'].length > 0) {
          List<TicketModel> tickets = [];
          json.decode(response.body)['data'].forEach((ticket) {
            tickets.add(TicketModel.fromJson(ticket));
          });
          return tickets;
        } else {
          return [];
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
