// ignore: import_of_legacy_library_into_null_safe
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile_challenge_2021/enums/gender.dart';
import 'package:mobile_challenge_2021/i18n/app_localizations.dart';
import 'package:mobile_challenge_2021/ui/themes/my_color_scheme.dart';

class Dialogs {
  static const DEFAULT_COUNTRY = 'DefaultLanguage';

  static void showLanguagePickerDialog(
      BuildContext context, ValueChanged<Country> onCountrySelected,
      {String? title}) {
    LanguageList.langs[DEFAULT_COUNTRY] =
        AppLocalizations.of(context).defaultLanguage;
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
      ),
      countryFilter: LanguageList.langs.keys.toList(),
      onSelect: onCountrySelected,
    );
  }

  static void showNationalityPickerDialog(
      BuildContext context, ValueChanged<Country> onCountrySelected,
      {String? title}) {
    LanguageList.langs[DEFAULT_COUNTRY] =
        AppLocalizations.of(context).defaultLanguage;
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
      ),
      countryFilter: NationalityList.nats.keys.toList(),
      onSelect: onCountrySelected,
    );
  }

  static Future<Gender?> showGenderPickerDialog(
      BuildContext context, Gender selectedGender,
      {String? title, bool isTest = false}) {
    var _gender = selectedGender;
    // set up the buttons
    final cancelButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop(null);
      },
      child: Text(isTest ? '' : AppLocalizations.of(context).cancel),
    );
    final continueButton = TextButton(
      key: const Key('gender_dialog_ok'),
      onPressed: () {
        Navigator.of(context).pop(_gender);
      },
      child: Text(isTest ? '' : AppLocalizations.of(context).select),
    );
    // set up the AlertDialog
    final alert = AlertDialog(
      title: Text(isTest ? '' : AppLocalizations.of(context).genderTitle),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(isTest ? '' : AppLocalizations.of(context).genderMessage),
              Column(
                children: <Widget>[
                  DropdownButton<Gender>(
                    value: _gender,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: MyColorScheme().primary,
                    ),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _gender = newValue;
                        });
                      }
                    },
                    items: [
                      DropdownMenuItem<Gender>(
                        key: const Key('gender_any'),
                        value: Gender.UNKNOWN,
                        child: Text(
                            isTest ? '' : AppLocalizations.of(context).any),
                      ),
                      DropdownMenuItem<Gender>(
                        key: const Key('gender_male'),
                        value: Gender.MALE,
                        child: Text(
                            isTest ? '' : AppLocalizations.of(context).male),
                      ),
                      DropdownMenuItem<Gender>(
                        key: const Key('gender_female'),
                        value: Gender.FEMALE,
                        child: Text(
                            isTest ? '' : AppLocalizations.of(context).female),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    return showDialog<Gender>(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }
}

// ignore: avoid_classes_with_only_static_members
class LanguageList {
  static final langs = {
    Dialogs.DEFAULT_COUNTRY: '',
    'US': 'English',
    'BR': 'Portuguese',
  };
}

// ignore: avoid_classes_with_only_static_members
class NationalityList {
  static final nats = {
    Dialogs.DEFAULT_COUNTRY: '',
    'AU': 'Australia',
    'BR': 'Brasil',
    'CA': 'Canada',
    'CH': 'Switzerland',
    'DE': 'Germany',
    'DK': 'Denmark',
    'ES': 'Spain',
    'FI': 'Finland',
    'FR': 'France',
    'GB': 'United Kingdom',
    'IE': 'Ireland',
    'IR': 'Iran',
    'NO': 'Norway',
    'NL': 'Netherlands',
    'NZ': 'New Zeland',
    'TR': 'Turkey',
    'US': 'United States',
  };
}
