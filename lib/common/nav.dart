part of commons;

Future<dynamic> push<T extends ChangeNotifier>(Widget screen,
    [T? provider]) async {
  return Navigator.of(Get.context!).push(
    MaterialPageRoute(
      builder: (_) {
        return provider != null
            ? ChangeNotifierProvider(create: (_) => provider, child: screen)
            : screen;
      },
    ),
  );
}

void pushReplacement<T extends ChangeNotifier>(Widget screen, [T? provider]) {
  Navigator.of(Get.context!).pushReplacement(
    MaterialPageRoute(
      builder: (_) {
        return provider != null
            ? ChangeNotifierProvider(create: (_) => provider, child: screen)
            : screen;
      },
    ),
  );
}

void pushClear<T extends ChangeNotifier>(Widget screen, [T? provider]) {
  Navigator.of(Get.context!).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) {
        return provider != null
            ? ChangeNotifierProvider(create: (_) => provider, child: screen)
            : screen;
      },
    ),
    (route) => false,
  );
}

Future pop({dynamic result}) async => Navigator.of(Get.context!).pop(result);
