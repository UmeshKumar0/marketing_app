import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/models/LatLon.dart';
import 'package:marketing/src/user/models/create_odometer.dart';
import 'package:http/http.dart' as http;
import 'package:marketing/src/user/models/create_reminder.dart';
import 'package:marketing/src/user/models/create_visit.dart';
import 'package:marketing/src/user/models/image_model.dart';
import 'package:marketing/src/user/models/meetings/meeting_model.dart';
import 'package:marketing/src/user/models/odometers.dart';
import 'package:marketing/src/user/models/shopCreate.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:marketing/src/user/models/user_model.dart';
import 'package:marketing/src/user/models/visit_model.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart' as geo;

class SyncService {
  Future<bool> sync() async {
    print('syncing data');
    /* 
      Initiliaze the hive boxes and openings
    */
    await AppConfig.register();
    Box<UserModel> userModel = Hive.box<UserModel>(AppConfig.USERMODEL);
    if (userModel.isEmpty) {
      return true;
    }
    await sendLocation(userId: userModel.getAt(0)?.user!.sId as String);
    await attendanceSync();
    try {
      String status = await getOdometerStatus();
      if (status == AppConfig.PRESENT) {
        await shopCreateSync();
        await syncNormalVisits();
        await syncReminders();
        await syncImages();
        await syncMeetings();

        return true;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future sendLocation({required String userId}) async {
    geo.Position position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high);
    http.Response res = await http
        .post(Uri.parse('${AppConfig.host}/location-log'), headers: {}, body: {
      'lat': position.latitude.toString(),
      'lng': position.longitude.toString(),
      'userId': userId,
    });

    return true;
  }

  Future<bool> attendanceSync() async {
    /* 
      Initiliaze the hive boxes and openings
    */

    /*
      Creating instance of the CreateOdometer box
    */
    Box<CreateOdometerModel> box =
        Hive.box<CreateOdometerModel>(AppConfig.CREATE_ODOMETER);
    /* 
      Creating instance of the Usermodel box for authorization token
    */
    Box<UserModel> userModel = Hive.box<UserModel>(AppConfig.USERMODEL);
    /* Checking if the box is empty or not */
    if (userModel.isEmpty) {
      return true;
    } else {
      Box<Odometers> odometerBox = Hive.box<Odometers>(AppConfig.ODOMETERS);

      CreateOdometerModel? createOdometerModel = box.get('attendance');
      try {
        if (createOdometerModel != null) {
          if (createOdometerModel.isAbsent) {
            await markabsent(
              token: userModel.length > 0
                  ? userModel.getAt(0)?.token as String
                  : "",
            );
          } else {
            await createattendance(
              time: createOdometerModel.time.toString(),
              date: createOdometerModel.time.toString(),
              startReading: createOdometerModel.reading.toString(),
              startCoordinate: createOdometerModel.coordinate as LatLong,
              imagePath: createOdometerModel.imgPath as String,
              completed: createOdometerModel.completed,
              token: userModel.length > 0
                  ? userModel.getAt(0)?.token as String
                  : "",
            );
          }
        }
      } catch (e) {
        odometerBox.clear();
        box.put(
          'attendance',
          createOdometerModel as CreateOdometerModel,
        );
        rethrow;
      } finally {
        box.delete('attendance');
      }
    }
    return true;
  }

  Future markabsent({required String token}) async {
    try {
      final url = Uri.parse('${AppConfig.host}/attendance/markabsent');
      http.Response response = await http.patch(url, headers: {
        'Authorization': 'Bearer $token'
      }, body: {
        'value': 'true',
      });

      if (response.statusCode != 200) {
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future createattendance({
    required String startReading,
    required LatLong startCoordinate,
    required String imagePath,
    required String date,
    required bool completed,
    required String time,
    required String token,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.host}/odometers');
      http.MultipartRequest request = completed
          ? http.MultipartRequest('PATCH', url)
          : http.MultipartRequest('POST', url);
      request.headers['authorization'] = 'Bearer $token';

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
        return;
      } else {}
    } catch (e) {
      rethrow;
    }
  }

  loadAllShop() async {
    /* 
      Initiliaze the hive boxes and openings
    */

    await AppConfig.register();
    /* 
      Creating instance of the Usermodel box for authorization token
    */
    Box<UserModel> userModel = Hive.box<UserModel>(AppConfig.USERMODEL);

    Box<Shops> shopBox = Hive.box<Shops>(AppConfig.SHOP_MODEL);
    /* Checking if the box is empty or not */
    if (userModel.isEmpty) {
      return true;
    } else {
      Box timeStamp = await Hive.openBox('lasttime');
      String val = await timeStamp.get('lasttime') ?? '0';
      try {
        String lastTime = val;
        final url = Uri.parse(lastTime == '0'
            ? '${AppConfig.host}/shops/shop-offline'
            : '${AppConfig.host}/shops/shop-offline?timestamp=$lastTime');
        final response = await http.get(url,
            headers: {'Authorization': 'Bearer ${userModel.getAt(0)?.token}'});
        if (response.statusCode != 200) {
        } else {
          final responseData = await json.decode(response.body)['data'];
          if (json.decode(response.body)['count'] < shopBox.length) {
            shopBox.clear();
            Box timeStamp = await Hive.openBox('lasttime');
            await timeStamp.put('lasttime', 0);
            loadAllShop();
          } else {
            for (var shop in responseData) {
              Shops shops = Shops.fromJson(shop);
              await shopBox.put(shops.sId, shops);
            }
          }
          DateTime t = DateTime.now();

          await timeStamp.put(
            'lasttime',
            t.millisecondsSinceEpoch.toString(),
          );
          return true;
        }
      } catch (e) {
        await apiCrashLogs(
          user: userModel.getAt(0)?.user!.sId as String,
          date: DateTime.now().toLocal().toString(),
          action: "loadAllShops",
          description: "This api used for sync all shops in local from server",
          error: e.toString(),
        );
        return true;
      }
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

  Future<String> getOdometerStatus() async {
    Box box = await Hive.openBox('odometer');
    String status = box.get(getTodayDate(), defaultValue: AppConfig.NOTMARKED);
    return status;
  }

  String getTodayDate() {
    DateTime date = DateTime.now();
    String today = "${date.year}-${date.month}-${date.day}";
    return today;
  }

  Future<bool> shopCreateSync() async {
    try {
      /* 
      Creating instance of the Usermodel box for authorization token
    */

      Box<UserModel> userModel = Hive.box<UserModel>(AppConfig.USERMODEL);
      Box<Shops> shopBox = Hive.box<Shops>(AppConfig.SHOP_MODEL);
      Box<ShopCreate> shopCreateBox =
          Hive.box<ShopCreate>(AppConfig.SHOP_CREATE);
      List<ShopCreate> shopCreates = shopCreateBox.values.toList();
      /* Getting all shop create request in a variable for perform shop create operation */

      if (shopCreates.isEmpty) {
        return true;
      } else {
        /* 
          This will insert shop one by one from database to server
        */

        for (var shopCreate in shopCreates) {
          Shops? responseShop;
          try {
            /*
             This function is responsible for create shop and return data of synced shop
             in responseShop
            */
            responseShop = await createShop(
              shopCreate: shopCreate,
              latLong: LatLong(
                longitude: double.parse(
                  shopCreate.locationModel!.longitude.toString(),
                ),
                latitude: double.parse(
                  shopCreate.locationModel!.latitude.toString(),
                ),
              ),
              token: userModel.getAt(0)?.token as String,
            );

            /* 

              After shop create done on server this will move visit related to current
              shop from withoutUploadedShopVisit to withUploadedShopVisit

              withUploadedShopVisit means shop is synced with server but visit are not synced
              withoutUploadedShopVisit means shop and visit both are not synced with server

            */

            moveVisitToUploadedShop(
              syncId: shopCreate.id.toString(),
              shopId: responseShop.sId.toString(),
            );
            /* 
            
              This Function used for add shop in main local database.
            */

            await shopBox.put(
              responseShop.sId,
              responseShop,
            );

            /* 

              Here we are moving images from shop create to image model.
              which will be synced later
            
            */

            uploadShopImage(
              shopCreate: shopCreate,
              shopId: responseShop.sId,
              visitId: null,
              sId: userModel.getAt(0)?.user!.sId as String,
            );

            /* 

              Now Here we will remove shop from shop create model 
            
            */

            await shopCreateBox.delete(shopCreate.id);
          } on HttpException catch (e) {
            if (e.message == "EXIST") {
              /* 
                We will check that is there any visit exist with create shop syncId
              */

              Box<CreateVisit> createVisitBox =
                  Hive.box<CreateVisit>(AppConfig.VISIT_CREATE_DB);
              List<CreateVisit> visits = createVisitBox.values
                  .where(
                    (element) =>
                        element.shop.toString() == shopCreate.id.toString(),
                  )
                  .toList();

              /* 

                If Visit is exist with that shop then we will filter original data of that shop from shoBox using 
                shop's syncId
              
              */
              if (visits.isNotEmpty) {
                List<Shops> shop = shopBox.values
                    .where((element) => element.syncId == shopCreate.id)
                    .toList();
                /* 
                  If Shop found with that sync id then we will move visits related to that shop in visit withShop Model
                */
                if (shop.isNotEmpty) {
                  moveVisitToUploadedShop(
                    syncId: shopCreate.id.toString(),
                    shopId: shop[0].sId.toString(),
                  );
                }
              }
              await shopCreateBox.delete(shopCreate.id.toString());
            } else {
              throw HttpException(e.message);
            }
          } catch (e) {
            rethrow;
          }
        }
        // Workmanager().registerOneOffTask('sync_shops', 'sync_shop');
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future uploadShopImage({
    required ShopCreate shopCreate,
    required String? shopId,
    required String? visitId,
    required String sId,
  }) async {
    /* 
      This function is used for move images of shop to image model
      for syncing....
    */

    Box<ImageModel> imageModelBox = Hive.box<ImageModel>(AppConfig.IMAGE_MODEL);
    if (shopCreate.shopImg != null && shopCreate.shopImg!.length > 1) {
      for (int i = 1; i < shopCreate.shopImg!.length; i++) {
        /* 
          Moving image of shop create in image model 
          image model will be synced later.
        */

        String syncId = '$sId/image/${DateTime.now().millisecondsSinceEpoch}';
        imageModelBox.put(
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

  Future moveVisitToUploadedShop({
    required String syncId,
    required String shopId,
  }) async {
    /* 
     This function is used for move visit from withoutUploadedShopVisit to withUploadedShopVisit
    */

    Box<CreateVisit> createVisitBox =
        Hive.box<CreateVisit>(AppConfig.VISIT_CREATE_DB);
    for (var element in createVisitBox.values) {
      if (element.shop == syncId) {
        /* 

            Updating shopId & shopUploaded status in visit

        */
        element.shop = shopId;
        element.shopUploaded = true;
        createVisitBox.put(element.syncId, element);
      }
    }
    return;
  }

  Future<Shops> createShop({
    required ShopCreate shopCreate,
    required LatLong latLong,
    required String token,
  }) async {
    /* 

      createShop function use to create a new shop with lat and long.
      In this function we also uploading a image or a logo of shop 
      so we are sending multipart request
    
    */

    final url = Uri.parse('${AppConfig.host}/shops');
    try {
      http.MultipartRequest request = http.MultipartRequest('POST', url);
      request.headers['Accept'] = 'application/json';
      request.headers['Content-type'] = 'application/json';
      request.headers['authorization'] = 'Bearer $token';

      request.fields['name'] = shopCreate.name as String;
      request.fields['address'] = shopCreate.shopAddress as String;
      request.fields['ownerName'] = shopCreate.shopOwner as String;
      request.fields['phone'] = shopCreate.shopPhone as String;
      request.fields['email'] = shopCreate.shopEmail as String;
      request.fields['brand'] = shopCreate.shopBrand as String;
      request.fields['products'] = shopCreate.shopProducts as String;
      request.fields['pincode'] = shopCreate.shopPincode as String;
      request.fields['syncId'] = shopCreate.id.toString();
      request.fields['mapAddress'] = shopCreate.mapAddress as String;
      request.fields['latitude'] = latLong.latitude.toString();
      request.fields['longitude'] = latLong.longitude.toString();
      http.MultipartFile file = await http.MultipartFile.fromPath(
        'image',
        shopCreate.shopImg![0],
      );
      request.files.add(file);
      final res = await request.send();
      http.Response response = await http.Response.fromStream(res);
      if (response.statusCode != 201) {
        /* 
          This block will execute if there is any error while uploading shop on server

        */
        if (response.statusCode == 501) {
          /* 
            This will execute if shop is already exist on server with same syncId
          */
          throw HttpException('EXIST');
        } else {
          throw HttpException(json.decode(response.body)['message']);
        }
      } else {
        /* 
           Return shop data if shop is created successfully
        
        */
        return Shops.fromJson(json.decode(response.body));
      }
    } catch (e) {
      rethrow;
    }
  }

  syncNormalVisits() async {
    try {
      /* 
        This function is used to create visit from server 
        with shop which is already created or not created yet(stored in local storage)

        In This function we are getting data from local storage and sending data to server
        and deleting data from local storage after sending data to server


        await syncVisitWithoutShop() this function is used to create visit without shop

        await syncVisitWithLocalShop() this function is used to create visit with shop which is 
        already created and synced with server and stored in local database.
      */
      await syncVisitWithLocalShop();

      await syncVisitsWithoutShop();
    } catch (e) {
      rethrow;
    }
  }

  syncVisitWithLocalShop() async {
    try {
      /* 
        This function is used to create visit with shop which is already created and synced with server

        In This function we are getting data from local storage and sending data to server
      */
      Box<UserModel> userModelBox = Hive.box<UserModel>(AppConfig.USERMODEL);
      if (userModelBox.values.isEmpty) {
        return true;
      }
      Box<CreateVisit> createVisitBox =
          Hive.box<CreateVisit>(AppConfig.VISIT_CREATE_DB);
      List<CreateVisit> createVisits = createVisitBox.values
          .where((element) =>
              (element.shopUploaded == true && element.withOutShop == false))
          .toList();

      if (createVisits.isNotEmpty) {
        for (var i = 0; i < createVisits.length; i++) {
          try {
            /* 
            This loop is used to send data to server



            await createVisit(createVisit: createVisits[i]) this function is used to create visit
            This function is responsible for create all type of visit like normal visit, visit with shop, visit without shop etc
          
          */
            await creatVisit(
              createVisit: createVisits[i],
              token: userModelBox.values.first.token as String,
              sId: userModelBox.values.first.user!.sId as String,
            );

            /* 
            This code is used to delete data from local storage after sending data to server
            If Data is Created successfully then we will delete data from local storage
          */

            await createVisitBox.delete(createVisits[i].syncId);
          } on HttpException catch (e) {
            /* 
            If there is any error while sending data to server then we will not delete data from local storage
            and we will show error message to user

            and if e.message == "EXIST" then we will delete data from local storage. That means data is already created
            otherwise we will not delete data from local storage and this function will throw another HttpException
            */

            if (e.message == "EXIST") {
              await createVisitBox.delete(createVisits[i].syncId);
            } else {
              throw HttpException(e.message);
            }
          } catch (e) {
            rethrow;
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  syncVisitsWithoutShop() async {
    /* 
      
      This function is used to create visit without shop

      In This function we are getting data from local storage and sending data to server
      and deleting data from local storage after sending data to server
      Shop id is not required in this.
      We can create visit for CONSTRUCTION_SITE, CONTRACTOR/MASON_VISIT, OTHERS etc.
    
    */

    Box<UserModel> userModelBox = Hive.box<UserModel>(AppConfig.USERMODEL);
    Box<CreateVisit> createVisitBox =
        Hive.box<CreateVisit>(AppConfig.VISIT_CREATE_DB);
    if (userModelBox.values.isEmpty) {
      return true;
    }

    try {
      /* 
        Getting offline visit data from local storage
      */
      List<CreateVisit> createVisits = await getCreateVisitBox(
        withoutShop: true,
      );

      /* 
        Check if there is any offline visit data
      */

      if (createVisits.isNotEmpty) {
        for (CreateVisit c in createVisits) {
          /* 

            This loop is used to send data to server

            await createVisit(createVisit: c) this function is used to create visit
            This function is responsible for create all type of visit like normal visit, visit with shop, visit without shop etc
          
          */
          try {
            await creatVisit(
              createVisit: c,
              token: userModelBox.values.first.token as String,
              sId: userModelBox.values.first.user!.sId as String,
            );

            /* 
            This code is used to delete data from local storage after sending data to server
            */
            await createVisitBox.delete(c.syncId);
          } on HttpException catch (e) {
            /* 
            If there is any error while sending data to server then we will not delete data from local storage
            and we will show error message to user

            and if e.message == "EXIST" then we will delete data from local storage. That means data is already created
            otherwise we will not delete data from local storage and this function will throw another HttpException
            */

            if (e.message == "EXIST") {
              await createVisitBox.delete(c.syncId);
            } else {
              throw HttpException(e.message);
            }
          } catch (e) {
            rethrow;
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CreateVisit>> getCreateVisitBox(
      {required bool withoutShop}) async {
    try {
      Box<CreateVisit> createVisitBox =
          Hive.box<CreateVisit>(AppConfig.VISIT_CREATE_DB);
      return createVisitBox.values
          .where((element) => element.withOutShop == withoutShop)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future creatVisit({
    required CreateVisit createVisit,
    required String token,
    required String sId,
  }) async {
    Box<CreateReminder> createReminderBox =
        Hive.box<CreateReminder>("CREATE_REMINDER_BOX");
    Box<ImageModel> imageModelBox = Hive.box<ImageModel>(AppConfig.IMAGE_MODEL);
    try {
      final url = Uri.parse('${AppConfig.host}/visits');

      Object body;
      if (createVisit.withOutShop == true) {
        /* 
        This code is used to create visit without shop.
        This code will generate body for visit without shop
        */
        body = {
          'remarks': createVisit.remarks,
          'type': createVisit.type,
          'reason': 'reason',
          'phone': createVisit.phone,
          'name': createVisit.name,
          'latitude': createVisit.latitude,
          'longitude': createVisit.longitude,
          'syncId': createVisit.syncId,
          'time': DateTime.parse(createVisit.time.toString())
              .millisecondsSinceEpoch
              .toString(),
        };
      } else {
        /*
        This code is used to create visit with shop.
        This code will generate body for visit with shop
        */

        body = {
          'remarks': createVisit.remarks,
          'type': createVisit.type,
          'shop': createVisit.shop,
          'reason': 'reason',
          'latitude': createVisit.latitude,
          'longitude': createVisit.longitude,
          'syncId': createVisit.syncId,
          'time': DateTime.parse(createVisit.time.toString())
              .millisecondsSinceEpoch
              .toString(),
        };
      }

      http.Response response = await http.post(
        url,
        headers: {"authorization": 'Bearer $token'},
        body: body,
      );
      Box<Shops> shopBox = Hive.box<Shops>(AppConfig.SHOP_MODEL);
      if (createVisit.createReminder != null) {
        createVisit.createReminder!.visit = json.decode(response.body)['_id'];
        if (createVisit.shop != null) {
          if (createVisit.shop!.contains("shop")) {
            List<Shops> shops = shopBox.values
                .where((element) => element.syncId == createVisit.shop)
                .toList();

            if (shops.isNotEmpty) {
              createVisit.createReminder!.shop = shops[0].sId;
            }
          } else {
            createVisit.createReminder!.shop = createVisit.shop;
          }
        }
      }

      if (response.statusCode != 201) {
        /* 
        If there is any error while sending data to server then we will throw HttpException
        
        Some condition for throwing HttpException

        if(response.statusCode == 501) then we will throw HttpException with message "EXIST"
        else we will throw HttpException with message "Error"
        
        */

        if (response.statusCode == 501) {
          /* Here we will check if reminder created for that visit then we will store it in createReminderBox 
           Which is used to create reminder for visit later
          */

          if (createVisit.createReminder != null) {
            await createReminderBox.put(
              createVisit.createReminder!.syncId,
              createVisit.createReminder as CreateReminder,
            );
          }
          throw HttpException("EXIST");
        } else {
          throw HttpException(json.decode(response.body)['message']);
        }
      } else {
        /* 
          When visit will be created successfully then we will upload images of that visit
          one by one. 

          if there is any error while uploading images then we will delete visit from local storage 
        
        */

        if (createVisit.createReminder != null) {
          /* 
              Here we will check if reminder created for that visit then we will store it in createReminderBox 
              Which is used to create reminder for visit later
          */
          await createReminderBox.put(
            createVisit.createReminder!.syncId,
            createVisit.createReminder as CreateReminder,
          );
        }

        for (int i = 0; i < createVisit.image.length; i++) {
          /* 
            This will store all images of current visit in image model box.

          */
          String syncId = '$sId/image/${DateTime.now().millisecondsSinceEpoch}';

          await imageModelBox.put(
            syncId,
            ImageModel(
              imagePath: createVisit.image[i],
              visitId: json.decode(response.body)['_id'],
              shopId: json.decode(response.body)['shop'],
              syncId: syncId,
            ),
          );
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future syncReminders() async {
    /* 

      syncReminder() used for sync reminder for visits which is created in offline mode
    
    */
    Box<UserModel> userModel = Hive.box<UserModel>(AppConfig.USERMODEL);
    if (userModel.isEmpty) {
      return true;
    }
    Box<CreateReminder> createReminderBox =
        Hive.box<CreateReminder>("CREATE_REMINDER_BOX");
    Box<Shops> shopBox = Hive.box<Shops>(AppConfig.SHOP_MODEL);

    Box<VisitModel> visitModelBox = Hive.box<VisitModel>(AppConfig.VISIT_MODEL);
    try {
      List<CreateReminder> reminders = createReminderBox.values.toList();
      /* Here first we check is there any reminder exist for sync or not */

      if (reminders.isNotEmpty) {
        /* if Reminder exist then we wil start syncing one by one and remove it from local database */

        for (CreateReminder createReminder in reminders) {
          try {
            String? id = createReminder.visit;

            /* 
            
              Check if original Shop Id updated in reminders or not 
              if Shop of reminder contains "shop" then we have to filter 
              shop Id from server then we will perform reminder syncing....
            
            */

            if (createReminder.shop != null &&
                createReminder.shop!.contains("shop")) {
              List<Shops> shops = shopBox.values
                  .where((element) => element.syncId == createReminder.shop)
                  .toList();

              if (shops.isNotEmpty) {
                createReminder.shop = shops[0].sId;
              }
            }

            /* 
            
              Check if original visit id updated in reminders or not 
              if visit id of reminder contains "visit" then we have to filter 
              visit id from server then we will perform reminder syncing....
            
            */

            if (id != null && id.contains("visit")) {
              /*
                This process bad this will be updated later 

                because of running loop inside loop is bad thing.....
                and i am filtring visit id from original visit model.....
              */
              if (visitModelBox.isEmpty) {
                return;
              } else {
                List<VisitModel> visitId = visitModelBox.values
                    .where((element) => element.syncId == createReminder.visit)
                    .toList();
                if (visitId.isNotEmpty) {
                  id = visitId[0].sId;
                }
              }
            }

            /* Now Here we will send http request to server for creating reminder */
            bool status = await this.createReminder(
              date: createReminder.date.toString(),
              remarks: createReminder.remarks.toString(),
              syncId: createReminder.syncId.toString(),
              visitId: id.toString(),
              shopId: createReminder.shop,
              token: userModel.getAt(0)!.token as String,
            );

            /* checking that reminder is created or not */
            if (status) {
              /* Deleting reminder from local storage*/
              await createReminderBox.delete(createReminder.syncId);
            }
          } on HttpException catch (e) {
            if (e.message == "EXIST") {
              /* Deleting reminder from local storage*/
              await createReminderBox.delete(createReminder.syncId);
            } else {
              throw HttpException(e.message);
            }
          }
        }
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> createReminder({
    String? shopId,
    required String visitId,
    required String remarks,
    required String date,
    required String syncId,
    required String token,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.host}/reminders');
      Object body;
      if (shopId != null) {
        body = {
          'shop': shopId,
          'visit': visitId,
          'remarks': remarks,
          'date': date,
          'syncId': syncId,
        };
      } else {
        body = {
          'visit': visitId,
          'remarks': remarks,
          'date': date,
          'syncId': syncId,
        };
      }

      http.Response response = await http.post(
        url,
        headers: {
          "authorization": "Bearer $token",
        },
        body: body,
      );

      if (response.statusCode != 201) {
        if (response.statusCode == 501) {
          throw HttpException("EXIST");
        } else {
          throw HttpException(json.decode(response.body)['message']);
        }
      } else {
        return true;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future syncImages() async {
    /* 
      syncImages function is used for upload all images of visits and shops which is created in offline mode 

    */
    Box<UserModel> userModel = Hive.box<UserModel>(AppConfig.USERMODEL);
    if (userModel.isEmpty) {
      return true;
    }
    Box<ImageModel> imageModelBox = Hive.box<ImageModel>(AppConfig.IMAGE_MODEL);
    try {
      List<ImageModel> images = imageModelBox.values.toList();
      if (images.isNotEmpty) {
        /* 
          This will execute if images is exist in local database for syncing....
          This block will sync image one by one and after syncing done all images will be 
          removed from local databse.
        */

        // int i is used for indexing. with the help of this index we can remove image from local database after image upload
        for (ImageModel imageModel in images) {
          try {
            /* 

              we can upload images of visits or shops using uploadVisitImage function 

            */

            await uploadVisitImage(
              imagePath: imageModel.imagePath,
              shopId: imageModel.shopId,
              visitId: imageModel.visitId,
              token: userModel.getAt(0)!.token as String,
            );

            /* Deleting image from local database */

            await imageModelBox.delete(imageModel.syncId);
            /* Increasing Index value for images */
          } on HttpException catch (e) {
            /* Catching HttpException error and throwing new HttpException */
            throw HttpException(e.message);
          } catch (e) {
            /* Throwing exception */
            rethrow;
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future uploadVisitImage({
    required String imagePath,
    String? visitId,
    String? shopId,
    required String token,
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
      request.headers['authorization'] = 'Bearer $token';
      if (visitId != null) request.fields['visitId'] = visitId;

      if (shopId != null) request.fields['shopId'] = shopId;
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

  syncMeetings() async {
    try {
      /* 
        Filtering meetings which are not synced and 
        which are not cancelled
      */
      ('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
      Box<UserModel> userModel = Hive.box<UserModel>(AppConfig.USERMODEL);
      if (userModel.isEmpty) return true;
      Box<MeetingModel> meetingModelBox =
          Hive.box<MeetingModel>(AppConfig.MEETING_MODEL);
      List<MeetingModel> pendingMeetings = meetingModelBox.values
          .where((element) => element.synced == false)
          .toList();

      ('pendingMeetings ${pendingMeetings.length}');

      /* 
        checking if there is any pending meeting or not
      */

      if (pendingMeetings.isNotEmpty) {
        ('Pending Meestings are not empty');
        /* 
          If there is any pending meeting then we will
          loop through all pending meetings and will
          send request to server for each meeting
        */
        ('Creating Meetings');
        for (MeetingModel meeting in pendingMeetings) {
          ('Creating Meeting ${meeting.syncId}');
          try {
            ('Meeting creation started');
            await createMeetings(
              meeting: meeting,
              meetingModelBox: meetingModelBox,
              token: userModel.getAt(0)!.token as String,
            );
            ('Meeting Createting endes');
          } on HttpException catch (e) {
            ('Http Exception error in creating meeting ');
            (e);
            return true;
          } catch (e) {
            ('Unexpected error in creating meeting');
            (e);
            return true;
          }
        }
        return true;
      } else {
        /* Else we will just return */
        return true;
      }
    } catch (e) {
      ('Unexpected error in creating ABC');
      (e);
      return true;
    }
  }

  Future createMeetings({
    required MeetingModel meeting,
    required Box<MeetingModel> meetingModelBox,
    required String token,
  }) async {
    try {
      /* 
        Checking if meeting have requested user id or not.
      */
      if (meeting.requestedUser != null) {
        ('Meeting have requested user');

        var body = {
          'date': meeting.date.toString(),
          'requestedUser': meeting.requestedUser.toString(),
          'remarks': meeting.remarks.toString(),
          'shop': meeting.shop!.sId,
          'strength': meeting.strength.toString(),
          'gift': meeting.gift.toString(),
          'syncId': meeting.syncId,
        };
        ('Everythig is fine');
        (body);
        ('Now Moving to http request');
        http.Response response = await http.post(
          Uri.parse('${AppConfig.host}/meetings/mistri'),
          headers: {
            'authorization': 'Bearer $token',
          },
          body: body,
        );

        ('Http request done');
        (response.statusCode);
        (response.body);
        if (response.statusCode == 201) {
          final body = json.decode(response.body);
          /* 
            If meeting is created successfully then we will
            update synced status of meeting to true
          */
          meeting.sId = body['_id'];
          meeting.synced = true;
          String key =
              '${DateTime.fromMillisecondsSinceEpoch(meeting.date as int).toString().split(' ').first}-${meeting.requestedUser}';
          await meetingModelBox.put(key, meeting);
          ('ing meeting model box length ${meetingModelBox.length}');
        } else {
          if (response.statusCode == 501) {
            meeting.synced = true;

            meetingModelBox.put(
              '${DateTime.fromMillisecondsSinceEpoch(meeting.date as int).toString()}-${meeting.requestedUser}',
              meeting,
            );
            return true;
          } else {
            return true;
          }
        }
      }
    } catch (e) {
      return true;
    }
  }
}
