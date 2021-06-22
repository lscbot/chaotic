library init;

import 'dart:io';

import 'package:process_run/shell.dart';

part 'init/extensions.dart';
part 'init/files_and_folders.dart';
part 'init/files_templates.dart';
part 'init/init_helper.dart';

Future<void> init() async {
  await _create_project_structure();
  await _add_packages();
  await _init_yaml();
}

Future<void> new_screen(String screen_name) async {
  //init folders and files
  final new_screen_folder = _get_dir(screen_name, _screen_folder);
  final new_screen_file = _get_file('$screen_name.dart', new_screen_folder);
  final new_provider_file =
      _get_file('${screen_name}_provider.dart', new_screen_folder);
  final local_widget_folder = _get_dir('local_widget', new_screen_folder);
  final local_widgets_file =
      _get_file('local_widgets.dart', local_widget_folder);
  final local_model_folder = _get_dir('local_model', new_screen_folder);
  final local_models_file = _get_file('local_models.dart', local_model_folder);
  //join folders and files in one structure map
  final new_screen_structure = {
    new_screen_folder: [
      new_screen_file,
      new_provider_file,
    ],
    local_model_folder: local_models_file,
    local_widget_folder: local_widgets_file,
  };
  if (new_screen_file.existsSync()) {
    print('$screen_name is exists before');
    return;
  }
  //creating a structure
  await _create_structure_from_map(new_screen_structure);
  //write an export files
  await _export_new_screen(screen_name);
  //write template screen and provider
  await new_screen_file
      .writeAsString(_new_screen_temp(screen_name.to_camelcase()));
  await new_provider_file
      .writeAsString(_new_provider_temp(screen_name.to_camelcase()));
}

Future<void> new_common(String common_name) async {
  final new_common_file = _get_file('$common_name.dart', _common_folder);
  new_common_file.create();
  await _export_new_common(common_name);
}

Future<void> new_widget(String widget_name) async {
  final new_widget_file = _get_file('$widget_name.dart', _widget_folder);
  new_widget_file.create();

  await new_widget_file
      .writeAsString(_new_widget_temp(widget_name.to_camelcase()));
  await _export_new_widget(widget_name);
}

Future<void> new_model(String model_name) async {
  final new_model_file = _get_file('$model_name.dart', _model_folder);
  new_model_file.create();
  await _export_new_model(model_name);
}

Future<void> new_asset(String new_asset) async {
  final new_image_folder = _get_dir(new_asset, _images_folder);
  new_image_folder.create();

  final yaml_content = await _yaml_file.readAsString();
  final new_yaml_content = yaml_content.replaceAll('''assets:''', '''assets:
    - assets/images/$new_asset/''');
  await _yaml_file.writeAsString(new_yaml_content);
  await Shell().run('''flutter pub get''');
}

Future<void> new_service(String service_name) async {
  final new_service_file = _get_file('$service_name.dart', _service_folder);
  new_service_file.create();

  await new_service_file
      .writeAsString(_new_service_temp(service_name.to_camelcase()));
  await _export_new_service(service_name);
}

Future<void> new_local_model(
  String local_model_name,
  String screen_name,
) async {
  final screen_folder = _get_dir(screen_name, _screen_folder);
  if (!screen_folder.existsSync()) await new_screen(screen_name);
  final local_model_folder = _get_dir('local_model', screen_folder);
  final local_models_file = _get_file(
    'local_models.dart',
    local_model_folder,
  );
  final new_model_file = _get_file(
    '$local_model_name.dart',
    local_model_folder,
  );
  await local_models_file.writeAsString(
    '''\nexport '$local_model_name.dart';''',
    mode: FileMode.append,
  );
  await new_model_file.writeAsString(
    _new_widget_temp(local_model_name.to_camelcase()),
  );
}

Future<void> new_local_widget(
    String local_widget_name, String screen_name) async {
  final screen_folder = _get_dir(screen_name, _screen_folder);
  if (!screen_folder.existsSync()) await new_screen(screen_name);
  final local_widget_folder = _get_dir('local_widget', screen_folder);
  final local_widgets_file = _get_file(
    'local_widgets.dart',
    local_widget_folder,
  );
  final new_widget_file = _get_file(
    '$local_widget_name.dart',
    local_widget_folder,
  );
  await local_widgets_file.writeAsString(
    '''\nexport '$local_widget_name.dart';''',
    mode: FileMode.append,
  );
  await new_widget_file
      .writeAsString(_new_widget_temp(local_widget_name.to_camelcase()));
}
