// ignore: import_of_legacy_library_into_null_safe
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_challenge_2021/helpers/constants.dart';
import 'package:mobile_challenge_2021/helpers/dialogs.dart';
import 'package:mobile_challenge_2021/i18n/app_localizations.dart';
import 'package:mobile_challenge_2021/real_main.dart';
import 'package:mobile_challenge_2021/ui/my_scaffold.dart';
import 'package:mobile_challenge_2021/ui/themes/my_text_style.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
        builder: (context) => const SettingsPage());
  }

  static const String routeName = '/settings';

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final _scrollController = ScrollController(initialScrollOffset: 5.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(const Size(640, double.infinity)),
          child: Material(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Constants.DEFAULT_EDGE_INSETS_HORIZONTAL),
              child: Scrollbar(
                controller: _scrollController,
                child: ListView(
                  controller: _scrollController,
                  children: <Widget>[
                    ..._getBasicWidgets(),
                    _getLanguageSettingsSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getBasicWidgets() {
    final widgets = <Widget>[];
    widgets.add(const SizedBox(
      width: 20,
      height: 20,
    ));
    widgets.add(Center(
        child: Text(AppLocalizations.of(context).settings,
            style: const MyTextStyle.title())));
    widgets.add(const SizedBox(
      width: 20,
      height: 20,
    ));
    widgets.add(
      SvgPicture.asset('assets/images/font_awesome/solid/wrench.svg',
          placeholderBuilder: (context) => const SizedBox(
              width: 100,
              height: 100,
              child: FittedBox(
                  fit: BoxFit.scaleDown, child: CircularProgressIndicator())),
          width: 100,
          height: 100),
    );

    widgets.add(const SizedBox(height: 10));

    return widgets;
  }

  SettingsSection _getLanguageSettingsSection() {
    return SettingsSection(
      title: AppLocalizations.of(context).languages,
      tiles: [
        SettingsTile(
          title: AppLocalizations.of(context).languageSelectionTitle,
          subtitle:
              '${AppLocalizations.of(context).languageSelectionSubtitle} ${MyApp.locale.countryCode}',
          subtitleMaxLines: 6,
          leading: const Icon(Icons.slow_motion_video),
          onPressed: (context) async {
            Dialogs.showLanguagePickerDialog(context, _onCountrySelected);
          },
        ),
      ],
    );
  }

  void _onCountrySelected(Country country) {
    switch (country.countryCode) {
      case 'US':
        {
          MyApp.setLocale(context, const Locale('en', 'US'));
          setState(() {});
        }
        break;
      case 'BR':
        {
          MyApp.setLocale(context, const Locale('pt', 'BR'));
          setState(() {});
        }
        break;
    }
  }
}
