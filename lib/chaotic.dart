import 'dart:io';
import 'package:process_run/shell.dart';

void init() async {
  await _create_project_structure();
  await _add_packages();
}

Future<void> _add_packages() async {
  final shell = Shell();
  try {
    await shell.run('''
  flutter pub add provider
  flutter pub add get
  flutter pub add easy_localization
  flutter pub add shared_preferences
  flutter pub add package_info
  ''');
  } catch (e) {}
}

Future<void> _create_project_structure() async {
  //assats
  final assets = Directory('./assets');
  final images = _getDir('images', assets);
  final fonts = _getDir('fonts', assets);
  final lang = _getDir('langs', assets);
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

  final list = <dynamic>[
    //assets
    assets,
    lang,
    ar,
    en,
    images,
    fonts,
    //src
    src,
    //common
    common,
    commons,
    color,
    path_and_apis,
    //screen
    screen,
    screens,
    //widget
    widget,
    widgets,
    //service
    service,
    services,
    //model
    model,
    models,
  ];

  for (final element in list) {
    await element.create();
  }
}

Directory _getDir(String name, Directory parent) =>
    Directory(parent.path + '/$name');

File _getFile(String name, Directory parent) => File(parent.path + '/$name');
