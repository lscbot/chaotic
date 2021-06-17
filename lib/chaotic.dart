library chaotic;

import 'dart:io';
import 'package:process_run/shell.dart';
part 'chaotic/chaotic_helper.dart';

void new_screen(String screen_name) {
  final screen_folder = Directory('./lib/src/screen');
  final screens_file = _getFile('screens', screen_folder);

  final new_screen_folder = _getDir(screen_name, screen_folder);

  final new_widget_folder = _getDir('local_widgets', new_screen_folder);
  final new_widgets_file = _getFile('local_widgets.dart', new_widget_folder);

  final new_model_folder = _getDir('local_models', new_screen_folder);
  final new_model_file = _getFile('local_widgets.dart', new_model_folder);

  final new_screen = _getFile('${screen_name}.dart', new_screen_folder);
  final new_provider = _getFile('${screen_name}_provider.dart', new_screen_folder);

  new_widget_folder.create();
  new_model_folder.create();
  new_screen_folder.create();
  new_screen.create();
  new_provider.create();
  new_model_file.create();
  new_widgets_file.create();
}
void new_common() {}
void new_widget() {}
void new_service() {}
void new_model() {}
void new_asset(){}

void init() async {
  await _create_project_structure();
  await _init_yaml();
  await _init_analysis_options();
  await _init_main();
  await _add_packages();
  }
