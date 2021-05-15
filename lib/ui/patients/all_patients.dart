import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_challenge_2021/bloc/events/patients_events.dart';
import 'package:mobile_challenge_2021/bloc/patients_bloc.dart';
import 'package:mobile_challenge_2021/bloc/states/patients_states.dart';
import 'package:mobile_challenge_2021/data/entities/patient.dart';
import 'package:mobile_challenge_2021/enums/gender.dart';
import 'package:mobile_challenge_2021/enums/query_fields.dart';
import 'package:mobile_challenge_2021/extensions/build_context_extensions.dart';
import 'package:mobile_challenge_2021/extensions/list_extensions.dart';
import 'package:mobile_challenge_2021/helpers/constants.dart';
import 'package:mobile_challenge_2021/helpers/helper.dart';
import 'package:mobile_challenge_2021/helpers/my_logger.dart';
import 'package:mobile_challenge_2021/i18n/app_localizations.dart';
import 'package:mobile_challenge_2021/interfaces/card_actions_callbacks.dart';
import 'package:mobile_challenge_2021/interfaces/on_search.dart';
import 'package:mobile_challenge_2021/models/all_patients_model.dart';
import 'package:mobile_challenge_2021/ui/my_scaffold.dart';
import 'package:mobile_challenge_2021/ui/pages/empty_items_page.dart';
import 'package:mobile_challenge_2021/ui/pages/error_page.dart';
import 'package:mobile_challenge_2021/ui/themes/my_color_scheme.dart';
import 'package:mobile_challenge_2021/ui/widgets/loading_card.dart';
import 'package:mobile_challenge_2021/ui/widgets/patient_card.dart';
import 'package:mobile_challenge_2021/ui/widgets/search_bar_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class AllPatientsPage extends StatefulWidget {
  const AllPatientsPage({Key? key, this.title = Constants.APP_NAME})
      : super(key: key);

  static Route<dynamic> route(String title) {
    return MaterialPageRoute<dynamic>(
        builder: (context) => AllPatientsPage(title: title));
  }

  static const String routeName = '/viewPatients';
  final String? title;

  @override
  _AllPatientsPageState createState() => _AllPatientsPageState();
}

// 🚀Global Functional Injection
// This state will be auto-disposed when no longer used, and also testable and mockable.
final model = RM.inject<AllPatientsModel>(
  () => AllPatientsModel(),
  undoStackLength: Constants.DEFAULT_UNDO_STACK_LENGTH,
  //Called after new state calculation and just before state mutation
  middleSnapState: (middleSnap) {
    //Log all state transition.
    MyLogger().logger.i(middleSnap.currentSnap);
    MyLogger().logger.i(middleSnap.nextSnap);

    MyLogger().logger.i('');
    middleSnap.print(preMessage: '[ViewPatientsModel]'); //Build-in logger
    //Can return another state
  },
  onDisposed: (state) => MyLogger().logger.i('[ViewPatientsModel]Disposed'),
);

class _AllPatientsPageState extends State<AllPatientsPage>
    implements CardActionsCallbacks<Patient>, OnSearch {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 5.0);

  @override
  void initState() {
    super.initState();

    // Exhaustively handle all four status
    On.all(
      // If is Idle
      onIdle: () => MyLogger().logger.i('[ViewPatientsModel]Idle'),
      // If is waiting
      onWaiting: () => MyLogger().logger.i('[ViewPatientsModel]Waiting'),
      // If has error
      onError: (dynamic err, refresh) => MyLogger()
          .logger
          .e('[ViewPatientsModel]Error:$err. Refresh:$refresh'),
      // If has Data
      onData: () => MyLogger().logger.i('[ViewPatientsModel]Data'),
    );

    _processRoutingData(context);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = MyScaffold(
      title: (widget.title != null) ? widget.title : '',
      body: Builder(
        builder: _buildBody,
      ),
    );
    return scaffold;
  }

  bool _listenWhenFilter(
      PatientsStates previousState, PatientsStates currentState) {
    return context.isCurrent(this) &&
        (previousState != currentState) &&
        (currentState is! PatientsInitialState) &&
        (currentState is! GettingPatientsDataState) &&
        (currentState is! PatientsEmptyState) &&
        (currentState is! SearchPatientsResultsState) &&
        (currentState is! PatientErrorState) &&
        (currentState is! GotPatientErrorState);
  }

  bool _buildWhenFilter(
      PatientsStates previousState, PatientsStates currentState) {
    return context.isCurrent(this) && (previousState != currentState);
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<PatientsBloc, PatientsStates>(
      listenWhen: (previousState, currentState) {
        final listen = _listenWhenFilter(previousState, currentState);
        MyLogger().logger.d(
            '[ViewPatients]listenWhen. Received previous state -> $previousState. Current state -> $currentState. Listen:$listen');
        return listen;
      },
      buildWhen: (previousState, currentState) {
        final build = _buildWhenFilter(previousState, currentState);
        MyLogger().logger.d(
            '[ViewPatients]buildWhen. Received previous state -> $previousState. Current state -> $currentState. Build:$build');
        return build;
      },
      listener: (context, state) {},
      builder: (context, state) {
        if (model.state.shouldReload) {
          _reloadPatients(context, 0);
          model.state.shouldReload = false;
        }
        MyLogger()
            .logger
            .d('[ViewPatients]builder. Received state -> ${state.toString()}');
        Widget ret = ErrorPage(
            exception: Exception(
                '${AppLocalizations.of(context).thisPageShouldNotBeVisible}. State: ${state.toString()}'));
        if (state is PatientsEmptyState) {
          ret = EmptyItemsPage(
              countDownMessage: AppLocalizations.of(context).reloadingIn,
              secondsToGo: Constants.DEFAULT_SECONDS_TO_RELOAD_PAGE);
          model.state.patients = <Patient>[];
          _reloadPatients(context, Constants.DEFAULT_SECONDS_TO_RELOAD_PAGE);
        } else if (state is GotPatientErrorState) {
          model.state.patients = <Patient>[];
          ret = ErrorPage(
              exception: state.e,
              countDownMessage: AppLocalizations.of(context).reloadingIn,
              secondsToGo: Constants.DEFAULT_SECONDS_TO_RELOAD_PAGE);
          _reloadPatients(context, Constants.DEFAULT_SECONDS_TO_RELOAD_PAGE);
          model.state.patients = <Patient>[];
        } else if (model.state.patients.isNotEmpty ||
            state is PatientsInitialState ||
            state is GotAllPatientsPaginatedAndOrderedState ||
            state is GettingPatientsDataState ||
            state is SearchPatientsResultsState) {
          if (state is GotAllPatientsPaginatedAndOrderedState) {
            model.state.endOfItems = state.endOfList;
            if (model.state.clearPatientsByState ==
                    GotAllPatientsPaginatedAndOrderedState ||
                state.page == 1) {
              model.state.patients.clear();
              model.state.clearPatientsByState = null;
            }
            if (model.state.waitForFirstPage) {
              model.state.waitForFirstPage = false;
              if (state.page == 1) {
                model.state.patients.addAllUnique(state.patients);
              }
            } else {
              model.state.patients.addAllUnique(state.patients);
            }
            model.state.isLoading = false;
          } else if (state is SearchPatientsResultsState) {
            if (model.state.clearPatientsByState ==
                SearchPatientsResultsState) {
              model.state.patients.clear();
              model.state.clearPatientsByState = null;
            }
            model.state.patients.addAllUnique(state.result.patients);
            model.state.currentPage = state.result.lastSearchedPage;
            model.state.isLoading = false;
          }
          model.state.patientsAsCards =
              _getListOfPatientsAsCards(model.state.patients);

          ret = model.state.patientsAsCards.isNotEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Scrollbar(
                    controller: _scrollController,
                    child: CustomScrollView(
                      shrinkWrap: true,
                      controller: _scrollController,
                      slivers: <Widget>[
                        if (model.state.patientsAsCards.isNotEmpty)
                          SliverAppBar(
                            toolbarHeight: 150,
                            backgroundColor: MyColorScheme().background,
                            titleSpacing: Constants.DEFAULT_TITLE_SPACING,
                            title: SearchBarWidget(onSearch: this),
                            pinned: true,
                          ),
                        // Build the items lazily
                        SliverGrid(
                          key: const Key('patients_list'),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: (MediaQuery.of(context).size.width /
                                    Constants.DEFAULT_CARD_WIDTH)
                                .round(),
                            mainAxisSpacing:
                                Constants.DEFAULT_CARD_MAIN_AXIS_SPACING,
                            crossAxisSpacing:
                                Constants.DEFAULT_CARD_CROSS_AXIS_SPACING,
                            childAspectRatio:
                                Constants.DEFAULT_CARD_ASPECT_RATIO,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return model.state.patientsAsCards[index];
                            },
                            childCount: model.state.patientsAsCards.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const EmptyItemsPage();
        }

        if (ret is ErrorPage) {
          MyLogger().logger.e(
              '[ViewPatients]Error page for state: ${state.toString()}. Exception: ${ret.exception.toString()} ${(ret.exception is Error) ? (ret.exception as Error).stackTrace.toString() : ""}');
        }
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          if (_scrollController.hasClients &&
              model.state.previousMaxScrollExtent !=
                  _scrollController.position.maxScrollExtent &&
              _scrollController.position.maxScrollExtent <=
                  _scrollController.position.viewportDimension &&
              !model.state.isLoading &&
              !model.state.endOfItems &&
              !model.state.isFromQuery) {
            model.state.previousMaxScrollExtent =
                _scrollController.position.maxScrollExtent;
            model.state.loadMore = true;
            _scrollListener();
          }
        });
        return RefreshIndicator(onRefresh: _refreshData, child: ret);
      },
    );
  }

  Future<void> _refreshData() async {
    await Future<void>.delayed(
        const Duration(milliseconds: Constants.DEFAULT_DELAY_TO_REFRESH_DATA));
    model.state.waitForFirstPage = true;
    await _reloadPatients(context, 0);
    setState(() {});
  }

  List<Widget> _getListOfPatientsAsCards(List<Patient> patients) {
    model.state.patientsAsCards.clear();
    final myPatients = <Widget>[];
    for (final patient in patients) {
      myPatients.add(PatientCard(
        patient,
        cardActionsCallbacks: this,
        key: UniqueKey(),
      ));
    }
    if (!model.state.endOfItems) {
      myPatients.add(const LoadingCard());
    }
    return model.state.patientsAsCards = myPatients;
  }

  void _scrollToLastPosition() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(model.state.scrollPosition);
    }
  }

  void _scrollListener() {
    if (model.state.loadMore ||
        (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange)) {
      if (!model.state.endOfItems) {
        setState(() {
          MyLogger().logger.d('comes to bottom $model.state.isLoading');
          if (!model.state.isLoading) {
            model.state.isLoading = true;
            MyLogger().logger.d('Loading more');
            PatientsEvents? event;
            if (model.state.isFromQuery) {
              event = SearchPatientsEvent(
                model.state.queryFields,
                page: ++model.state.currentPage,
              );
            } else {
              event = GetAllPatientsPaginatedAndOrderedEvent(
                page: ++model.state.currentPage,
              );
            }
            model.state.scrollPosition = _scrollController.offset;
            if (context.isCurrent(this)) {
              BlocProvider.of<PatientsBloc>(context).add(event);
            }
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              Future.delayed(
                  const Duration(
                      milliseconds: Constants.DEFAULT_SCROLL_TO_BOTTOM_DELAY),
                  _scrollToLastPosition);
            });
          }
        });
      }
    }
  }

  Future<void> _reloadPatients(BuildContext context, int delay) {
    return Future.delayed(Duration(seconds: delay), () {
      _processRoutingData(context);
    });
  }

  void _processRoutingData(BuildContext context) {
    model.state.currentPage = 1;
    if (!model.state.isFromQuery) {
      BlocProvider.of<PatientsBloc>(context)
          .add(GetAllPatientsPaginatedAndOrderedEvent());
      model.state.clearPatientsByState = GotAllPatientsPaginatedAndOrderedState;
    }
  }

  @override
  void onView(Patient element) {
    // Do nothing
  }

  @override
  void onViewed(Patient element) {
    model.state.shouldReload = true;
  }

  @override
  void onSearch(
      {String? query, String? nationality, Gender gender = Gender.UNKNOWN}) {
    final queryFields = <QueryFields, String>{};
    if (query != null && query.isNotEmpty) {
      queryFields[QueryFields.FULL_NAME] = query;
    }
    if (nationality != null && nationality.isNotEmpty) {
      queryFields[QueryFields.NATIONALITY] = nationality;
    }
    if (gender != Gender.UNKNOWN) {
      queryFields[QueryFields.GENDER] =
          Helper.genderEnumToString(context, gender);
    }
    if (queryFields.isNotEmpty) {
      model.state.queryFields = queryFields;
      model.state.isFromQuery = true;
      model.state.clearPatientsByState = SearchPatientsResultsState;
      BlocProvider.of<PatientsBloc>(context)
          .add(SearchPatientsEvent(queryFields));
    }
  }

  @override
  void clear() {
    model.state.isFromQuery = false;
    _processRoutingData(context);
  }
}
