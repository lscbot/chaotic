part of init;

const _analysisOptionsTemp = '''
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

const _commonsTemp = '''
export 'color.dart';
export 'path_and_apis.dart';
''';

const _cmdCommandsTemp = '''
flutter pub add lint
flutter pub add bot_toast
flutter pub add shared_preferences
flutter pub add flutter_svg
flutter pub add sizer
flutter pub add flutter_spinkit
flutter pub add get
flutter pub add provider
flutter pub add dio
flutter pub add url_launcher
flutter pub add easy_localization
flutter pub get
''';

const _assetsTemp = '''
  
  assets:
    - assets/images/
    - assets/lang/
''';

const _mainTemp = '''
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

const _arTemp = '''
{}
''';
const _enTemp = '''
{}
''';

String _newScreenTemp(String screenNameCamelcase) {
  return '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens.dart';


class ${screenNameCamelcase}Screen extends StatelessWidget {
  late ${screenNameCamelcase}Provider provider;
  
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<${screenNameCamelcase}Provider>(context);
    return const Scaffold(
      body: Center(child: Text('hello world, this is $screenNameCamelcase screen')),
    );
  }
}
  ''';
}

String _newProviderTemp(String screenNameCamelcase) {
  return '''
import 'package:flutter/material.dart';

class ${screenNameCamelcase}Provider extends ChangeNotifier{

}
  ''';
}

String _newWidgetTemp(String widgetName) {
  return '''
import 'package:flutter/material.dart';

class $widgetName extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text('$widgetName widget'),
    );
  }
}
  ''';
}

String _modelTemp(String modelName) => '''
extension ${modelName.toCamelcase()}Functions on ${modelName.toCamelcase()}{
}
class ${modelName.toCamelcase()}{
}
''';
String _newServiceTemp(String serviceName) {
  return '''
class ${serviceName}Service {
  ${serviceName}Service._();
  static final _instance = ${serviceName}Service._();
  factory ${serviceName}Service.getInstance() => _instance;
  //--------------------
}
  ''';
}

Future<void> _exportNewScreen(String screenName) async {
  final exportTemp = '''
  export '$screenName/$screenName.dart';
  export '$screenName/${screenName}_provider.dart';
''';
  await _screensFile.writeAsString(exportTemp, mode: FileMode.append);
}

Future<void> _exportNewCommon(String commonName) async {
  final exportTemp = '''
  export '$commonName.dart';
''';
  await _commonsFile.writeAsString(exportTemp, mode: FileMode.append);
}

Future<void> _exportNewWidget(String widgetName) async {
  final exportTemp = '''
  export '$widgetName.dart';
''';
  await _widgetsFile.writeAsString(exportTemp, mode: FileMode.append);
}

Future<void> _exportNewModel(String modelName) async {
  final exportTemp = '''
  export '$modelName.dart';
''';
  await _modelsFile.writeAsString(exportTemp, mode: FileMode.append);
}

Future<void> _exportNewService(String serviceName) async {
  final exportTemp = '''
  export '$serviceName.dart';
''';
  await _servicesFile.writeAsString(exportTemp, mode: FileMode.append);
}
