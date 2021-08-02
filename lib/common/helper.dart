part of commons;

bool phoneValidation(String? value) {
  return value != null && value.length >= 9;
}

bool passwordValidation(String? value) {
  return value != null && value.length >= 8;
}

bool textValidation(String? value) {
  return value != null && value.isNotEmpty;
}

bool emailValidation(String? value) {
  if (value == null || value.isEmpty) return false;
  const emailRegex =
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  return RegExp(emailRegex).hasMatch(value);
}

bool sameValidation(String? value, String secondValue) {
  return value != null && value == secondValue;
}

void hideStatusBar() {
  SystemChrome.setEnabledSystemUIOverlays([]);
}

void preventLandScapeMode() {
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
}

String enumToString<T>(T value) {
  return value.toString().split('.').last;
}

Future<String> getDeviceName() async {
  String brand = '';
  String id = '';
  if (Platform.isAndroid) {
    final deviceInfo = await PlatformDeviceId.deviceInfoPlugin.androidInfo;
    brand = deviceInfo.device;
    id = deviceInfo.androidId;
  } else {
    final deviceInfo = await PlatformDeviceId.deviceInfoPlugin.iosInfo;
    brand = deviceInfo.model;
    id = deviceInfo.identifierForVendor;
  }

  return '$brand|$id';
}

Future<String?> getDeviceToken() async {
  final firebaseMessaging = FirebaseMessaging.instance;
  if (Platform.isIOS) {
    firebaseMessaging.requestPermission();
    await firebaseMessaging.getNotificationSettings();
  }
  final token = await firebaseMessaging.getToken();
  return token;
}

/// keys => code, number
Future<Map<String, String>> getApplicationVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final code = packageInfo.version;
  final number = packageInfo.buildNumber;
  return {
    'code': code,
    'number': number,
  };
}
