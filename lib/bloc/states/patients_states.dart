import 'package:equatable/equatable.dart';
import 'package:mobile_challenge_2021_flutter/bloc/events/patients_events.dart';
import 'package:mobile_challenge_2021_flutter/data/dao/patients_dao.dart';
import 'package:mobile_challenge_2021_flutter/data/entities/patient.dart';

abstract class PatientsStates extends Equatable {
  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return 'PatientsStates';
  }
}

class PatientsInitialState extends PatientsStates {
  PatientsInitialState() : super();

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return 'PatientsInitialState';
  }
}

class GettingPatientsDataState<T extends PatientsEvents>
    extends PatientsStates {
  GettingPatientsDataState(this.event) : super();

  @override
  List<Object?> get props => [
        event,
      ];
  final T event;

  @override
  String toString() {
    return 'GettingPatientsDataState<$event>';
  }
}

class GotAllPatientsPaginatedAndOrderedState extends PatientsStates {
  GotAllPatientsPaginatedAndOrderedState(
      this.patients, this.endOfList, this.page)
      : super();

  final List<Patient> patients;
  final bool endOfList;
  final int page;

  @override
  List<Object?> get props => [patients, endOfList, page];

  @override
  String toString() {
    return 'GotAllPatientsPaginatedAndOrderedState';
  }
}

class PatientsEmptyState extends PatientsStates {
  PatientsEmptyState() : super();

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return 'PatientsEmptyState';
  }
}

class SearchPatientsResultsState extends PatientsStates {
  SearchPatientsResultsState(this.result) : super();

  final SearchResult result;

  @override
  List<Object?> get props => [result];

  @override
  String toString() {
    return 'SearchPatientsResultsState';
  }
}

class PatientErrorState extends PatientsStates {
  PatientErrorState(this.e) : super();

  final dynamic e;

  @override
  List<Object?> get props => [e];

  @override
  String toString() {
    return 'PatientErrorState';
  }
}

class GotPatientErrorState extends PatientsStates {
  GotPatientErrorState(this.e) : super();

  final dynamic e;

  @override
  List<Object?> get props => [e];

  @override
  String toString() {
    return 'GotPatientErrorState';
  }
}
