import 'package:equatable/equatable.dart';
import 'package:mobile_challenge_2021/enums/query_fields.dart';
import 'package:mobile_challenge_2021/helpers/constants.dart';

abstract class PatientsEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class PatientsInitialStateEvent extends PatientsEvents {
  PatientsInitialStateEvent() : super();

  @override
  List<Object?> get props => [];
}

class GetAllPatientsPaginatedAndOrderedEvent extends PatientsEvents {
  GetAllPatientsPaginatedAndOrderedEvent({
    this.page = 1,
    this.pageSize = Constants.DEFAULT_PAGE_SIZE_MOBILE,
  });

  final int page;
  final int pageSize;

  @override
  List<Object?> get props => [page, pageSize];
}

class GetPatientEvent extends PatientsEvents {
  GetPatientEvent(this.patientUID);

  final int patientUID;

  @override
  List<Object?> get props => [patientUID];
}

// ignore: must_be_immutable
class SearchPatientsEvent extends PatientsEvents {
  SearchPatientsEvent(this.query,
      {this.page = 1, this.pageSize = Constants.DEFAULT_PAGE_SIZE_MOBILE});

  final Map<QueryFields, String> query;
  final int page;
  final int pageSize;

  @override
  List<Object?> get props => [query, page, pageSize];
}

class PatientsChangedEvent extends PatientsEvents {}
