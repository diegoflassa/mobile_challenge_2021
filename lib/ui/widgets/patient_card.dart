import 'dart:typed_data';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
import 'package:mobile_challenge_2021_flutter/data/entities/patient.dart';
import 'package:mobile_challenge_2021_flutter/enums/gender.dart';
import 'package:mobile_challenge_2021_flutter/helpers/constants.dart';
import 'package:mobile_challenge_2021_flutter/i18n/app_localizations.dart';
import 'package:mobile_challenge_2021_flutter/interfaces/card_actions_callbacks.dart';
import 'package:mobile_challenge_2021_flutter/real_main.dart';
import 'package:mobile_challenge_2021_flutter/resources/resources.dart';
import 'package:mobile_challenge_2021_flutter/ui/patients/patient_details.dart';

class PatientCard extends StatefulWidget {
  const PatientCard(this.patient, {Key? key, this.cardActionsCallbacks})
      : super(key: key);

  final Patient patient;
  final CardActionsCallbacks<Patient>? cardActionsCallbacks;

  @override
  _PatientCardState createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> {
  bool _gettingImage = false;
  bool _gotImage = false;
  int _triesGetImage = 0;
  int _gotDefaultImageTriesCount = 0;
  String _formattedBirthdate = '';
  String _formattedGender = '';

  Widget? _tileLeading;

  @override
  void initState() {
    super.initState();
    if (widget.patient.dateOfBirth.getDateAsDateTime() != null) {
      if (widget.patient.dateOfBirth.getDateAsDateTime() != null) {
        _formattedBirthdate = DateFormat.yMMMMd(MyApp.locale.toString())
            .format(widget.patient.dateOfBirth.getDateAsDateTime()!);
      } else {
        _formattedBirthdate = AppLocalizations.of(context).unavailable;
      }
    }
    _getImage();
  }

  @override
  Container build(BuildContext context) {
    if (_formattedGender.isEmpty) {
      _formattedGender = _getI18NedGender(context);
    }
    _getImage();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Card(
        //color: Colors.white,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: _tileLeading,
              title: Text(
                  '${AppLocalizations.of(context).name}: ${widget.patient.fullName.getFullName()}'),
              subtitle: _getGenderNationalityAndDobRow(),
              onTap: () async {
                widget.cardActionsCallbacks?.onView(widget.patient);
                await showDialog<PatientDetailsDialog>(
                    context: context,
                    builder: (context) {
                      return PatientDetailsDialog(widget.patient);
                    });
                widget.cardActionsCallbacks?.onViewed(widget.patient);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getI18NedGender(BuildContext context) {
    var ret = '';
    switch (widget.patient.getGenderAsEnum()) {
      case Gender.MALE:
        ret = AppLocalizations.of(context).male;
        break;
      case Gender.FEMALE:
        ret = AppLocalizations.of(context).female;
        break;
      case Gender.PREFER_NOT_TO_SAY:
        ret = AppLocalizations.of(context).preferNotToSay;
        break;
      case Gender.UNKNOWN:
        ret = AppLocalizations.of(context).unknown;
        break;
    }
    return ret;
  }

  Row _getGenderNationalityAndDobRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(_formattedGender,
              style: TextStyle(color: Colors.black.withOpacity(0.6))),
          Text(widget.patient.nationality,
              style: TextStyle(color: Colors.black.withOpacity(0.6))),
          Text(_formattedBirthdate,
              style: TextStyle(color: Colors.black.withOpacity(0.6))),
        ]);
  }

  Future<void> _getImage() async {
    if (!_gotImage &&
        !_gettingImage &&
        _triesGetImage < Constants.DEFAULT_GET_IMAGE_TRY_LIMIT) {
      _triesGetImage++;
      _gettingImage = true;
      if (widget.patient.picture.hasGotThumbnailImage()) {
        final bytes = await widget.patient.picture.getThumbnailImageBytes();
        _setImageAsBytes(bytes);
      } else if (widget.patient.picture.isGettingThumbnailImage()) {
        showLoadingImage();
        await widget.patient.picture.thumbnailAsBytesFuture?.then((value) {
          _setImageAsBytes(value);
          widget.patient.picture.thumbnailAsBytesFuture = null;
        });
      } else {
        showLoadingImage();
        await widget.patient.picture.getThumbnailImage().then((value) {
          _setImageAsBytes(value);
          widget.patient.picture.thumbnailAsBytesFuture = null;
        });
      }
      _gettingImage = false;
    }
  }

  void showLoadingImage() {
    setState(() {
      _tileLeading = _getLoadingImagePlaceholder();
    });
  }

  SizedBox _getLoadingImagePlaceholder() {
    return const SizedBox(
      width: Constants.DEFAULT_CARD_IMAGE_WIDTH,
      height: Constants.DEFAULT_CARD_IMAGE_HEIGHT,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  void _setImageAsBytes(Uint8List? bytes) {
    if (bytes != null && bytes.isNotEmpty) {
      _gotImage = true;
      if (mounted) {
        setState(
          () {
            final image = Image.memory(
              bytes,
              gaplessPlayback: true,
              key: UniqueKey(),
              fit: BoxFit.cover,
              width: Constants.DEFAULT_CARD_IMAGE_WIDTH,
              height: Constants.DEFAULT_CARD_IMAGE_HEIGHT,
            );
            final avatar = CircleAvatar(
              backgroundImage: image.image,
            );
            _tileLeading = avatar;
            precacheImage(image.image, context);
          },
        );
      }
    } else {
      if (mounted) {
        _gotDefaultImageTriesCount++;
        if (_gotDefaultImageTriesCount >
            Constants.DEFAULT_GET_IMAGE_TRY_LIMIT) {
          _gotDefaultImageTriesCount = 0;
          _gotImage = true;
        }
        setState(() {
          final image = Image(
            gaplessPlayback: true,
            image: const AssetImage(Images.noImage),
            key: UniqueKey(),
            fit: BoxFit.cover,
            width: Constants.DEFAULT_CARD_IMAGE_WIDTH,
            height: Constants.DEFAULT_CARD_IMAGE_HEIGHT,
          );
          _tileLeading = image;
          precacheImage(image.image, context);
        });
      }
    }
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Card for patient: ${widget.patient.fullName}. Additional info: ${super.toString(minLevel: minLevel)}.';
  }
}
