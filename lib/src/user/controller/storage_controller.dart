// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart' as gcL;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/PermissionManager.dart';
import 'package:marketing/src/admin/models/group_item.dart';
import 'package:marketing/src/user/chat/models/message.model.dart';
import 'package:marketing/src/user/models/LatLon.dart';
import 'package:marketing/src/user/models/attendanceData.dart';
import 'package:marketing/src/user/models/create_odometer.dart';
import 'package:marketing/src/user/models/create_reminder.dart';
import 'package:marketing/src/user/models/create_visit.dart';
import 'package:marketing/src/user/models/deviceInfo.dart';
import 'package:marketing/src/user/models/image_model.dart';
import 'package:marketing/src/user/models/meetings/meeting_model.dart';
import 'package:marketing/src/user/models/meetings/meeting_user.dart';
import 'package:marketing/src/user/models/odometers.dart';
import 'package:marketing/src/user/models/reminder_model.dart';
import 'package:marketing/src/user/models/shopCreate.dart';
import 'package:marketing/src/user/models/shop_model.dart';
import 'package:marketing/src/user/models/teams_model.dart';
import 'package:marketing/src/user/models/types.dart';
import 'package:marketing/src/user/models/user_model.dart';
import 'package:marketing/src/user/models/user_notification.dart';
import 'dart:math' as math;
import 'package:marketing/src/user/models/visit_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageController extends GetxController {
  Rx<UserModel> userModel = UserModel().obs;
  RxList userNotification = [].obs;
  RxBool notificationLoading = false.obs;
  RxList shops = [].obs;
  RxString odoMeter = AppConfig.NOTMARKED.obs;
  late Box<UserModel> userBox;
  late Box<Shops> shopBox;
  late Box<Shops> personalShopBox;
  late Box<AttendanceData> attendanceBox;
  late Box<Odometers> odometerBox;
  late Box<UserTeam> userteamBox;
  late Box<UserNotification> userNotificationBox;
  late Box<VisitModel> visitModelBox;
  late Box<Reminders> reminderBox;
  late Box<CreateOdometerModel> createOdometerBox;
  late Box<ShopCreate> shopCreateBox;
  late Box<VisitType> visitTypeBox;
  late Box<CreateVisit> createVisitBox;
  late Box<CreateReminder> createReminderBox;
  late Box<ImageModel> imageModelBox;
  late Box<MeetingUser> meetingUserBox;
  late Box<MeetingModel> meetingModelBox;
  late Box<Message> messageBox;

  List<GroupItem> groups = [];
  RxInt totalVisits = 0.obs;
  RxBool isLoggingOut = false.obs;
  RxBool locationState = false.obs;
  String latLong = "N/A";
  String previousRoute = 'N/A';

  RxList<String> gettingPermisson = <String>[].obs;

  setPermission(List<String> permission) {
    gettingPermisson.value = permission;
    gettingPermisson.refresh();
  }

  RxBool isTeam = false.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  init() async {
    meetingModelBox = Hive.box<MeetingModel>(AppConfig.MEETING_MODEL);
    userBox = Hive.box<UserModel>(AppConfig.USERMODEL);
    shopBox = Hive.box<Shops>(AppConfig.SHOP_MODEL);
    personalShopBox = Hive.box<Shops>(AppConfig.PERSONAL_SHOP);
    attendanceBox = Hive.box<AttendanceData>(AppConfig.ATTENDANCE);
    odometerBox = Hive.box<Odometers>(AppConfig.ODOMETERS);
    userteamBox = Hive.box<UserTeam>(AppConfig.USER_TEAM);
    userNotificationBox =
        Hive.box<UserNotification>(AppConfig.USER_NOTIFICATION);
    visitModelBox = Hive.box<VisitModel>(AppConfig.VISIT_MODEL);
    reminderBox = Hive.box<Reminders>(AppConfig.REMINDER_MODEL);
    createOdometerBox =
        Hive.box<CreateOdometerModel>(AppConfig.CREATE_ODOMETER);
    shopCreateBox = Hive.box<ShopCreate>(AppConfig.SHOP_CREATE);
    visitTypeBox = Hive.box<VisitType>(AppConfig.VISIT_TYPE);
    createVisitBox = Hive.box<CreateVisit>(AppConfig.VISIT_CREATE_DB);
    createReminderBox = Hive.box<CreateReminder>("CREATE_REMINDER_BOX");
    imageModelBox = Hive.box<ImageModel>(AppConfig.IMAGE_MODEL);
    meetingUserBox = Hive.box<MeetingUser>(AppConfig.MEETING_USERS);
    messageBox = Hive.box<Message>(AppConfig.CHAT_DATABASE);
    getOdometerStatus();
    gcL.Geolocator.getServiceStatusStream().listen((event) {
      if (event == gcL.ServiceStatus.disabled) {
        locationState.value = false;
        previousRoute = Get.currentRoute;
        Get.toNamed(AppConfig.LOCATION_ERROR_SCREEN);
      } else {
        locationState.value = true;
        Get.offAndToNamed(previousRoute);
      }
    });
  }

  setLatLong({required String latlong}) {
    latLong = latlong;
  }

  setGroups({required List<GroupItem> groups}) {
    this.groups = groups;
  }

  Future<bool> setMeetingsInMeetingModel(
      {required Map<String, MeetingModel> meetings}) async {
    try {
      meetings.forEach((key, value) {
        meetingModelBox.put(key, value);
      });
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> setMeetingsUsers(
      {required Map<String, MeetingUser> users}) async {
    await meetingUserBox.putAll(users);
    return true;
  }

  Future<Map<String, String>> getHeaders() async {
    PermissionManager permissionManager = PermissionManager();
    MyDeviceInfo myDeviceInfo =
        await getDeviceInfo(userId: "N/A", token: "N/A");
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Permission locationPermission = Permission.location;
    Permission cameraPermission = Permission.camera;
    Permission manageExternalStorage = Permission.manageExternalStorage;
    Permission sms = Permission.sms;
    List data = [
      {"key": "CAMERA", "value": await cameraPermission.isGranted},
      {"key": "LOCATION", "value": await locationPermission.isGranted},
      {
        "key": "EXTERNAL_STORAGE",
        "value": await manageExternalStorage.isGranted
      },
      {
        "key": "MICROPHONE",
        "value": await Permission.microphone.isGranted,
      },
      {"key": "SMS", "value": await sms.isGranted},
    ];
    if (latLong == "N/A") {
      latLong = await gcL.Geolocator.getCurrentPosition()
          .then((value) => "${value.latitude},${value.longitude}");
    }
    int level = await permissionManager.getBatteryLevel();
    return {
      "Authorization": "Bearer ${userModel.value.token}",
      "Accept": "application/json",
      "Content-Type": "application/json",
      "location": latLong,
      "device": myDeviceInfo.deviceName,
      "permissions": json.encode(data),
      "app_name": packageInfo.appName,
      "package_name": packageInfo.packageName,
      "app_version": "${packageInfo.version}+${packageInfo.buildNumber}",
      "app_buildNumber": packageInfo.buildNumber,
      "battery": level.toString(),
    };
  }

  getNearByOfflineShops({
    required LatLong origin,
    required double radius,
  }) async {
    List<Shops> shops = shopBox.values.toList();
    List<Shops> nearby = [];
    for (var element in shops) {
      double distance = getDistance(
        startPoint: LatLong(
          longitude: element.location!.coordinates![0],
          latitude: element.location!.coordinates![1],
        ),
        endPoint: origin,
      );

      if (distance <= radius) {
        nearby.add(element);
      }
    }

    for (ShopCreate shopCreate in shopCreateBox.values.toList()) {
      double distance = getDistance(
        startPoint: LatLong(
          longitude:
              double.parse(shopCreate.locationModel!.longitude.toString()),
          latitude: double.parse(shopCreate.locationModel!.latitude.toString()),
        ),
        endPoint: origin,
      );
      print(distance);
      if (distance <= radius) {
        nearby.add(
          Shops(
            sId: shopCreate.id,
            name: shopCreate.name,
            location: Locations(type: 'Point', coordinates: [
              double.parse(shopCreate.locationModel!.latitude.toString()),
              double.parse(shopCreate.locationModel!.longitude.toString()),
            ]),
            address: shopCreate.shopAddress,
            phone: shopCreate.shopPhone,
            email: shopCreate.shopEmail,
            mapAddress: shopCreate.mapAddress,
            ownerName: shopCreate.shopOwner,
            pincode: shopCreate.shopPincode,
            profile: Profile(
              thumbnail: "N/A",
              url: "N/A",
            ),
            status: "NEW",
            uploaded: false,
          ),
        );
      }
    }
    return nearby;
  }

  Future<bool> setVisitTypesInLocal({
    required List<VisitType> visitTypes,
  }) async {
    for (VisitType visitType in visitTypes) {
      visitTypeBox.put(visitType.sId, visitType);
    }
    return true;
  }

  Future<List<VisitType>> getVisitTypesFromLocal() async {
    print(visitTypeBox.values.length);
    return visitTypeBox.values.toList();
  }

  Future<List> getProducts() async {
    try {
      Box products = await Hive.openBox<List>('products');
      return products.get('product', defaultValue: []);
    } catch (e) {
      rethrow;
    }
  }

  Future<List> getBrands() async {
    Box brands = await Hive.openBox<List>('brands');
    return brands.get('brands', defaultValue: []);
  }

  Future<bool> saveProducts(List<String> products) async {
    Box productsBox = await Hive.openBox<List>('products');
    productsBox.clear();
    productsBox.put('product', products);
    productsBox.close();
    return true;
  }

  Future<bool> saveBrands(List<String> brands) async {
    Box brandsBox = await Hive.openBox<List>('brands');
    brandsBox.clear();
    brandsBox.put('brands', brands);
    brandsBox.close();
    return true;
  }

  clearProductsAndBrands() async {
    Box productsBox = await Hive.openBox<List>('products');
    Box brandsBox = await Hive.openBox<List>('brands');
    productsBox.clear();
    brandsBox.clear();
  }

  Future<ShopCreate> setShopCreateBox({
    required ShopCreate shopCreate,
  }) async {
    try {
      /* 
        This function will catch ShopCreate Object and create an unique SyncId for it
        then it will save it in the local database

      */
      shopCreate.id =
          ('${userModel.value.user!.sId}/shop/${DateTime.now().millisecondsSinceEpoch}')
              .toString();
      await shopCreateBox.put(shopCreate.id, shopCreate);
      return shopCreate;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> setCreateVisitBox({
    required CreateVisit createVisit,
  }) async {
    try {
      /* 
      Below code will create an id for the visit which will be used to identify the visit in the local database
      */

      createVisit.syncId =
          ('${userModel.value.user!.sId}/visit/${DateTime.now().millisecondsSinceEpoch}')
              .toString();
      if (createVisit.createReminder != null) {
        /* 
        createVisit.createReminder!.syncId =
            ('${userModel.value.user!.sId}/reminder/${DateTime.now().millisecondsSinceEpoch}')
                .toString(); 
          

          This will generate unique id for each reminder and will be used to sync with server. 
        */
        createVisit.createReminder!.syncId =
            '${userModel.value.user!.sId}/reminder/${DateTime.now().millisecondsSinceEpoch}';
        createVisit.createReminder!.visit = createVisit.syncId;
      }

      /* 
         Storing the visit in the local database
      */
      await createVisitBox.put(createVisit.syncId, createVisit);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CreateVisit>> getCreateVisitBox(
      {required bool withoutShop}) async {
    try {
      return createVisitBox.values
          .where((element) => element.withOutShop == withoutShop)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  double getDistance({
    required LatLong startPoint,
    required LatLong endPoint,
  }) {
    const double R = 6371 * 1000;
    double dlat = (endPoint.latitude - startPoint.latitude) * (3.14 / 180);
    double dlng = (endPoint.longitude - startPoint.longitude) * (3.14 / 180);
    double lat1 = startPoint.latitude * 3.14 / 180;
    double lat2 = endPoint.latitude * 3.14 / 180;
    final x = math.sin(dlat / 2) * math.sin(dlat / 2) +
        math.sin(dlng / 2) *
            math.sin(dlng / 2) *
            math.cos(lat1) *
            math.cos(lat2);

    final y = 2 * math.atan2(math.sqrt(x), math.sqrt(1 - x));
    return R * y;
  }

  Future<String> getOdometerStatus() async {
    Box box = await Hive.openBox('odometer');
    odoMeter.value = box.get(getTodayDate(), defaultValue: AppConfig.NOTMARKED);
    return odoMeter.value;
  }

  addDataToOdoMeter({required CreateOdometerModel createOdometerModel}) async {
    odometerBox.clear();
    createOdometerBox.put('attendance', createOdometerModel);
  }

  CreateOdometerModel? getDataToOdoMeter() {
    return createOdometerBox.get('attendance');
  }

  deleteDataToOdoMeter() {
    createOdometerBox.delete('attendance');
  }

  setOdometerStatus(String status) async {
    Box box = await Hive.openBox('odometer');
    box.put(getTodayDate(), status);
    odoMeter.value = status;
  }

  String getTodayDate() {
    DateTime date = DateTime.now();
    String today = "${date.year}-${date.month}-${date.day}";
    return today;
  }

  changeTeamvalue({
    required bool value,
  }) {
    isTeam.value = value;
  }

  setVisitsData({required List<VisitModel> visits}) async {
    Map<String, VisitModel> visiyMap = {};
    for (var element in visits) {
      visiyMap[element.sId as String] = element;
    }
    visitModelBox.putAll(visiyMap);
  }

  setReminder({
    required List<Reminders> reminders,
  }) async {
    Map<String, Reminders> reminderMap = {};
    for (var element in reminders) {
      reminderMap[element.sId as String] = element;
    }
    reminderBox.putAll(reminderMap);
  }

  Future<String> getLastTimeStamp() async {
    Box timeStamp = await Hive.openBox('lasttime');
    String val = await timeStamp.get('lasttime') ?? '0';
    return val;
  }

  Future<String> getAuthorizedSim() async {
    Box timeStamp = await Hive.openBox('sim');
    String val = await timeStamp.get('sim') ?? '0';
    return val;
  }

  Future<void> setAuthorizedSim({
    required String value,
  }) async {
    print('Setting up authroized sim details');
    print(value);
    Box timeStamp = await Hive.openBox('sim');
    await timeStamp.put('sim', value);
  }

  Future<void> setLastTimeStamp({
    required String value,
  }) async {
    Box timeStamp = await Hive.openBox('lasttime');
    await timeStamp.put('lasttime', value);
  }

  Future<String> getChatsLastTimeStamp() async {
    Box timeStamp = await Hive.openBox('clasttime');
    String val = await timeStamp.get('clasttime') ?? '0';
    return val;
  }

  Future<void> setChatsLastTimeStamp({
    required String value,
  }) async {
    Box timeStamp = await Hive.openBox('clasttime');
    await timeStamp.put('clasttime', value);
  }

  setMessage({required Map<String, Message> message}) async {
    await messageBox.putAll(message);
  }

  Future<bool> setShopsInDB({required Shops shops}) async {
    try {
      print(shops.sId);
      await shopBox.put(shops.sId, shops);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setOdometersInBox({
    required String key,
    required Odometers odometers,
  }) async {
    try {
      await odometerBox.put(key, odometers);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int?> getShopLength() async {
    try {
      return shopBox.length;
    } catch (e) {
      rethrow;
    }
  }

  setTotalVisit({
    required int value,
  }) async {
    totalVisits.value = value;
  }

  void setShops({required List shops}) {
    this.shops.value = shops;
  }

  setNotificationLoading({required bool value}) {
    notificationLoading.value = value;
  }

  int getCount() {
    int count = 0;
    for (var element in userNotification) {
      if (element.read == false) {
        count++;
      }
    }
    return count;
  }

  Future<UserModel?> getToken() async {
    try {
      UserModel? usermodel = userBox.get('profile');
      if (usermodel == null) {
        return null;
      } else {
        userModel.value = usermodel;
        return usermodel;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> removetoken() async {
    try {
      isLoggingOut.value = true;
      userBox.clear();
      shopBox.clear();
      personalShopBox.clear();
      attendanceBox.clear();
      odometerBox.clear();
      userteamBox.clear();
      userNotificationBox.clear();
      visitModelBox.clear();
      reminderBox.clear();
      createOdometerBox.clear();
      visitTypeBox.clear();
      clearProductsAndBrands();
      setLastTimeStamp(value: '0');
      isLoggingOut.value = false;
      return true;
    } catch (e) {
      isLoggingOut.value = false;
      return false;
    }
  }

  setUsermodel({required UserModel userModel}) async {
    try {
      this.userModel.value = userModel;
      this.userModel.value = userModel;
      await userBox.put('profile', userModel);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString(
          'userId', userModel.user!.sId ?? 'NULL');
    } catch (e) {
      rethrow;
    }
  }

  setUser({required User user}) async {
    try {
      UserModel userModel = UserModel(
        token: this.userModel.value.token,
        user: user,
      );
      this.userModel.value = userModel;
      await userBox.put('profile', userModel);
    } catch (e) {
      rethrow;
    }
  }

  Future setTeams({
    required UserTeam userTeam,
  }) async {
    await userteamBox.put(userTeam.sId, userTeam);
  }

  Future<bool> clearTeams() async {
    try {
      await userteamBox.clear();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getAddress({required LatLong latLong}) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(latLong.latitude, latLong.longitude);

    return '${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].postalCode}, ${placemark[0].country}';
  }

  setUserProfile({required User user}) async {
    try {
      userModel.value = UserModel(user: user, token: userModel.value.token);
      await userBox.put('profile', userModel.value);
    } catch (e) {
      rethrow;
    }
  }

  setPersonalShops({required List<Shops> shops}) async {
    try {
      await personalShopBox.clear();
      for (var element in shops) {
        await personalShopBox.put(element.sId, element);
      }
    } catch (e) {
      rethrow;
    }
  }

  setUserNotification({
    required List<UserNotification> userNotification,
  }) async {
    this.userNotification.value = userNotification;
    for (int i = 0; i < userNotification.length; i++) {
      await userNotificationBox.put(
          userNotification[i].sId, userNotification[i]);
    }
  }

  loadUserNotification() {
    userNotification.value = userNotificationBox.values.toList();
  }

  markReadNotificationById({required String id}) {
    UserNotification? notification = userNotificationBox.get(id);
    if (notification != null) {
      notification.read = true;
      userNotificationBox.put(id, notification);
      userNotification.value = userNotificationBox.values.toList();
    }
  }

  deleteNotifications(List<String> ids) {
    userNotificationBox.deleteAll(ids);
    userNotification.value = userNotificationBox.values.toList();
  }

  setAttandanceData({
    required AttendanceData attendanceData,
  }) async {
    try {
      await attendanceBox.put('today', attendanceData);
    } catch (e) {
      rethrow;
    }
  }

  Future<MyDeviceInfo> getDeviceInfo(
      {required String userId, required String token}) async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return MyDeviceInfo(
        deviceId: androidInfo.id as String,
        deviceName: androidInfo.model as String,
        deviceType: 'android',
        userId: userId,
        token: token,
      );
    } else {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      return MyDeviceInfo(
        deviceId: iosInfo.identifierForVendor as String,
        deviceName: iosInfo.utsname.machine as String,
        deviceType: 'ios',
        userId: userId,
        token: token,
      );
    }
  }

  Future<MyDeviceInfo?> getMyDeviceInfo() async {
    String token = await FirebaseMessaging.instance.getToken() ?? "";
    if (token != null || token != "") {
      MyDeviceInfo myDeviceInfo = await getDInfo(token: token);
      return myDeviceInfo;
    } else {
      return null;
    }
  }

  Future<MyDeviceInfo> getDInfo({String? userId, required String token}) async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return MyDeviceInfo(
        deviceId: androidInfo.id as String,
        deviceName: androidInfo.model as String,
        deviceType: 'android',
        userId: userId,
        token: token,
      );
    } else {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      return MyDeviceInfo(
        deviceId: iosInfo.identifierForVendor as String,
        deviceName: iosInfo.utsname.machine as String,
        deviceType: 'ios',
        userId: userId,
        token: token,
      );
    }
  }

  bool get isCreateUser => gettingPermisson.contains('CREATE_USER');
  bool get isEditUser => gettingPermisson.contains('UPDATE_USER');
  bool get isDeleteUser => gettingPermisson.contains('DELETE_USER');
  bool get isCreateOdometer => gettingPermisson.contains('CREATE_ODOMETER');
  bool get isEditOdometer => gettingPermisson.contains('UPDATE_ODOMETER');
  bool get isEditAttendance => gettingPermisson.contains('UPDATE_ATTENDANCE');
  bool get isShowMistriMeetings =>
      gettingPermisson.contains('MISTRI_MEETING_OFFICER');
  bool get isCreateMistriiMeetings =>
      gettingPermisson.contains('CREATE_MISTRI_MEETING');
  bool get isEditMistriMeetings =>
      gettingPermisson.contains('UPDATE_MISTRI_MEETING');
  bool get isDeleteMistriMeetings =>
      gettingPermisson.contains('DELETE_MISTRI_MEETING');
  bool get isCreateConstants => gettingPermisson.contains('CREATE_CONSTANTS');
  bool get isEditConstants => gettingPermisson.contains('UPDATE_CONSTANTS');
  bool get isDeleteConstants => gettingPermisson.contains('DELETE_CONSTANTS');
  bool get isListConstants => gettingPermisson.contains('LIST_CONSTANTS');
  bool get isDeletedUsers => gettingPermisson.contains('DELETED_USER');
  bool get isViewPermissions => gettingPermisson.contains('VIEW_PERMISSIONS');
  bool get isViewConstants => gettingPermisson.contains('VIEW_CONSTANTS');
  bool get isDdocUser => gettingPermisson.contains('DDOC_USER');
  bool get isDeleteOdometer => gettingPermisson.contains('DELETE_ODOMETER');
}
