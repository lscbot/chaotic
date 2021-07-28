part of init;

//assets
final _assetsFolder = Directory('./assets');
final _imagesFolder = _getDir('images', _assetsFolder);
final _fontsFolder = _getDir('fonts', _assetsFolder);
final _langFolder = _getDir('lang', _assetsFolder);
final _arFile = _getFile('ar.json', _langFolder);
final _enFile = _getFile('en.json', _langFolder);
//src
final _srcFolder = Directory('./lib/src');
//commons
final _commonFolder = _getDir('common', _srcFolder);
final _commonsFile = _getFile('commons.dart', _commonFolder);
final _colorFile = _getFile('color.dart', _commonFolder);
final _pathAndApisFile = _getFile('path_and_apis.dart', _commonFolder);
//screens
final _screenFolder = _getDir('screen', _srcFolder);
final _screensFile = _getFile('screens.dart', _screenFolder);
//widgets
final _widgetFolder = _getDir('widget', _srcFolder);
final _widgetsFile = _getFile('widgets.dart', _widgetFolder);
//services
final _serviceFolder = _getDir('service', _srcFolder);
final _servicesFile = _getFile('services.dart', _serviceFolder);
//models
final _modelFolder = _getDir('model', _srcFolder);
final _modelsFile = _getFile('models.dart', _modelFolder);
//analysis options
final _analysisOptionsFile = File('./analysis_options.yaml');
//yaml
final _yamlFile = File('./pubspec.yaml');
//main
final _mainFile = File('./lib/main.dart');

Directory _getDir(String name, Directory parent) {
  return Directory('${parent.path}${'/$name'}');
}

File _getFile(String name, Directory parent) {
  return File('${parent.path}${'/$name'}');
}

final _structure = {
  _assetsFolder: [
    _imagesFolder,
    _fontsFolder,
    {
      _langFolder: [
        _arFile,
        _enFile,
      ],
    }
  ],
  _srcFolder: [
    {
      _commonFolder: [
        _commonsFile,
        _colorFile,
        _pathAndApisFile,
      ]
    },
    {
      _screenFolder: _screensFile,
    },
    {
      _widgetFolder: _widgetsFile,
    },
    {
      _serviceFolder: _servicesFile,
    },
    {
      _modelFolder: _modelsFile,
    }
  ],
};
