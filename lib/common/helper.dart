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
