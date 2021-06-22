part of init;

//assets
final _assets_folder = Directory('./assets');
final _images_folder = _get_dir('images', _assets_folder);
final _fonts_folder = _get_dir('fonts', _assets_folder);
final _lang_folder = _get_dir('lang', _assets_folder);
final _ar_file = _get_file('ar.json', _lang_folder);
final _en_file = _get_file('en.json', _lang_folder);
//src
final _src_folder = Directory('./lib/src');
//commons
final _common_folder = _get_dir('common', _src_folder);
final _commons_file = _get_file('commons.dart', _common_folder);
final _color_file = _get_file('color.dart', _common_folder);
final _path_and_apis_file = _get_file('path_and_apis.dart', _common_folder);
//screens
final _screen_folder = _get_dir('screen', _src_folder);
final _screens_file = _get_file('screens.dart', _screen_folder);
//widgets
final _widget_folder = _get_dir('widget', _src_folder);
final _widgets_file = _get_file('widgets.dart', _widget_folder);
//services
final _service_folder = _get_dir('service', _src_folder);
final _services_file = _get_file('services.dart', _service_folder);
//models
final _model_folder = _get_dir('model', _src_folder);
final _models_file = _get_file('models.dart', _model_folder);
//analysis options
final _analysis_options_file = File('./analysis_options.yaml');
//yaml
final _yaml_file = File('./pubspec.yaml');
//main
final _main_file = File('./lib/main.dart');

Directory _get_dir(String name, Directory parent) {
  return Directory(parent.path + '/$name');
}

File _get_file(String name, Directory parent) {
  return File(parent.path + '/$name');
}

final _structure = {
  _assets_folder: [
    _images_folder,
    _fonts_folder,
    {
      _lang_folder: [
        _ar_file,
        _en_file,
      ],
    }
  ],
  _src_folder: [
    {
      _common_folder: [
        _commons_file,
        _color_file,
        _path_and_apis_file,
      ]
    },
    {
      _screen_folder: _screens_file,
    },
    {
      _widget_folder: _widgets_file,
    },
    {
      _service_folder: _services_file,
    },
    {
      _model_folder: _models_file,
    }
  ],
};
