part of chaotic;

Future<void> _init_analysis_options() async {
  final analysis_options = '''include: package:lint/analysis_options.yaml

linter:
  rules:
    non_constant_identifier_names: false

analyzer:
  errors:
    unused_import: warning''';

  final analysis_options_file = File('./analysis_options.yaml');
  if (analysis_options_file.existsSync()) return;
  await analysis_options_file.create();
  await analysis_options_file.writeAsString(analysis_options);
}

Future<void> _create_project_structure() async {
  //assets
  final assets = Directory('./assets');
  final images = _getDir('images', assets);
  final fonts = _getDir('fonts', assets);
  final lang = _getDir('lang', assets);
  final ar = _getFile('ar.js', lang);
  final en = _getFile('en.js', lang);
  //src
  final src = Directory('./lib/src');
  //commons
  final common = _getDir('common', src);
  final commons = _getFile('commons.dart', common);
  final color = _getFile('color.dart', common);
  final path_and_apis = _getFile('path_and_apis.dart', common);
  //screens
  final screen = _getDir('screen', src);
  final screens = _getFile('screens.dart', screen);
  //widgets
  final widget = _getDir('widget', src);
  final widgets = _getFile('widgets.dart', widget);
  //services
  final service = _getDir('service', src);
  final services = _getFile('services.dart', service);
  //models
  final model = _getDir('model', src);
  final models = _getFile('models.dart', model);

  final structure = {
    assets: [
      images,
      fonts,
      {
        lang: [
          ar,
          en,
        ],
      }
    ],
    src: [
      {
        common: [
          commons,
          color,
          path_and_apis,
        ]
      },
      {
        screen: [
          screens,
        ]
      },
      {
        widget: [
          widgets,
        ]
      },
      {
        service: [
          services,
        ]
      },
      {
        model: [
          models,
        ]
      }
    ],
  };

  await _create(structure);
  await commons.writeAsString('''export 'color.dart';
export 'path_and_apis.dart';''');
}

Future<void> _add_packages() async {
  final shell = Shell();
  try {
    await shell.run('''
  flutter pub add lint
  flutter pub add bot_toast
  flutter pub add provider
  flutter pub add easy_localization
  flutter pub add shared_preferences
  flutter pub add package_info
  flutter pub add sizer
  flutter pub add flutter_svg
  flutter pub add get
  ''');
  } catch (e) {}
}

Future<void> _init_yaml() async {
  final assets = '''\nassets:
  - assets/lang/
  - assets/images/''';
  final yaml = File('./pubspec.yaml');
  await yaml.writeAsString(assets, mode: FileMode.append);
}

Future<void> _init_main() async {
  final main = '''import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    MultiProvider(
      providers: const [],
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        path: 'assets/lang',
        fallbackLocale: const Locale('en'),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        // home: ,
      ),
    );
  }
}
''';

  final main_file = File('./lib/main.dart');
  if (main_file.existsSync()) return;
  await main_file.writeAsString(main);
}

Future<void> _create(Map structure) async {
  for (final item in structure.entries) {
    await item.key.create();
    if (item.value is List) {
      await _handleList(item.value);
    } else {
      await item.value.create();
    }
  }
}

Future<void> _handleList(List items) async {
  for (final item in items) {
    if (item is Map) {
      await _create(item);
    } else {
      await item.create();
    }
  }
}

Directory _getDir(String name, Directory parent) =>
    Directory(parent.path + '/$name');

File _getFile(String name, Directory parent) => File(parent.path + '/$name');
