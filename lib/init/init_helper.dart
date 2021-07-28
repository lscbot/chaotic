part of init;

Future<void> _createProjectStructure() async {
  await _createStructureFromMap(_structure);
  await _commonsFile.writeAsString(_commonsTemp);
  await _arFile.writeAsString(_arTemp);
  await _enFile.writeAsString(_enTemp);
  await _analysisOptionsFile.writeAsString(_analysisOptionsTemp);
  await _mainFile.writeAsString(_mainTemp);
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
  final yamlContent = await _yamlFile.readAsString();
  final newYamlContent = yamlContent.split('\n')
    ..removeWhere((line) => line.trim().startsWith('#'));

  await _yamlFile.writeAsString(newYamlContent.join('\n'));
  await _yamlFile.writeAsString(_assetsTemp, mode: FileMode.append);
}
