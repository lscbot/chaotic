library init;

import 'dart:developer';
import 'dart:io';

import 'package:process_run/shell.dart';

part 'init/extensions.dart';
part 'init/files_and_folders.dart';
part 'init/files_templates.dart';
part 'init/init_helper.dart';

Future<void> init() async {
  await _createProjectStructure();
  await _addPackages();
  await _initYaml();
}

Future<void> newScreen(String screenName) async {
  //init folders and files
  final newScreenFolder = _get_dir(screenName, _screen_folder);
  final newScreenFile = _get_file('$screenName.dart', newScreenFolder);
  final newProviderFile =
      _get_file('${screenName}_provider.dart', newScreenFolder);
  //join folders and files in one structure map
  final newScreenStructure = {
    newScreenFolder: [
      newScreenFile,
      newProviderFile,
    ],
  };
  if (newScreenFile.existsSync()) {
    log('$screenName is exists before');
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
}

Future<void> newCommon(String commonName) async {
  final newCommonFile = _get_file('$commonName.dart', _common_folder);
  newCommonFile.create();
  await _exportNewCommon(commonName);
}

Future<void> newWidget(String widgetName) async {
  final newWidgetFile = _get_file('$widgetName.dart', _widget_folder);
  newWidgetFile.create();

  await newWidgetFile.writeAsString(_newWidgetTemp(widgetName.toCamelcase()));
  await _exportNewWidget(widgetName);
}

Future<void> newModel(String modelName) async {
  final newModelFile = _get_file('$modelName.dart', _model_folder);
  newModelFile.writeAsString(_modelTemp(modelName));
  await _exportNewModel(modelName);
}

Future<void> newAsset(String newAsset) async {
  final newImageFolder = _get_dir(newAsset, _images_folder);
  newImageFolder.create();

  final yamlContent = await _yaml_file.readAsString();
  final newYamlContent = yamlContent.replaceAll('''assets:''', '''
  assets:
    - assets/images/$newAsset/''');
  await _yaml_file.writeAsString(newYamlContent);
  await Shell().run('''flutter pub get''');
}

Future<void> newService(String serviceName) async {
  final newServiceFile = _get_file('$serviceName.dart', _service_folder);
  newServiceFile.create();

  await newServiceFile
      .writeAsString(_newServiceTemp(serviceName.toCamelcase()));
  await _exportNewService(serviceName);
}

Future<void> newLocalModel(
  String localModelName,
  String screenName,
) async {
  final screenFolder = _get_dir(screenName, _screen_folder);
  final localModelFolder = _get_dir('local_model', screenFolder);
  final localModelsFile = _get_file('local_models.dart', localModelFolder);
  if (!screenFolder.existsSync()) await newScreen(screenName);
  if (!localModelFolder.existsSync()) await localModelFolder.create();
  final newModelFile = _get_file(
    '$localModelName.dart',
    localModelFolder,
  );
  await localModelsFile.writeAsString(
    '''\nexport '$localModelName.dart';''',
    mode: FileMode.append,
  );
  await newModelFile.writeAsString(_modelTemp(localModelName));
}

Future<void> newLocalWidget(String localWidgetName, String screenName) async {
  final screenFolder = _get_dir(screenName, _screen_folder);
  final localWidgetFolder = _get_dir('local_widget', screenFolder);
  if (!screenFolder.existsSync()) await newScreen(screenName);
  if (!localWidgetFolder.existsSync()) await localWidgetFolder.create();
  final localWidgetsFile = _get_file(
    'local_widgets.dart',
    localWidgetFolder,
  );
  final newWidgetFile = _get_file(
    '$localWidgetName.dart',
    localWidgetFolder,
  );
  await localWidgetsFile.writeAsString(
    '''\nexport '$localWidgetName.dart';''',
    mode: FileMode.append,
  );
  await newWidgetFile
      .writeAsString(_newWidgetTemp(localWidgetName.toCamelcase()));
}

void upgradeChaotic() {
  Shell().run('''flutter pub upgrade chaotic''');
}
