import 'dart:async';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
import 'package:mobile_challenge_2021/l10n/messages_all.dart';

class AppLocalizations {
  String get all {
    return Intl.message('All', name: 'all');
  }

  String get dob {
    return Intl.message('Date of Birth', name: 'dob');
  }

  String get address {
    return Intl.message('Address', name: 'address');
  }

  String get email {
    return Intl.message('Email', name: 'email');
  }

  String get telephone {
    return Intl.message('Telephone', name: 'telephone');
  }

  String get cellphone {
    return Intl.message('Cellphone', name: 'cellphone');
  }

  String get reset {
    return Intl.message('Reset', name: 'reset');
  }

  String get select {
    return Intl.message('Select', name: 'select');
  }

  String get genderTitle {
    return Intl.message('Select the desired Gender', name: 'genderTitle');
  }

  String get genderMessage {
    return Intl.message('Select "any" if no gender filter should be applied',
        name: 'genderMessage');
  }

  String get any {
    return Intl.message('Any', name: 'any');
  }

  String get gender {
    return Intl.message('Gender', name: 'gender');
  }

  String get fullName {
    return Intl.message('Name', name: 'fullName');
  }

  String get languages {
    return Intl.message('Languages', name: 'languages');
  }

  String get unavailable {
    return Intl.message('Unavailable', name: 'unavailable');
  }

  String get selectNationality {
    return Intl.message('Select the Nationality', name: 'selectNationality');
  }

  String get selectYourLanguage {
    return Intl.message('Select your Language', name: 'selectYourLanguage');
  }

  String get search {
    return Intl.message('Search', name: 'search');
  }

  String get defaultLanguage {
    return Intl.message('Default Language', name: 'defaultLanguage');
  }

  String get languageSelectionTitle {
    return Intl.message('Language Selection', name: 'languageSelectionTitle');
  }

  String get languageSelectionSubtitle {
    return Intl.message('Current Locale:', name: 'languageSelectionSubtitle');
  }

  String get name {
    return Intl.message('Name', name: 'name');
  }

  String get male {
    return Intl.message('Male', name: 'male');
  }

  String get female {
    return Intl.message('Female', name: 'female');
  }

  String get preferNotToSay {
    return Intl.message('Prefer not to say', name: 'preferNotToSay');
  }

  String get confirm {
    return Intl.message('Confirm', name: 'confirm');
  }

  String get cancel {
    return Intl.message('Cancel', name: 'cancel');
  }

  String get currentValue {
    return Intl.message('Current Value:', name: 'currentValue');
  }

  String get stateNotSupportedError {
    return Intl.message('State Not Supported Error',
        name: 'stateNotSupportedError');
  }

  String get empty {
    return Intl.message('Empty', name: 'empty');
  }

  String get searchPatient {
    return Intl.message('Search Patient', name: 'searchPatient');
  }

  String get licenses {
    return Intl.message('Licenses', name: 'licenses');
  }

  String get settings {
    return Intl.message('Settings', name: 'settings');
  }

  String get performanceOverlay {
    return Intl.message('Performance Overlay', name: 'performanceOverlay');
  }

  String get materialGrid {
    return Intl.message('Material Grid', name: 'materialGrid');
  }

  String get semanticsDebugger {
    return Intl.message('Semantics Debugger', name: 'semanticsDebugger');
  }

  String get loadingPatients {
    return Intl.message('Loading Patients', name: 'loadingPatients');
  }

  String get ascending {
    return Intl.message('Ascending', name: 'ascending');
  }

  String get descending {
    return Intl.message('Descending', name: 'descending');
  }

  String get random {
    return Intl.message('Random', name: 'random');
  }

  String get id {
    return Intl.message('Id', name: 'id');
  }

  String get alphabetically {
    return Intl.message('Alphabetically', name: 'alphabetically');
  }

  String get birthdate {
    return Intl.message('Birthdate', name: 'birthdate');
  }

  String get nationality {
    return Intl.message('Nationality', name: 'nationality');
  }

  String get loading {
    return Intl.message('Loading...', name: 'loading');
  }

  String get loadingPatient {
    return Intl.message('Loading Patient', name: 'loadingPatient');
  }

  String get reloadingIn {
    return Intl.message('Reloading in', name: 'reloadingIn');
  }

  String get thisPageShouldNotBeVisible {
    return Intl.message('This page should not be visible',
        name: 'thisPageShouldNotBeVisible');
  }

  String get noPatientFound {
    return Intl.message('No patient found', name: 'noPatientFound');
  }

  String get emptyItems {
    return Intl.message('No items found', name: 'emptyItems');
  }

  String get error {
    return Intl.message('Error', name: 'error');
  }

  String get unknown {
    return Intl.message('Unknown', name: 'unknown');
  }

  String get appName {
    return Intl.message('Patients Viewer', name: 'appName');
  }

  static Future<AppLocalizations> load(Locale locale) {
    final name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}
