// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mobile_challenge_2021_flutter/data/entities/patient.dart';
import 'package:mobile_challenge_2021_flutter/real_main.dart';
import 'package:mobile_challenge_2021_flutter/ui/patients/patient_details.dart';

void main() {
  Patient _getPatient() {
    final ret = Patient();
    ret.fullName.title = 'Mister';
    ret.fullName.first = 'Test';
    ret.fullName.last = 'Of Program';
    ret.telephone = '0011992200';
    ret.cellphone = '0011999999';
    ret.gender = 'male';
    ret.nationality = 'BR';
    ret.dateOfBirth.date = '2002-05-21T10:59:49.966Z';
    ret.address.state = 'SP';
    ret.address.city = 'Campinas';
    ret.address.street.name = 'Street Name';
    ret.address.street.number = 5678;
    ret.address.postCode = '13060-123';
    return ret;
  }

  MediaQuery _buildAppWithPatientDetailsDialog(
      Patient patient, PatientDetailsDialog dialog,
      {ThemeData? theme}) {
    return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
        theme: theme,
        home: Material(
          child: Builder(
            builder: (context) {
              return Center(
                child: ElevatedButton(
                  key: const Key('Test'),
                  onPressed: () {
                    showDialog<PatientDetailsDialog>(
                        context: context,
                        builder: (context) {
                          return dialog;
                        });
                  },
                  child: const Text('X'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  testWidgets(
    'Patient Details test',
    (tester) async {
      final patient = _getPatient();
      final dialog = PatientDetailsDialog(patient, isTest: true);
      // Build our app and trigger a frame.
      await tester
          .pumpWidget(_buildAppWithPatientDetailsDialog(patient, dialog));

      await tester.tap(find.text('X'));
      await tester.pumpAndSettle();
      expect(find.text(patient.fullName.getFullName()), findsOneWidget);
      expect(find.text(': ${patient.telephone}'), findsOneWidget);
      expect(find.text(': ${patient.cellphone}'), findsOneWidget);
      expect(find.text(': ${patient.gender}'), findsOneWidget);
      expect(find.text(': ${patient.nationality}'), findsOneWidget);
      expect(
          find.text(
              ': ${DateFormat.yMMMMd(MyApp.locale.toString()).format(patient.dateOfBirth.getDateAsDateTime()!)}'),
          findsOneWidget);
      expect(
          find.text(': ${patient.address.getFullAddress()}'), findsOneWidget);
    },
  );
}
