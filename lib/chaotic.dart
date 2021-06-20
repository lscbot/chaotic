library chaotic;

import 'dart:io';

import 'package:process_run/shell.dart';

part 'chaotic/chaotic_helper.dart';

void new_screen(String screen_name) {
  final screen_folder = Directory('./lib/src/screen');

  final screens_file = _getFile('screens.dart', screen_folder);
  final class_name =
      '${screen_name[0].toUpperCase()}${screen_name.substring(1)}Screen';
  final provider_name =
      '${screen_name[0].toUpperCase()}${screen_name.substring(1)}Provider';

  final new_screen_folder = _getDir(screen_name, screen_folder);

  final new_widget_folder = _getDir('local_widget', new_screen_folder);
  final new_widgets_file = _getFile('local_widgets.dart', new_widget_folder);

  final new_model_folder = _getDir('local_model', new_screen_folder);
  final new_model_file = _getFile('local_models.dart', new_model_folder);

  final new_screen = _getFile('${screen_name}.dart', new_screen_folder);
  final new_provider =
      _getFile('${screen_name}_provider.dart', new_screen_folder);

  new_screen_folder.create();
  new_screen.create();
  new_provider.create();
  new_widget_folder.create();
  new_widgets_file.create();
  new_model_folder.create();
  new_model_file.create();

  screens_file.writeAsString('''\nexport '$screen_name/$screen_name.dart';
export '$screen_name/${screen_name}_provider.dart';''', mode: FileMode.append);

  new_screen.writeAsString('''import 'package:flutter/material.dart';
import 'local_widget/local_widgets.dart';
import '${screen_name}_provider.dart';
import 'package:provider/provider.dart';


class $class_name extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<$provider_name>(context);
    return Scaffold(
      body: const Center(child: Text('hello world, this is $class_name screen')),
    );
  }
}''');

  new_provider.writeAsString('''import 'package:flutter/cupertino.dart';

class $provider_name extends ChangeNotifier{
  
}''');
}

void new_common(String common_name) async {
  final common_folder = Directory('./lib/src/common');
  final commons_file = _getFile('commons.dart', common_folder);
  final new_common_file = _getFile('$common_name.dart', common_folder);
  await new_common_file.create();
  await commons_file.writeAsString('''\nexport '$common_name.dart';''',
      mode: FileMode.append);
}

void new_widget(String widget_name) async {
  final widget_folder = Directory('./lib/src/widget');
  final widgets_file = _getFile('widgets.dart', widget_folder);
  final new_widget_file = _getFile('$widget_name.dart', widget_folder);
  await new_widget_file.create();
  await widgets_file.writeAsString('''\nexport '$widget_name.dart';''',
      mode: FileMode.append);
  final class_name =
      '${widget_name[0].toUpperCase()}${widget_name.substring(1)}';
  await new_widget_file.writeAsString('''import 'package:flutter/material.dart';

class $class_name extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('${class_name} widget'),
    );
  }
}''');
}

void new_service(String service_name) async {
  final service_folder = Directory('./lib/src/service');
  final services_file = _getFile('services.dart', service_folder);
  final new_service_file = _getFile('$service_name.dart', service_folder);
  await new_service_file.create();
  await services_file.writeAsString('''\nexport '$service_name.dart';''',
      mode: FileMode.append);
  final class_name =
      '${service_name[0].toUpperCase()}${service_name.substring(1)}Service';
  await new_service_file.writeAsString('''class $class_name {
  $class_name._();
  static final _instance = $class_name._();
  factory $class_name.get_instance() => _instance;
  //--------------------
}''');
}

void new_model(String model_name) async {
  final model_folder = Directory('./lib/src/model');
  final models_file = _getFile('models.dart', model_folder);
  final new_model_file = _getFile('$model_name.dart', model_folder);
  await new_model_file.create();
  await models_file
      .writeAsString('''\nexport '$model_name.dart';''', mode: FileMode.append);
}

void new_asset(String new_asset_path) async {
  final asset_file = File('./pubspec.yaml');
  final asset_content = await asset_file.readAsString();
  final new_asset_content = asset_content.replaceAll('''assets:''', '''assets:
  - assets/images/$new_asset_path''');
  await asset_file.writeAsString(new_asset_content);
}

void new_local_widget(String local_widget_name, String screen_name) async {
  final local_widget_folder =
      Directory('./lib/src/screen/$screen_name/local_widget');
  final local_widgets_file =
      _getFile('local_widgets.dart', local_widget_folder);
  final new_widget_file =
      _getFile('$local_widget_name.dart', local_widget_folder);
  await new_widget_file.create();
  await local_widgets_file.writeAsString(
      '''\nexport '$local_widget_name.dart';''',
      mode: FileMode.append);
  final class_name =
      '${local_widget_name[0].toUpperCase()}${local_widget_name.substring(1)}';
  await new_widget_file.writeAsString('''import 'package:flutter/material.dart';

class $class_name extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('${class_name} widget'),
    );
  }
}''');
}

void new_local_model(String local_model_name, String screen_name) async {
  final local_model_folder =
      Directory('./lib/src/screen/$screen_name/local_model');
  final local_models_file = _getFile('local_models.dart', local_model_folder);
  final new_model_file = _getFile('$local_model_name.dart', local_model_folder);
  await new_model_file.create();
  await local_models_file.writeAsString(
      '''\nexport '$local_model_name.dart';''',
      mode: FileMode.append);
}

void init() async {
  await _create_project_structure();
  await _init_yaml();
  await _init_analysis_options();
  await _init_main();
  await _add_packages();
}
