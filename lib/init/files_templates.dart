part of init;

const _analysis_options_temp = '''
include: package:lint/analysis_options.yaml

linter:
  rules:
    non_constant_identifier_names: false
analyzer:
  errors:
    unused_import: warning
  strong-mode:
    implicit-casts: true
''';

const _commons_temp = '''
export 'color.dart';
export 'path_and_apis.dart';
''';

const _cmd_commands_temp = '''
flutter pub add lint
flutter pub add bot_toast
flutter pub add shared_preferences
flutter pub add package_info
flutter pub add flutter_svg
flutter pub get
''';

const _assets_temp = '''
  
  assets:
    - assets/images/
    - assets/lang/
''';

const _main_temp = '''
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'src/screen/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
  Provider.debugCheckInvalidValueType = null;
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        // home: Provider(create: (_) => , 
            //   child:,
            // ),
      ),
    );
  }
}
''';

const _ar_temp = '''
{}
''';
const _en_temp = '''
{}
''';

String _new_screen_temp(String screen_name_camelcase) {
  return '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens.dart';


class ${screen_name_camelcase}Screen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<${screen_name_camelcase}Provider>(context);
    return const Scaffold(
      body: Center(child: Text('hello world, this is ${screen_name_camelcase} screen')),
    );
  }
}
  ''';
}

String _new_provider_temp(String screen_name_camelcase) {
  return '''
import 'package:flutter/material.dart';

class ${screen_name_camelcase}Provider extends ChangeNotifier{

}
  ''';
}

String _new_widget_temp(String widget_name) {
  return '''
import 'package:flutter/material.dart';

class $widget_name extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text('${widget_name} widget'),
    );
  }
}
  ''';
}

String _new_service_temp(String service_name) {
  return '''
class ${service_name}Service {
  ${service_name}Service._();
  static final _instance = ${service_name}Service._();
  factory ${service_name}Service.get_instance() => _instance;
  //--------------------
}
  ''';
}

Future<void> _export_new_screen(String screen_name) async {
  final export_temp = '''\nexport '$screen_name/$screen_name.dart';
export '$screen_name/${screen_name}_provider.dart';
''';
  await _screens_file.writeAsString(export_temp, mode: FileMode.append);
}

Future<void> _export_new_common(String common_name) async {
  final export_temp = '''\nexport '$common_name.dart';
''';
  await _commons_file.writeAsString(export_temp, mode: FileMode.append);
}

Future<void> _export_new_widget(String widget_name) async {
  final export_temp = '''\nexport '$widget_name.dart';
''';
  await _widgets_file.writeAsString(export_temp, mode: FileMode.append);
}

Future<void> _export_new_model(String model_name) async {
  final export_temp = '''\nexport '$model_name.dart';
''';
  await _models_file.writeAsString(export_temp, mode: FileMode.append);
}

Future<void> _export_new_service(String service_name) async {
  final export_temp = '''\nexport '$service_name.dart';
''';
  await _services_file.writeAsString(export_temp, mode: FileMode.append);
}
