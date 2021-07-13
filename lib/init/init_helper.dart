part of init;

Future<void> _createProjectStructure() async {
  await _createStructureFromMap(_structure);
  await _commons_file.writeAsString(_commonsTemp);
  await _ar_file.writeAsString(_arTemp);
  await _en_file.writeAsString(_enTemp);
  await _analysis_options_file.writeAsString(_analysisOptionsTemp);
  await _main_file.writeAsString(_mainTemp);
}

Future<void> _createStructureFromMap(Map structure) async {
  for (final item in structure.entries) {
    await item.key.create();
    final value = item.value;
    if (value is List) {
      await _createStructureFromList(value);
    } else {
      await value.create();
    }
  }
}

Future<void> _createStructureFromList(List items) async {
  for (final item in items) {
    if (item is Map) {
      await _createStructureFromMap(item);
    } else {
      await item.create();
    }
  }
}

Future<void> _addPackages() async {
  final shell = Shell();
  final commands = _cmdCommandsTemp.split('\n')
    ..removeWhere((commandLine) => commandLine.isEmpty);
  for (final command in commands) {
    try {
      await shell.run(command);
    } catch (e) {
      log("can't run this command $command");
    }
  }
}

Future<void> _initYaml() async {
  final yamlContent = await _yaml_file.readAsString();
  final newYamlContent = yamlContent.split('\n')
    ..removeWhere((line) => line.trim().startsWith('#'))
    ..removeWhere((line) => line.trim().isEmpty);
  await _yaml_file.writeAsString(newYamlContent.join('\n'));
  await _yaml_file.writeAsString(_assetsTemp, mode: FileMode.append);
}
