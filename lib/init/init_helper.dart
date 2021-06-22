part of init;

Future<void> _create_project_structure() async {
  await _create_structure_from_map(_structure);
  await _commons_file.writeAsString(_commons_temp);
  await _ar_file.writeAsString(_ar_temp);
  await _en_file.writeAsString(_en_temp);
  await _analysis_options_file.writeAsString(_analysis_options_temp);
  await _main_file.writeAsString(_main_temp);
}

Future<void> _create_structure_from_map(Map structure) async {
  for (final item in structure.entries) {
    await item.key.create();
    if (item.value is List) {
      await _create_structure_from_list(item.value);
    } else {
      await item.value.create();
    }
  }
}

Future<void> _create_structure_from_list(List items) async {
  for (final item in items) {
    if (item is Map) {
      await _create_structure_from_map(item);
    } else {
      await item.create();
    }
  }
}

Future<void> _add_packages() async {
  final shell = Shell();
  final commands = _cmd_commands_temp.split('\n')
    ..removeWhere((command_line) => command_line.isEmpty);
  for (final command in commands) {
    try {
      await shell.run(command);
    } catch (e) {
      print('can\'t run this command $command');
    }
  }
}

Future<void> _init_yaml() async {
  final yaml_content = await _yaml_file.readAsString();
  final new_yaml_content = yaml_content.split('\n')
    ..removeWhere((line) => line.trim().startsWith('#'))
    ..removeWhere((line) => line.trim().isEmpty);
  await _yaml_file.writeAsString(new_yaml_content.join('\n'));
  await _yaml_file.writeAsString(_assets_temp, mode: FileMode.append);
}
