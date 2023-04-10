import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:marketing/src/admin/models/AChat.dart';
import 'package:marketing/src/admin/models/AOdometer.model.dart';
import 'package:marketing/src/admin/models/AShopImage.dart';
import 'package:marketing/src/admin/models/AShopVisit.dart';
import 'package:marketing/src/admin/models/AppHeaders_model.dart';
import 'package:marketing/src/admin/models/Ashop_model.dart';
import 'package:marketing/src/admin/models/KeyData.dart';
import 'package:marketing/src/admin/models/ReportGraph.dart';
import 'package:marketing/src/admin/models/attendance_reportitem.dart';
import 'package:marketing/src/admin/models/attendance_user.dart';
import 'package:marketing/src/admin/models/chatuser_model.dart';
import 'package:marketing/src/admin/models/group_item.dart';
import 'package:marketing/src/admin/models/moProfile.dart';
import 'package:marketing/src/user/controller/http_exception.dart';
import 'package:marketing/src/user/controller/storage_controller.dart';
import 'package:http/http.dart' as http;

class AdminApi extends GetxController {
  late StorageController _storageController;
  StorageController get storageController => _storageController;
  @override
  void onInit() {
    super.onInit();
    _storageController = Get.find<StorageController>();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<AppHeaders> getAppHeaders() async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = await http.get(
        Uri.parse(
            '${AppConfig.host}/dashboard/headers?userFields=name,phone,email,emp_id'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        AppHeaders appHeaders = AppHeaders.fromJson(json.decode(response.body));
        return appHeaders;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAdminVisits({
    required int skip,
    required int limit,
    required String? startDate,
    required String? endDate,
  }) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = await http.get(
        Uri.parse(
            '${AppConfig.host}/visits?skip=$skip&limit=$limit&startDateQuery=$startDate&endDate=$endDate'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        return {
          "total": json.decode(response.body)['count'],
        };
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAdminShops({
    required int skip,
    required int limit,
  }) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = await http.get(
        Uri.parse('${AppConfig.host}/shops?skip=$skip&limit=$limit'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        return {
          "total": json.decode(response.body)['count'],
          "shops": json.decode(response.body)['data'],
        };
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUsers(
      {required int skip, required int limit}) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = await http.get(
        Uri.parse('${AppConfig.host}/users?skip=$skip&limit=$limit'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        return {
          "total": json.decode(response.body)['count'],
          "users": json.decode(response.body)['data'],
        };
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AShop>> getShops({
    required int skip,
    required int limit,
    String? name,
    String? createdAt,
    String? userId,
  }) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();

      String url = '${AppConfig.host}/shops?skip=$skip&limit=$limit';
      if (createdAt != null) {
        url += '&createdAt=$createdAt';
      }
      if (name != null) {
        url += '&name=$name';
      }
      if (userId != null) {
        url += '&userId=$userId';
      }
      http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        List<AShop> shops = [];
        json.decode(response.body)['data'].forEach((shop) {
          shops.add(AShop.fromJson(shop));
        });
        return shops;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AShopImage>> getShopImages({
    required int skip,
    required int limit,
    required String? shopId,
  }) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      http.Response response = await http.get(
        Uri.parse(
            '${AppConfig.host}/images?skip=$skip&limit=$limit&shopId=$shopId'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        List<AShopImage> shopImages = [];
        json.decode(response.body)['data'].forEach((shopImage) {
          shopImages.add(AShopImage.fromJson(shopImage));
        });
        return shopImages;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AShopImage> uploadImage(
      {required String imagePath, required String shopId}) async {
    try {
      http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConfig.host}/images'),
      );
      Map<String, String> headers = await _storageController.getHeaders();
      request.headers.addAll(headers);
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imagePath,
        ),
      );
      request.fields['shopId'] = shopId;

      http.StreamedResponse response = await request.send();
      if (response.statusCode != 201) {
        throw HttpException('Error uploading image');
      } else {
        final respStr = await response.stream.bytesToString();
        return AShopImage.fromJson(json.decode(respStr));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future shopUpdate({
    required Map<String, dynamic> data,
    required String shopId,
  }) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      http.Response response = await http.patch(
        Uri.parse('${AppConfig.host}/shops/$shopId'),
        headers: headers,
        body: data,
      );
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        Fluttertoast.showToast(msg: 'Shop updated successfully');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AShopVisit>> getVisitsOfShop(
      {String? shopId,
      int? skip = 0,
      int? limit = 10,
      String? startDateQuery,
      String? endDateQuery,
      int? sortOrder = 1,
      String? userId,
      String? visitType,
      String? groupId,
      String? search}) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      String url = '${AppConfig.host}/visits?p=a';
      if (shopId != null) {
        url += '&shopId=$shopId';
      }
      if (skip != null) {
        url += '&skip=$skip';
      }
      if (limit != null) {
        url += '&limit=$limit';
      }
      if (startDateQuery != null) {
        url += '&startDateQuery=$startDateQuery';
      }
      if (endDateQuery != null) {
        url += '&endDateQuery=$endDateQuery';
      }
      if (sortOrder != null) {
        url += '&sortOrder=$sortOrder';
      }
      if (userId != null) {
        url += '&userId=$userId';
      }
      if (visitType != null && visitType != 'ALL_VISITS') {
        url += '&type=$visitType';
      }
      if (groupId != null && groupId != 'ALL_GROUPS') {
        url += '&group=$groupId';
      }
      if (search != null && search != "N/A" && search != '') {
        url += '&search=$search';
      }
      print(url);

      http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode != 200) {
        print(response.body);
        throw HttpException(json.decode(response.body)['message']);
      } else {
        List<AShopVisit> visits = [];
        json.decode(response.body)['data'].forEach((visit) {
          visits.add(AShopVisit.fromJson(visit));
        });
        return visits;
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future fetchGroup() async {
    try {
      String url = '${AppConfig.host}/groups';
      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        List<GroupItem> groups = [];
        json.decode(response.body).forEach((group) {
          groups.add(GroupItem.fromJson(group));
        });
        _storageController.setGroups(groups: groups);
        return groups;
      }
    } catch (e) {
      rethrow;
    }
  }

  List<GroupItem> getGroups() {
    print('Working here');
    print(_storageController.groups.length);
    return _storageController.groups;
  }

  Future<Map<String, dynamic>> getOdometers({
    required int skip,
    required int limit,
    required String? startDateQuery,
    required String? endDateQuery,
    required bool pending,
    required String search,
    required List<String> group,
    required bool visitsDetails,
  }) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      String url =
          '${AppConfig.host}/odometers?skip=$skip&limit=$limit&search=$search&web=$visitsDetails&startDateQuery=$startDateQuery&endDateQuery=$endDateQuery';
      if (group.isNotEmpty) {
        url += '&group=${group.join(',')}';
      }
      if (pending) {
        url += '&pending=true';
      }
      print(url);

      headers.remove('Content-Type');
      http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        Map<String, OdoVisit> visits = {};
        /* 
          Here we have 
          {
           "visitObj": {
              "62fdea6cb1a407960db4c138": {
                  "count": 5,
                  "time": "2022-12-09T11:26:28.198Z"
              },
            },
            "data":[<Objectofodometer>]
          }
        */
        final body = json.decode(response.body);
        if (visitsDetails) {
          final v = body['visitObj'];
          /* 
              Now we have 
              final v = {
                  "62fdea6cb1a407960db4c138": {
                    "count": 5,
                    "time": "2022-12-09T11:26:28.198Z"
                  },
              }

              now we will iterate over this and create a map of OdoVisit
          */
          v.forEach((key, value) {
            visits[key] = OdoVisit.fromJson(value);
          });
        }

        List<AOdometer> odometers = [];
        body['data'].forEach((odo) {
          odometers.add(AOdometer.fromJson(odo));
        });

        /* 
          Now we will return a map of odometers and visits
        */

        return {
          'odometers': odometers,
          'visits': visits,
        };
      }
    } catch (e) {
      rethrow;
    }
  }

  Future closeOdometer({
    required String endReading,
    required String imagePath,
    required String odoId,
  }) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      String url = '${AppConfig.host}/odometers/$odoId';
      http.MultipartRequest request =
          http.MultipartRequest('PATCH', Uri.parse(url));
      request.headers.addAll(headers);
      request.fields['endReading'] = endReading;
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      http.StreamedResponse response = await request.send();
      if (response.statusCode != 200) {
        throw HttpException('Any Error');
      } else {
        return true;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future deleteOdometer({required String id}) async {
    try {
      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      http.Response response = await http.delete(
        Uri.parse('${AppConfig.host}/odometers/$id'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        return true;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MOProfile>> getmarketingofficers({
    int? skip,
    int? limit,
    String? role,
    String? blocked,
    String? name,
    String? group,
    required bool single,
    String? userId,
  }) async {
    try {
      String url = single
          ? '${AppConfig.host}/users/$userId'
          : '${AppConfig.host}/users?limit=$limit&skip=$skip';
      if (role != null && role != 'all' && role != 'N/A') {
        url += '&role=$role';
      }
      if (blocked != null && blocked != 'all' && blocked != 'N/A') {
        url += '&status=$blocked';
      }
      if (name != null && name != 'N/A') {
        url += '&search=$name';
      }
      if (group != null && group != 'Select') {
        url += '&group=$group';
      }
      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        if (single) {
          return [MOProfile.fromJson(json.decode(response.body))];
        } else {
          List<MOProfile> mos = [];
          json.decode(response.body)['data'].forEach((mo) {
            mos.add(MOProfile.fromJson(mo));
          });
          return mos;
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AttendanceUser>> getAttendance(
      {required int skip,
      required int limit,
      required String? startDateQuery,
      required String? endDateQuery,
      String? name,
      String? group,
      String? status}) async {
    try {
      String url = '${AppConfig.host}/attendance?limit=$limit&skip=$skip';
      if (startDateQuery != null && startDateQuery != 'N/A') {
        url += '&startDateQuery=$startDateQuery';
      }
      if (endDateQuery != null && endDateQuery != 'N/A') {
        url += '&endDateQuery=$endDateQuery';
      }
      if (name != null && name != 'N/A') {
        url += '&search=$name';
      }
      if (group != null && group != 'Select') {
        url += '&group=$group';
      }
      if (status != null && status != 'Select') {
        url += '&status=$status';
      }
      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        List<AttendanceUser> attendanceUsers = [];
        json.decode(response.body)['data'].forEach((mo) {
          attendanceUsers.add(AttendanceUser.fromJson(mo));
        });
        return attendanceUsers;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AttendanceReportItem>> getattendanceReport() async {
    try {
      String url = '${AppConfig.host}/attendance/reports?day=7';
      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        List<AttendanceReportItem> attendanceReportItems = [];
        json.decode(response.body).forEach((mo) {
          attendanceReportItems.add(AttendanceReportItem.fromJson(mo));
        });
        return attendanceReportItems;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ReportGraph> getReportGraph() async {
    try {
      String url = '${AppConfig.host}/dashboard';
      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        return ReportGraph.fromJson(json.decode(response.body));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getKeys() async {
    try {
      String url = '${AppConfig.host}/constants/keys';
      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        List<String> keys = [];
        json.decode(response.body).forEach((key) {
          keys.add(key);
        });
        return keys;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<KeyData>> getDataOfKeys({required String key}) async {
    try {
      String url = '${AppConfig.host}/constants?key=$key';
      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        List<KeyData> keyData = [];
        json.decode(response.body).forEach((key) {
          keyData.add(KeyData.fromJson(key));
        });
        return keyData;
      }
    } catch (e) {
      rethrow;
    }
  }

  /* this function used for delete user account */
  Future<void> deleteUserAccount({required String id}) async {
    try {
      String url = '${AppConfig.host}/users/$id';
      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      http.Response response =
          await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  /* this function used for create user account */
  Future createUserAccount({
    required Map<String, dynamic> body,
  }) async {
    try {
      String url = '${AppConfig.host}/users';
      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode != 201) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChatUserModel>> getChatUsers() async {
    try {
      String url = '${AppConfig.host}/chats/admin';
      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        if (json.decode(response.body).length == 0) {
          return [];
        } else {
          List<ChatUserModel> chatUsers = [];

          json.decode(response.body).forEach((mo) {
            print(mo);
            chatUsers.add(ChatUserModel.fromJson(mo));
          });
          return chatUsers;
        }
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<AChat>> getChats({
    required String chatId,
    required int skip,
    required int limit
  }) async {
    try {
      String url = '${AppConfig.host}/messages/admin?chatId=$chatId&skip=$skip&limit=$limit';
      Map<String, String> headers = await _storageController.getHeaders();
      headers.remove('Content-Type');
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      } else {
        if (json.decode(response.body).length == 0) {
          return [];
        } else {
          List<AChat> chats = [];

          json.decode(response.body).forEach((mo) {
            print(mo);
            chats.add(AChat.fromJson(mo));
          });
          return chats;
        }
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
