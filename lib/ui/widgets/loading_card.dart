import 'package:flutter/material.dart';
import 'package:mobile_challenge_2021/extensions/color_extensions.dart';
import 'package:mobile_challenge_2021/helpers/constants.dart';
import 'package:mobile_challenge_2021/i18n/app_localizations.dart';
import 'package:mobile_challenge_2021/ui/themes/my_color_scheme.dart';

// ignore: import_of_legacy_library_into_null_safe
// import 'package:flutter_svg/flutter_svg.dart';

class LoadingCard extends StatefulWidget {
  const LoadingCard({Key? key}) : super(key: key);

  @override
  _LoadingCard createState() => _LoadingCard();
}

class _LoadingCard extends State<LoadingCard> {
  late Color _cardColor;

  @override
  void initState() {
    super.initState();
    _cardColor = MyColorScheme().primary;
  }

  @override
  MouseRegion build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => _mouseEnter(true),
      onExit: (e) => _mouseEnter(false),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: _cardColor.isDark() ? Colors.white : Colors.black),
        ),
        child: Card(
          color: _cardColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(color: Colors.black),
              Text(AppLocalizations.of(context).loading),
            ],
          ),
        ),
      ),
    );
  }

  void _mouseEnter(bool hover) {
    setState(() {
      _cardColor = hover
          ? MyColorScheme()
              .primary
              .withOpacity(Constants.DEFAULT_CARD_BK_IMAGE_ON_HOVER_OPACITY)
          : MyColorScheme().primary;
    });
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Loading Card. Additional info: ${super.toString(minLevel: minLevel)}.';
  }
}
