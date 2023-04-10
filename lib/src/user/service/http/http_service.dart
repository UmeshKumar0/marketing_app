import 'package:get/get.dart';
import 'package:marketing/src/AppConfig.dart';
import 'package:http/http.dart' as http;

class HttpService extends GetxService {
  late String _baseUrl;

  @override
  void onInit() {
    super.onInit();
    _baseUrl = AppConfig.host;
    print('HttpService onInit');
  }

  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    try {
      return await http.get(Uri.parse('$_baseUrl/$url'), headers: headers);
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> post(String url,
      {Map<String, String>? headers, Map<String, String>? body}) async {
    try {
      return await http.post(Uri.parse('$_baseUrl/$url'),
          headers: headers, body: body);
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> put(String url,
      {Map<String, String>? headers, Map<String, String>? body}) async {
    try {
      return await http.put(Uri.parse('$_baseUrl/$url'),
          headers: headers, body: body);
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> delete(String url,
      {Map<String, String>? headers}) async {
    try {
      return await http.delete(Uri.parse('$_baseUrl/$url'), headers: headers);
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> patch(String url,
      {Map<String, String>? headers, Map<String, String>? body}) async {
    try {
      return await http.patch(Uri.parse(_baseUrl + url),
          headers: headers, body: body);
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> multipart(String url,
      {Map<String, String>? headers,
      Map<String, String>? body,
      List<http.MultipartFile>? files}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl + url));
      request.headers.addAll(headers ?? {});
      request.fields.addAll(body ?? {});
      request.files.addAll(files ?? []);
      final res = await request.send();
      return http.Response.fromStream(res);
    } catch (e) {
      rethrow;
    }
  }
}
