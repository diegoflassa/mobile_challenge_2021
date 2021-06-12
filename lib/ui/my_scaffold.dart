import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_challenge_2021_flutter/extensions/build_context_extensions.dart';
import 'package:mobile_challenge_2021_flutter/helpers/constants.dart';
import 'package:mobile_challenge_2021_flutter/helpers/my_logger.dart';
import 'package:mobile_challenge_2021_flutter/i18n/app_localizations.dart';
import 'package:mobile_challenge_2021_flutter/models/my_scaffold_model.dart';
import 'package:mobile_challenge_2021_flutter/network/connection_status_singleton.dart';
import 'package:mobile_challenge_2021_flutter/real_main.dart';
import 'package:mobile_challenge_2021_flutter/resources/resources.dart';
import 'package:mobile_challenge_2021_flutter/routing/routes.dart';
import 'package:mobile_challenge_2021_flutter/ui/themes/my_color_scheme.dart';
import 'package:mobile_challenge_2021_flutter/ui/themes/my_text_style.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

typedef OnNewQueryCallback = void Function(String newQuery);

class MyScaffold extends StatefulWidget {
  const MyScaffold({
    Key? key,
    this.appBar,
    this.hasAppBar = true,
    this.body,
    this.title = Constants.APP_NAME,
  }) : super(key: key);

  final AppBar? appBar;
  final bool hasAppBar;
  final Widget? body;
  final String? title;

  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

// 🚀Global Functional Injection
// This state will be auto-disposed when no longer used, and also testable and mockable.
final myScaffoldModel = RM.inject<MyScaffoldModel>(
  () => MyScaffoldModel(),
  undoStackLength: Constants.DEFAULT_UNDO_STACK_LENGTH,
  //Called after new state calculation and just before state mutation
  middleSnapState: (middleSnap) {
    //Log all state transition.
    MyLogger().logger.i(middleSnap.currentSnap);
    MyLogger().logger.i(middleSnap.nextSnap);

    MyLogger().logger.i('');
    middleSnap.print(preMessage: '[MyScaffoldModel]'); //Build-in logger
    //Can return another state
  },
  onDisposed: (state) => MyLogger().logger.i('[MyScaffoldModel]Disposed'),
);

class _MyScaffoldState extends State<MyScaffold> with TickerProviderStateMixin {
  StreamSubscription<dynamic>? _connectionChangeStream;
  bool _showPerformanceOverlay = false;
  bool _showMaterialGrid = false;
  bool _showSemanticsDebugger = false;
  late AnimationController _rotationController;
  static const POPUP_MENU_ITEM_LICENSES = 'licenses';
  static const POPUP_MENU_ITEM_SETTINGS = 'settings';
  static const POPUP_MENU_ITEM_PERFORMANCE_OVERLAY = 'performance_overlay';
  static const POPUP_MENU_ITEM_MATERIAL_GRID = 'material_grid';
  static const POPUP_MENU_ITEM_SEMANTICS_DEBUGGER = 'semantics_debugger';
  int? _timeToRecheck;
  Timer? _timeToRecheckValueUpdater;

  void _selectPopupMenu(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    switch (choice.tag) {
      case POPUP_MENU_ITEM_LICENSES:
        {
          showLicensePage(
              context: context,
              applicationName: AppLocalizations.of(context).appName);
        }
        break;
      case POPUP_MENU_ITEM_SETTINGS:
        {
          Navigator.of(context).pushNamed(Routes.settings);
        }
        break;
      case POPUP_MENU_ITEM_PERFORMANCE_OVERLAY:
        {
          if (kDebugMode || kProfileMode) {
            _showPerformanceOverlay = !_showPerformanceOverlay;
            MyApp.setPerformanceOverlay(_showPerformanceOverlay);
          }
        }
        break;
      case POPUP_MENU_ITEM_MATERIAL_GRID:
        {
          if (kDebugMode || kProfileMode) {
            _showMaterialGrid = !_showMaterialGrid;
            MyApp.setMaterialGrid(_showMaterialGrid);
          }
        }
        break;
      case POPUP_MENU_ITEM_SEMANTICS_DEBUGGER:
        {
          if (kDebugMode || kProfileMode) {
            _showSemanticsDebugger = !_showSemanticsDebugger;
            MyApp.setSemanticsDebugger(_showSemanticsDebugger);
          }
        }
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    // Exhaustively handle all four status
    On.all(
      // If is Idle
      onIdle: () => MyLogger().logger.i('[MyScaffoldModel]Idle'),
      // If is waiting
      onWaiting: () => MyLogger().logger.i('[MyScaffoldModel]Waiting'),
      // If has error
      onError: (dynamic err, refresh) =>
          MyLogger().logger.e('[MyScaffoldModel]Error:$err. Refresh:$refresh'),
      // If has Data
      onData: () => MyLogger().logger.i('[MyScaffoldModel]Data'),
    );

    _rotationController = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);
    Future<void>.delayed(
        const Duration(milliseconds: Constants.DEFAULT_DELAY_TO_ADD_CHOICES),
        () {
      choices.add(Choice(
          tag: POPUP_MENU_ITEM_LICENSES,
          title: AppLocalizations.of(context).licenses,
          icon: Icons.settings));
      choices.add(Choice(
          tag: POPUP_MENU_ITEM_SETTINGS,
          title: AppLocalizations.of(context).settings,
          icon: Icons.settings));
      if (kDebugMode || kProfileMode) {
        choices.add(Choice(
            tag: POPUP_MENU_ITEM_PERFORMANCE_OVERLAY,
            title: AppLocalizations.of(context).performanceOverlay,
            icon: Icons.settings));

        choices.add(Choice(
            tag: POPUP_MENU_ITEM_MATERIAL_GRID,
            title: AppLocalizations.of(context).materialGrid,
            icon: Icons.settings));

        choices.add(Choice(
            tag: POPUP_MENU_ITEM_SEMANTICS_DEBUGGER,
            title: AppLocalizations.of(context).semanticsDebugger,
            icon: Icons.settings));
      }
    });
    final connectionStatus = ConnectionStatusSingleton.getInstance()
      ..initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
  }

  @override
  void dispose() {
    _connectionChangeStream?.cancel();
    _rotationController.dispose();
    _timeToRecheckValueUpdater?.cancel();
    super.dispose();
  }

  void connectionChanged(dynamic hasConnection) {
    if (mounted) {
      setState(() {
        MyLogger().logger.i('Setting connected to : $hasConnection');
        myScaffoldModel.state.isConnected = hasConnection as bool;
        if (!myScaffoldModel.state.isConnected) {
          Navigator.pushNamed(context, Routes.allPatients);
          if (_timeToRecheckValueUpdater != null) {
            _timeToRecheckValueUpdater!.cancel();
            _timeToRecheckValueUpdater = null;
          }

          if (_timeToRecheck == null) {
            _timeToRecheck = 5;
            _timeToRecheckValueUpdater ??= Timer.periodic(
                const Duration(seconds: 1), _updateTimeToRecheck);
          }
        } else {
          if (_timeToRecheckValueUpdater != null) {
            _timeToRecheckValueUpdater!.cancel();
            _timeToRecheckValueUpdater = null;
            _timeToRecheck = null;
          }
        }
      });
    }
  }

  void _updateTimeToRecheck(Timer timer) {
    if (context.isCurrent(this)) {
      if (_timeToRecheck != null) {
        if (mounted) {
          setState(() {
            if (_timeToRecheck! > 0) {
              _timeToRecheck = _timeToRecheck! - 1;
            } else {
              _timeToRecheck = 5;
            }
          });
        }
      } else {
        _timeToRecheck = 5;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: widget.hasAppBar
              ? (widget.appBar == null)
                  ? AppBar(
                      backwardsCompatibility: false,
                      systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor: MyColorScheme().primary),
                      brightness: Brightness.dark,
                      title: _getAppBarLogoAndTitle(),
                      actions: _buildActions(),
                    )
                  : widget.appBar
              : null,
          body: (widget.body != null) ? widget.body! : _getEmptyBody(context)),
    );
  }

  Widget _getAppBarLogoAndTitle() {
    return Row(children: <Widget>[
      Image.asset(Images.logo,
          width: Constants.DEFAULT_APP_BAR_LOGO_WIDTH,
          height: Constants.DEFAULT_APP_BAR_LOGO_HEIGHT,
          fit: BoxFit.contain,
          alignment: FractionalOffset.center),
      const SizedBox(height: 1, width: Constants.DEFAULT_BORDER_SPACE),
    ]);
  }

  List<Widget> _buildActions() {
    final ret = <Widget>[];

    ret.add(
      const SizedBox(
        width: 10,
      ),
    );

    if (!myScaffoldModel.state.isConnected) {
      ret.add(_getNoConnectionIcon());
    }

    ret.add(
      PopupMenuButton<Choice>(
        onSelected: _selectPopupMenu,
        itemBuilder: (context) {
          return choices.map(
            (choice) {
              return PopupMenuItem<Choice>(
                value: choice,
                child: Text(choice.title),
              );
            },
          ).toList();
        },
      ),
    );

    return ret;
  }

  Center _getNoConnectionIcon() {
    return Center(
      child: Stack(
        children: <Widget>[
          SvgPicture.asset('assets/images/font_awesome/solid/wifi.svg',
              color: Colors.white,
              placeholderBuilder: (context) => const SizedBox(
                  width: 25,
                  height: 25,
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CircularProgressIndicator())),
              width: 25,
              height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: SvgPicture.asset('assets/images/font_awesome/solid/ban.svg',
                color: Colors.brown,
                placeholderBuilder: (context) => const SizedBox(
                    width: 25,
                    height: 25,
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CircularProgressIndicator())),
                width: 25,
                height: 25),
          ),
          SizedBox(
            width: Constants.DEFAULT_APP_BAR_ICON_WIDTH_AND_HEIGHT,
            height: Constants.DEFAULT_APP_BAR_ICON_WIDTH_AND_HEIGHT,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Center(
                child: AutoSizeText(
                  '${(_timeToRecheck != null) ? _timeToRecheck : 0}s',
                  style: const MyTextStyle.blackBold(),
                  minFontSize:
                      Constants.DEFAULT_MIN_FONT_SIZE_FOR_RECHECK_CONNECTION,
                  maxLines: Constants.DEFAULT_MAX_LINES_FOR_RECHECK_CONNECTION,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEmptyBody(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Text(AppLocalizations.of(context).empty),
      ),
    );
  }

  List<Choice> choices = <Choice>[];
}

class Choice {
  const Choice({this.tag = '', this.title = '', this.icon});

  final String tag;
  final String title;
  final IconData? icon;
}
