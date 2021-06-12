import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_challenge_2021_flutter/bloc/events/patients_events.dart';
import 'package:mobile_challenge_2021_flutter/bloc/states/patients_states.dart';
import 'package:mobile_challenge_2021_flutter/data/dao/patients_dao.dart';
import 'package:mobile_challenge_2021_flutter/data/entities/patient.dart';
import 'package:mobile_challenge_2021_flutter/helpers/constants.dart';
import 'package:mobile_challenge_2021_flutter/helpers/my_logger.dart';
import 'package:pedantic/pedantic.dart';

class PatientsBloc extends Bloc<PatientsEvents, PatientsStates> {
  PatientsBloc() : super(PatientsInitialState()) {
    _patientsEventController.stream.listen(mapEventToState);
  }

  PatientsDao patientsDao = PatientsDao();

  // init StreamController
  final _patientsStateController = StreamController<PatientsStates>();

  StreamSink<PatientsStates> get stateSink => _patientsStateController.sink;

  // expose data from stream
  Stream<PatientsStates> get streamStates => _patientsStateController.stream;

  final _patientsEventController = StreamController<PatientsEvents>();

  Sink<PatientsEvents> get patientsEventSink => _patientsEventController.sink;

  @override
  Stream<PatientsStates> mapEventToState(PatientsEvents event) async* {
    switch (event.runtimeType) {
      case PatientsInitialStateEvent:
        {
          yield PatientsInitialState();
        }
        break;

      case GetAllPatientsPaginatedAndOrderedEvent:
        {
          try {
            final eventCast = event as GetAllPatientsPaginatedAndOrderedEvent;
            yield GettingPatientsDataState<
                GetAllPatientsPaginatedAndOrderedEvent>(eventCast);
            final List<Patient> patients;
            var endOfList = false;
            patients = await patientsDao.getAllPaginated(
                eventCast.page, eventCast.pageSize);
            endOfList = patients.length < eventCast.pageSize;
            if (patients.isNotEmpty) {
              var idx = 0;
              for (final patient in patients) {
                if (eventCast.page == 1) {
                  if (idx < 5) {
                    unawaited(patient.picture.getAllImages());
                    idx++;
                  } else {
                    break;
                  }
                }
              }
              yield GotAllPatientsPaginatedAndOrderedState(
                  patients, endOfList, eventCast.page);
            } else {
              yield PatientsEmptyState();
            }
          } on Exception catch (ex) {
            MyLogger().logger.e(ex);
            yield GotPatientErrorState(ex);
          } on Error catch (ex) {
            MyLogger().logger.e(ex);
            yield GotPatientErrorState(ex);
          }
        }
        break;

      case SearchPatientsEvent:
        {
          try {
            final eventCast = event as SearchPatientsEvent;
            yield GettingPatientsDataState<SearchPatientsEvent>(eventCast);
            final patientsResult = await patientsDao.findAllPaginated(
                eventCast.query,
                page: eventCast.page,
                pageSize: eventCast.pageSize);
            if (patientsResult.patients.isNotEmpty) {
              var idx = 0;
              for (final patient in patientsResult.patients) {
                if (idx < Constants.DEFAULT_MAX_ITEMS_TO_GET_IMAGE) {
                  unawaited(patient.picture.getAllImages());
                  idx++;
                } else {
                  break;
                }
              }
            }
            yield SearchPatientsResultsState(patientsResult);
          } on Exception catch (ex) {
            MyLogger().logger.e(ex);
            yield GotPatientErrorState(ex);
          } on Error catch (ex) {
            MyLogger().logger.e(ex);
            yield GotPatientErrorState(ex);
          }
        }
        break;

      default:
        {
          final e = Exception('Event not supported ${event.runtimeType}');
          yield PatientErrorState(e);
        }
    }
  }

  @override
  Future<void> close() {
    _patientsStateController.close();
    _patientsEventController.close();
    return super.close();
  }
}
