import 'dart:convert';
import 'package:testing_book/constants.dart' as constants;
import 'package:testing_book/models.dart';
import 'package:http/http.dart' as http;
import 'package:device_info/device_info.dart';

Future<Map<String, dynamic>> registerUser(User user) async {
  final response = await http.post(constants.registerUser,
      headers: <String, String>{'Content-type': 'application/json; charset=UTF-8'}, body: jsonEncode(user.toJson()));

  if (response.statusCode != null) {
    var body = jsonDecode(response.body);
    body['statusCode'] = response.statusCode;
    //getting type of the body
    var typeOfBody = body.runtimeType;
    print("ResponseBody: $body");
    return body;
  }
}

Future<Map<String, dynamic>> loginUser(LoginUser loginUser) async {
  DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  var deviceData = getDeviceInfoFuture(await deviceInfoPlugin.androidInfo);

  final response = await http.post(constants.login,
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
        'Android': deviceData['androidId'],
      },
      body: jsonEncode(loginUser.toJson()));

  if (response.statusCode != null) {
    Map<String, dynamic> body = jsonDecode(response.body);
    body['statusCode'] = response.statusCode;
    return body;
  }
}

Future<Map<String, dynamic>> deviceInfo(DeviceInfo deviceInfo) async {
  final response = await http.post(constants.deviceInfo,
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(deviceInfo.toJson()));

  if (response.statusCode != null) {
    Map<String, dynamic> body = jsonDecode(response.body);
    body['statusCode'] = response.statusCode;
    return body;
  }
}

Future<Map<String, dynamic>> deleteUser(int pk) async {
  final response = await http.post(constants.deleteUser,
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'pk': pk}));

  if (response.statusCode != null) {
    Map<String, dynamic> body = jsonDecode(response.body);
    body['statusCode'] = response.statusCode;
    return body;
  }
}

Map<String, dynamic> getDeviceInfoFuture(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'androidId': build.androidId,
    'systemFeatures': build.systemFeatures,
  };
}
