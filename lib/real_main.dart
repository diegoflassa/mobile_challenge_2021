import 'dart:async';
import 'dart:ui';

import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_challenge_2021/bloc/main_bloc.dart';
import 'package:mobile_challenge_2021/helpers/lifecycle_event_handler.dart';
import 'package:mobile_challenge_2021/helpers/my_logger.dart';
import 'package:mobile_challenge_2021/helpers/navigation_service.dart';
import 'package:mobile_challenge_2021/i18n/app_localizations.dart';
import 'package:mobile_challenge_2021/i18n/app_localizations_delegate.dart';
import 'package:mobile_challenge_2021/routing/routes.dart';
import 'package:mobile_challenge_2021/ui/patients/all_patients.dart';
import 'package:mobile_challenge_2021/ui/settings/settings_page.dart';
import 'package:mobile_challenge_2021/ui/themes/my_app_bar_theme.dart';
import 'package:mobile_challenge_2021/ui/themes/my_button_theme.dart';
import 'package:mobile_challenge_2021/ui/themes/my_color_scheme.dart';
import 'package:mobile_challenge_2021/ui/themes/my_toggle_button_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> realMain() async {
  // This line enables the extension.
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance?.addObserver(LifecycleEventHandler(
      didHaveMemoryPressureCallback: _didHaveMemoryPressure));
  await _getPreferences();
  runZonedGuarded(initApp, onError);
  return true;
}

class Firebase {}

final key = GlobalKey<_MyAppState>();
late final SharedPreferences _prefs;

void onError(Object error, StackTrace stackTrace) {
  MyLogger().logger.e('$error. Stack: $stackTrace');
}

Future<void> _didHaveMemoryPressure() async {
  MyLogger().logger.w('didHaveMemoryPressure');
}

Future<SharedPreferences> _getPreferences() async {
  return _prefs = await SharedPreferences.getInstance();
}

void initApp() {
  runApp(MyApp(key: key));
}

const String sentry_dns =
    'https://ef1b010440694216b5416b820e48a074@o473693.ingest.sentry.io/5508918';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static Locale locale = const Locale('en', 'US');

  static Future<bool> setLocale(BuildContext context, Locale newLocale) async {
    final state = context.findAncestorStateOfType<_MyAppState>();
    if (state != null) {
      state.changeLanguage(newLocale);
      return true;
    } else {
      return false;
    }
  }

  static SharedPreferences getSharedPreferences() {
    return _prefs;
  }

  static void setPerformanceOverlay(bool enable) {
    key.currentState!.setPerformanceOverlay(enable);
  }

  static void setMaterialGrid(bool enable) {
    key.currentState!.setMaterialGrid(enable);
  }

  static void setSemanticsDebugger(bool enable) {
    key.currentState!.setSemanticsDebugger(enable);
  }

  final appTitle = 'Patients Viewer';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showPerformanceOverlay = false;
  bool _showMaterialGrid = false;
  bool _showSemanticsDebugger = false;

  void setPerformanceOverlay(bool enable) {
    setState(() {
      _showPerformanceOverlay = enable;
    });
  }

  void setMaterialGrid(bool enable) {
    setState(() {
      _showMaterialGrid = enable;
    });
  }

  void setSemanticsDebugger(bool enable) {
    setState(() {
      _showSemanticsDebugger = enable;
      _resetSemanticsDebugger(!enable);
    });
  }

  Future<void> _resetSemanticsDebugger(bool value) {
    return Future.delayed(const Duration(seconds: 15), () {
      setState(() {
        _showSemanticsDebugger = value;
      });
    });
  }

  void changeLanguage(Locale locale) {
    setState(() {
      MyApp.locale = locale;
      _localeOverrideDelegate = SpecifiedLocalizationDelegate(locale);
    });
  }

  static GetIt locator = GetIt.instance;

  void _initializeLocator() {
    locator.registerLazySingleton(() => NavigationService());
  }

  SpecifiedLocalizationDelegate? _localeOverrideDelegate;

  @override
  void initState() {
    Devicelocale.currentAsLocale.then(
      (locale) => () {
        if (locale != null) {
          MyApp.locale = locale;
          _localeOverrideDelegate = SpecifiedLocalizationDelegate(MyApp.locale);
        }
      },
    );
    _initializeLocator();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final materialApp = _getMaterialApp(context, locale: MyApp.locale);
    return MultiBlocProvider(
      providers: MainBloc.allBlocs(),
      child: materialApp,
    );
  }

  MaterialApp _getMaterialApp(BuildContext context,
      {Locale? locale, LocaleResolutionCallback? localeResolutionCallback}) {
    return MaterialApp(
      showSemanticsDebugger: _showSemanticsDebugger,
      showPerformanceOverlay: _showPerformanceOverlay,
      debugShowMaterialGrid: _showMaterialGrid,
      locale: locale,
      initialRoute: '/',
      localeResolutionCallback: localeResolutionCallback,
      navigatorKey: GetIt.instance<NavigationService>().navigatorKey,
      routes: {
        Routes.home: (context) => const AllPatientsPage(),
        Routes.settings: (context) => const SettingsPage(),
      },
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        if (_localeOverrideDelegate != null) _localeOverrideDelegate!,
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English, with country code
        Locale('pt', 'BR') // Português, with country code
      ],
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      theme: ThemeData(
        primarySwatch: MyColorScheme().primaryAsMaterial,
        appBarTheme: MyAppBarTheme(MyColorScheme()),
        colorScheme: MyColorScheme(),
        buttonTheme: MyButtonTheme(MyColorScheme()),
        toggleButtonsTheme: MyToggleButtonTheme(MyColorScheme()),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
    );
  }
}
