library init;

import 'dart:developer';
import 'dart:io';

import 'package:process_run/shell.dart';

import 'commons.dart';

part 'init/extensions.dart';

part 'init/files_and_folders.dart';

part 'init/files_templates.dart';

part 'init/init_helper.dart';

class Chaotic {
  final _version = 1;
  static bool useGit = true;

  static Future<void> addPackage(Package package) async {
    await Shell().run('flutter pub add ${enumToString(package)}');
    await Shell().run('flutter pub get');
  }

  static Future<void> init() async {
    await _createProjectStructure();
    await _addPackages();
    await _initYaml();
  }

  static Future<void> newScreen(String screenName) async {
    //init folders and files
    final newScreenFolder = _getDir(screenName, _screenFolder);
    final newScreenFile = _getFile('$screenName.dart', newScreenFolder);
    final newProviderFile =
        _getFile('${screenName}_provider.dart', newScreenFolder);
    //join folders and files in one structure map
    final newScreenStructure = {
      newScreenFolder: [
        newScreenFile,
        newProviderFile,
      ],
    };
    if (newScreenFile.existsSync()) {
      print('$screenName is exists before');
      return;
    }
    //creating a structure
    await _createStructureFromMap(newScreenStructure);
    //write an export files
    await _exportNewScreen(screenName);
    //write template screen and provider
    await newScreenFile.writeAsString(_newScreenTemp(screenName.toCamelcase()));
    await newProviderFile
        .writeAsString(_newProviderTemp(screenName.toCamelcase()));
    await git('add new screen $screenName');
  }

  static Future<void> newCommon(String commonName) async {
    final newCommonFile = _getFile('$commonName.dart', _commonFolder);
    if (newCommonFile.existsSync()) {
      print('$commonName is exists before');
      return;
    }
    await _exportNewCommon(commonName);
    await git('new common $commonName');
  }

  static Future<void> newWidget(String widgetName) async {
    final newWidgetFile = _getFile('$widgetName.dart', _widgetFolder);
    if (newWidgetFile.existsSync()) {
      print('$widgetName is exists before');
      return;
    }
    await newWidgetFile.writeAsString(_newWidgetTemp(widgetName.toCamelcase()));
    await _exportNewWidget(widgetName);
    await git('new widget $widgetName');
  }

  static Future<void> newModel(String modelName) async {
    final newModelFile = _getFile('$modelName.dart', _modelFolder);
    if (newModelFile.existsSync()) {
      print('$modelName is exists before');
      return;
    }
    newModelFile.writeAsString(_modelTemp(modelName));
    await _exportNewModel(modelName);
    await git('new model $modelName');
  }

  static Future<void> newAsset(String newAsset) async {
    final newImageFolder = _getDir(newAsset, _imagesFolder);
    if (newImageFolder.existsSync()) {
      print('$newAsset is exists before');
      return;
    }
    newImageFolder.create();

    final yamlContent = await _yamlFile.readAsString();
    final newYamlContent = yamlContent.replaceAll('''assets:''', '''
assets:
    - assets/images/$newAsset/''');
    await _yamlFile.writeAsString(newYamlContent);
    await Shell().run('''flutter pub get''');
    await git('new asset $newAsset');
  }

  static Future<void> newService(String serviceName) async {
    final newServiceFile = _getFile('$serviceName.dart', _serviceFolder);
    if (newServiceFile.existsSync()) {
      print('$serviceName is exists before');
      return;
    }

    await newServiceFile
        .writeAsString(_newServiceTemp(serviceName.toCamelcase()));
    await _exportNewService(serviceName);
    await git('new service $serviceName');
  }

  static Future<void> newLocalModel(
    String localModelName,
    String screenName,
  ) async {
    final screenFolder = _getDir(screenName, _screenFolder);
    final localModelFolder = _getDir('local_model', screenFolder);
    final localModelsFile = _getFile('local_models.dart', localModelFolder);
    if (!screenFolder.existsSync()) await newScreen(screenName);
    if (!localModelFolder.existsSync()) await localModelFolder.create();
    final newModelFile = _getFile(
      '$localModelName.dart',
      localModelFolder,
    );
    if (newModelFile.existsSync()) {
      print('$localModelName is exists before');
      return;
    }
    await localModelsFile.writeAsString(
      '''\nexport '$localModelName.dart';''',
      mode: FileMode.append,
    );
    await newModelFile.writeAsString(_modelTemp(localModelName));
    await git('new local model $localModelName, $screenName');
  }

  static Future<void> newLocalWidget(
      String localWidgetName, String screenName) async {
    final screenFolder = _getDir(screenName, _screenFolder);
    final localWidgetFolder = _getDir('local_widget', screenFolder);
    if (!screenFolder.existsSync()) await newScreen(screenName);
    if (!localWidgetFolder.existsSync()) await localWidgetFolder.create();
    final localWidgetsFile = _getFile(
      'local_widgets.dart',
      localWidgetFolder,
    );
    final newWidgetFile = _getFile(
      '$localWidgetName.dart',
      localWidgetFolder,
    );
    if (newWidgetFile.existsSync()) {
      print('$localWidgetName is exists before');
      return;
    }
    await localWidgetsFile.writeAsString(
      '''\nexport '$localWidgetName.dart';''',
      mode: FileMode.append,
    );
    await newWidgetFile
        .writeAsString(_newWidgetTemp(localWidgetName.toCamelcase()));
    await git('new local widget $localWidgetName, $screenName');
  }

  static Future<void> git(String actionName) async {
    if (!useGit) return;
    await Shell().run('''git add .''');
    await Shell().run('''git commit -m  "$actionName"''');
    await Shell().run('''git push''');
  }
}

enum Package {
// UI
  flutter_svg,
  dotted_border,
  pinput,
  toggle_switch,
  sizer,
  bot_toast,
  flutter_spinkit,
  cached_network_image,
// Device Info
  platform_device_id,
  package_info,
// State Management
  get,
  provider,
// API requests and Connectivity
  dio,
  path_provider,
// Storage
  shared_preferences,
// Date
  hijri_picker,
  intl,
// Firebase And notification
  firebase_messaging,
  flutter_local_notifications,
// Google
  google_maps_flutter,
// Launcher and Pickers
  image_picker,
  url_launcher,
// Translation
  easy_localization,
// Other
  introduction_screen,
  connectivity,
}
