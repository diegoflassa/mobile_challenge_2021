import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_challenge_2021_flutter/helpers/constants.dart';
import 'package:mobile_challenge_2021_flutter/helpers/dialogs.dart';
import 'package:mobile_challenge_2021_flutter/helpers/helper.dart';
import 'package:mobile_challenge_2021_flutter/helpers/my_logger.dart';
import 'package:mobile_challenge_2021_flutter/i18n/app_localizations.dart';
import 'package:mobile_challenge_2021_flutter/interfaces/on_search.dart';
import 'package:mobile_challenge_2021_flutter/models/search_bar_model.dart';
import 'package:mobile_challenge_2021_flutter/ui/themes/my_color_scheme.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({required this.onSearch, this.isTest = false, Key? key})
      : super(key: key);

  final OnSearch onSearch;
  final bool isTest;

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

// 🚀Global Functional Injection
// This state will be auto-disposed when no longer used, and also testable and mockable.
final model = RM.inject<SearchBarModel>(
  () => SearchBarModel(),
  undoStackLength: Constants.DEFAULT_UNDO_STACK_LENGTH,
  //Called after new state calculation and just before state mutation
  middleSnapState: (middleSnap) {
    //Log all state transition.
    MyLogger().logger.i(middleSnap.currentSnap);
    MyLogger().logger.i(middleSnap.nextSnap);

    MyLogger().logger.i('');
    middleSnap.print(preMessage: '[SearchBarModel]'); //Build-in logger
    //Can return another state
  },
  onDisposed: (state) => MyLogger().logger.i('[SearchBarModel]Disposed'),
);

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _focusNodeSearchField = FocusNode();
  final _searchQueryController = TextEditingController();
  bool _wasCleared = false;

  @override
  void initState() {
    _searchQueryController.text = model.state.query;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_wasCleared) {
      _wasCleared = true;
      if (!widget.isTest) {
        model.state.clear(context);
      }
    }
    return _getSearchInterface();
  }

  Column _getSearchInterface() {
    return Column(
      children: <Widget>[
        _getFullNameSearchRow(),
        _getGenderAndNationalityRow(),
      ],
    );
  }

  Row _getFullNameSearchRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          height: Constants.DEFAULT_EDGE_INSETS_VERTICAL,
          width: 1,
        ),
        _getSearchInput(),
        const SizedBox(
          height: 1,
          width: Constants.DEFAULT_EDGE_INSETS_HORIZONTAL_QUARTER,
        ),
        _getSearchButtonInput(),
      ],
    );
  }

  Row _getGenderAndNationalityRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          key: const Key('button_nationality'),
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    Constants.DEFAULT_EDGE_INSETS_BORDER_RADIUS),
              ),
            ),
          ),
          onPressed: () {
            setState(() {
              model.state.nationality =
                  widget.isTest ? '' : AppLocalizations.of(context).all;
            });
            Dialogs.showNationalityPickerDialog(context, (value) {
              setState(() {
                model.state.nationality = value.countryCode;
              });
            });
          },
          child: Text(widget.isTest
              ? ''
              : '${AppLocalizations.of(context).nationality}: ${model.state.nationality}'),
        ),
        ElevatedButton(
          key: const Key('button_gender'),
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    Constants.DEFAULT_EDGE_INSETS_BORDER_RADIUS),
              ),
            ),
          ),
          onPressed: () async {
            final gender = await Dialogs.showGenderPickerDialog(
                context, model.state.gender,
                isTest: widget.isTest);
            if (gender != null) {
              setState(() {
                model.state.gender = gender;
              });
            }
          },
          child: Text(widget.isTest
              ? ''
              : '${AppLocalizations.of(context).gender}: ${Helper.genderEnumToString(context, model.state.gender, unknownAsBoth: true)}'),
        ),
        ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    Constants.DEFAULT_EDGE_INSETS_BORDER_RADIUS),
              ),
            ),
          ),
          onPressed: () async {
            setState(() {
              _searchQueryController.clear();
              model.state.clear(context);
              widget.onSearch.clear();
            });
          },
          child: Text(widget.isTest ? '' : AppLocalizations.of(context).reset),
        ),
      ],
    );
  }

  Widget _getSearchInput() {
    return Expanded(
      child: TextField(
        key: const Key('search_input'),
        autofocus: true,
        focusNode: _focusNodeSearchField,
        cursorColor: Colors.white,
        controller: _searchQueryController,
        decoration: InputDecoration(
          isDense: true,
          fillColor: MyColorScheme().primary,
          hintText: widget.isTest ? '' : AppLocalizations.of(context).fullName,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                Constants.DEFAULT_EDGE_INSETS_BORDER_RADIUS),
            borderSide: BorderSide(color: MyColorScheme().primary, width: 5.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                Constants.DEFAULT_EDGE_INSETS_BORDER_RADIUS),
            borderSide: BorderSide(color: MyColorScheme().primary, width: 5.0),
          ),
          hintStyle: const TextStyle(color: Colors.white30),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(
                right: Constants.DEFAULT_EDGE_INSETS_HORIZONTAL),
            child: SvgPicture.asset(
                'assets/images/font_awesome/solid/user-tag.svg',
                color: Colors.white,
                placeholderBuilder: (context) => const SizedBox(
                    width: Constants.DEFAULT_SEARCH_SUFFIX_ICON_WIDTH,
                    height: Constants.DEFAULT_SEARCH_SUFFIX_ICON_HEIGHT,
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CircularProgressIndicator())),
                width: Constants.DEFAULT_SEARCH_SUFFIX_ICON_WIDTH,
                height: Constants.DEFAULT_SEARCH_SUFFIX_ICON_HEIGHT),
          ),
          suffixIconConstraints: const BoxConstraints(
              maxHeight: Constants.DEFAULT_SEARCH_SUFFIX_ICON_HEIGHT,
              maxWidth: Constants.DEFAULT_SEARCH_SUFFIX_ICON_WIDTH,
              minHeight: Constants.DEFAULT_SEARCH_SUFFIX_ICON_HEIGHT,
              minWidth: Constants.DEFAULT_SEARCH_SUFFIX_ICON_WIDTH),
        ),
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  ElevatedButton _getSearchButtonInput() {
    final picture = SizedBox(
      width: Constants.DEFAULT_SEARCH_ICON_WIDTH,
      height: Constants.DEFAULT_SEARCH_ICON_HEIGHT,
      child: SvgPicture.asset('assets/images/font_awesome/solid/filter.svg',
          color: Colors.white,
          placeholderBuilder: (context) => const SizedBox(
              width: Constants.DEFAULT_SEARCH_ICON_WIDTH,
              height: Constants.DEFAULT_SEARCH_ICON_HEIGHT,
              child: FittedBox(
                  fit: BoxFit.scaleDown, child: CircularProgressIndicator())),
          width: Constants.DEFAULT_SEARCH_ICON_WIDTH,
          height: Constants.DEFAULT_SEARCH_ICON_HEIGHT),
    );
    return ElevatedButton(
      key: const Key('search_button'),
      onPressed: () {
        model.state.query = _searchQueryController.text;
        widget.onSearch.onSearch(
            query: _searchQueryController.text,
            nationality: model.state.nationality,
            gender: model.state.gender);
      },
      child: picture,
    );
  }
}
