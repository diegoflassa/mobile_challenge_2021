import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile_challenge_2021/data/entities/patient.dart';
import 'package:mobile_challenge_2021/extensions/uri_extensions.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mobile_challenge_2021/helpers/constants.dart';
import 'package:mobile_challenge_2021/helpers/helper.dart';
import 'package:mobile_challenge_2021/helpers/my_logger.dart';
import 'package:mobile_challenge_2021/i18n/app_localizations.dart';
import 'package:mobile_challenge_2021/models/patient_details_model.dart';
import 'package:mobile_challenge_2021/real_main.dart';
import 'package:mobile_challenge_2021/resources/resources.dart';
import 'package:mobile_challenge_2021/ui/themes/my_text_style.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class PatientDetailsDialog extends StatefulWidget {
  const PatientDetailsDialog(this.patient,
      {Key? key, this.title = Constants.APP_NAME, this.isTest = false})
      : super(key: key);

  static const String routeName = '/patientDetails';
  final Patient patient;
  final String? title;
  final bool isTest;

  @override
  _PatientDetailsDialogState createState() => _PatientDetailsDialogState();
}

// 🚀Global Functional Injection
// This state will be auto-disposed when no longer used, and also testable and mockable.
final model = RM.inject<PatientDetailsModel>(
  () => PatientDetailsModel(),
  undoStackLength: Constants.DEFAULT_UNDO_STACK_LENGTH,
  //Called after new state calculation and just before state mutation
  middleSnapState: (middleSnap) {
    //Log all state transition.
    MyLogger().logger.i(middleSnap.currentSnap);
    MyLogger().logger.i(middleSnap.nextSnap);

    MyLogger().logger.i('');
    middleSnap.print(preMessage: '[PatientDetailsModel]'); //Build-in logger
    //Can return another state
  },
  onDisposed: (state) => MyLogger().logger.i('[PatientDetailsModel]Disposed'),
);

class _PatientDetailsDialogState extends State<PatientDetailsDialog> {
  late final AssetImage _imagePlaceholder;
  late double pixelRatio;
  Uri? _imageUrl;
  Widget _image = const Image(
    image: AssetImage(Images.noImage),
    fit: BoxFit.cover,
  );
  bool _gettingImage = false;
  bool _gotImage = false;
  bool _gotDefaultImage = false;
  int _gotDefaultImageTriesCount = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(Constants.DEFAULT_EDGE_INSETS_BORDER_RADIUS),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(),
      child: _buildBody(context),
    );
  }

  @override
  void initState() {
    super.initState();
    // Exhaustively handle all four status
    On.all(
      // If is Idle
      onIdle: () => MyLogger().logger.i('[PatientDetailsModel]Idle'),
      // If is waiting
      onWaiting: () => MyLogger().logger.i('[PatientDetailsModel]Waiting'),
      // If has error
      onError: (dynamic err, refresh) => MyLogger()
          .logger
          .e('[PatientDetailsModel]Error:$err. Refresh:$refresh'),
      // If has Data
      onData: () => MyLogger().logger.i('[PatientDetailsModel]Data'),
    );

    _imagePlaceholder = const AssetImage(Images.noImage);
    _imageUrl = widget.patient.picture.mediumUrl;
    _getImage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildBody(BuildContext context) {
    final ret = Center(
      child: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.loose(const Size(640, double.infinity)),
            padding: const EdgeInsets.only(
                left: Constants.DEFAULT_EDGE_INSETS_HORIZONTAL,
                top: Constants.DEFAULT_AVATAR_RADIUS +
                    Constants.DEFAULT_EDGE_INSETS_VERTICAL,
                right: Constants.DEFAULT_EDGE_INSETS_HORIZONTAL,
                bottom: Constants.DEFAULT_EDGE_INSETS_VERTICAL),
            margin: const EdgeInsets.only(top: Constants.DEFAULT_AVATAR_RADIUS),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(offset: Offset(0, 10), blurRadius: 10),
            ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                    width: 1, height: Constants.DEFAULT_EDGE_INSETS_VERTICAL),
                _getFullName(),
                const SizedBox(
                    width: 1,
                    height: Constants.DEFAULT_EDGE_INSETS_VERTICAL * 2),
                _getEmail(),
                const SizedBox(
                    width: 1, height: Constants.DEFAULT_EDGE_INSETS_VERTICAL),
                _getTelephone(),
                const SizedBox(
                    width: 1, height: Constants.DEFAULT_EDGE_INSETS_VERTICAL),
                _getCellphone(),
                const SizedBox(
                    width: 1, height: Constants.DEFAULT_EDGE_INSETS_VERTICAL),
                _getGender(),
                const SizedBox(
                    width: 1, height: Constants.DEFAULT_EDGE_INSETS_VERTICAL),
                _getNationality(),
                const SizedBox(
                    width: 1, height: Constants.DEFAULT_EDGE_INSETS_VERTICAL),
                _getDateOfBirth(),
                const SizedBox(
                    width: 1, height: Constants.DEFAULT_EDGE_INSETS_VERTICAL),
                _getAddress(),
                const SizedBox(
                    width: 1, height: Constants.DEFAULT_EDGE_INSETS_VERTICAL),
              ],
            ),
          ),
          _getCloseButton(),
          _getUpperImage(),
        ],
      ),
    );
    return ret;
  }

  Widget _getUpperImage() {
    return // bottom part
        Positioned(
      left: Constants.DEFAULT_EDGE_INSETS_HORIZONTAL,
      right: Constants.DEFAULT_EDGE_INSETS_HORIZONTAL,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: Constants.DEFAULT_AVATAR_RADIUS,
        child: ClipRRect(
            borderRadius: const BorderRadius.all(
                Radius.circular(Constants.DEFAULT_AVATAR_RADIUS)),
            child: _image),
      ),
    );
  }

  Widget _getCloseButton() {
    return Positioned(
      top: Constants.DEFAULT_AVATAR_RADIUS,
      right: 0,
      child: IconButton(
        onPressed: () {
          Navigator.of(context).pop(null);
        },
        icon: SvgPicture.asset('assets/images/font_awesome/solid/times.svg',
            color: Colors.brown,
            placeholderBuilder: (context) => const SizedBox(
                width: Constants.DEFAULT_DIALOG_DISMISS_ICON_WIDTH,
                height: Constants.DEFAULT_DIALOG_DISMISS_ICON_HEIGHT,
                child: FittedBox(
                    fit: BoxFit.scaleDown, child: CircularProgressIndicator())),
            width: Constants.DEFAULT_DIALOG_DISMISS_ICON_WIDTH,
            height: Constants.DEFAULT_DIALOG_DISMISS_ICON_HEIGHT),
      ),
    );
  }

  Center _getFullName() {
    return Center(
      child: Text(
        widget.patient.fullName.getFullName(),
        style: const MyTextStyle.title(),
      ),
    );
  }

  Text _getEmail() {
    return Text(
        '${widget.isTest ? '' : AppLocalizations.of(context).email}: ${widget.patient.email}');
  }

  Text _getTelephone() {
    return Text(
        '${widget.isTest ? '' : AppLocalizations.of(context).telephone}: ${widget.patient.telephone}');
  }

  Text _getCellphone() {
    return Text(
        '${widget.isTest ? '' : AppLocalizations.of(context).cellphone}: ${widget.patient.cellphone}');
  }

  Text _getGender() {
    return Text(
        '${widget.isTest ? '' : AppLocalizations.of(context).gender}: ${widget.isTest ? 'male' : Helper.genderEnumToString(context, Helper.genderStringToEnum(widget.patient.gender))}');
  }

  Text _getNationality() {
    return Text(
        '${widget.isTest ? '' : AppLocalizations.of(context).nationality}: ${widget.patient.nationality}');
  }

  Text _getDateOfBirth() {
    return Text(
        '${widget.isTest ? '' : AppLocalizations.of(context).dob}: ${DateFormat.yMMMMd(MyApp.locale.toString()).format(widget.patient.dateOfBirth.getDateAsDateTime()!)}');
  }

  Text _getAddress() {
    return Text(
        '${widget.isTest ? '' : AppLocalizations.of(context).address}: ${widget.patient.address.getFullAddress()}');
  }

  Future<void> _getImage() async {
    if (!_gotDefaultImage && !_gotImage && !_gettingImage) {
      _gettingImage = true;
      if (widget.patient.picture.hasGotMediumImage()) {
        final bytes = await widget.patient.picture.getMediumImageBytes();
        _setImageAsBytes(bytes);
        _gettingImage = false;
      } else if (widget.patient.picture.isGettingMediumImage()) {
        showLoadingImage();
        await widget.patient.picture.mediumAsBytesFuture!.then((bytes) async {
          _setImageAsBytes(bytes);
          widget.patient.picture.mediumAsBytesFuture = null;
          _gettingImage = false;
        });
      } else {
        showLoadingImage();
        if (_imageUrl != null && _imageUrl!.path.isNotEmpty) {
          final bytes = await _imageUrl!.downloadBytes();
          _setImageAsBytes(bytes);
        } else {
          _setImageAsBytes(null);
        }
        _gettingImage = false;
      }
    }
  }

  void showLoadingImage() {
    _image = _getLoadingImagePlaceholder();
    setState(() {});
  }

  SizedBox _getLoadingImagePlaceholder() {
    return const SizedBox(
      width: 581.0,
      height: 587.0,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _setImageAsBytes(Uint8List? bytes) {
    if (bytes != null && bytes.isNotEmpty) {
      _gotImage = true;
      _image = Image.memory(
        bytes,
        key: UniqueKey(),
        fit: BoxFit.scaleDown,
      );
      if (mounted) {
        setState(() {});
      }
    } else {
      _gotDefaultImageTriesCount++;
      if (_gotDefaultImageTriesCount > Constants.DEFAULT_GET_IMAGE_TRY_LIMIT) {
        _gotDefaultImageTriesCount = 0;
        _gotDefaultImage = true;
      }
      _image = Image(
        image: _imagePlaceholder,
        fit: BoxFit.cover,
      );
      if (mounted) {
        setState(() {});
      }
    }
  }
}
