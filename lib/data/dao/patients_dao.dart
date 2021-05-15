import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_challenge_2021/data/entities/patient.dart';
import 'package:mobile_challenge_2021/enums/query_fields.dart';
import 'package:mobile_challenge_2021/helpers/constants.dart';
import 'package:mobile_challenge_2021/helpers/helper.dart';
import 'package:mobile_challenge_2021/helpers/my_logger.dart';

class PatientsDao {
  factory PatientsDao() {
    return _instance;
  }

  PatientsDao._internal();

  final String apiUrlAuthority = 'https://randomuser.me';
  final String apiUrlPath = '/api/';

  static final PatientsDao _instance = PatientsDao._internal();

  Future<List<Patient>> getAllPaginated(
    int page,
    int pageSize,
  ) async {
    var ret = <Patient>[];
    final apiPath =
        '$apiUrlPath?page=$page&results=$pageSize&${_getUnusedField()}${_getSeed()}';
    final uri = Uri.parse('$apiUrlAuthority$apiPath');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final dynamic decodedJson = jsonDecode(response.body);
      ret = Helper.patientsJsonToPatientsList(decodedJson);
    } else {
      throw Exception('Failed to load Patients');
    }
    return ret;
  }

  Future<SearchResult> findAllPaginated(Map<QueryFields, String> query,
      {int page = 1,
      int pageSize = Constants.DEFAULT_PAGE_SIZE_MOBILE,
      int? startPage,
      int? maxPageToSearch,
      SearchResult? previousResults}) async {
    MyLogger().logger.i(
        '[PatientDAO.findAllPaginated]page:$page,pageSize$pageSize,startPage$startPage,maxPageToSearch:$maxPageToSearch,previousResults:$previousResults');
    var ret = SearchResult();
    final containsGender = query.containsKey(QueryFields.GENDER);
    final queryString = _getQueryString(query);
    final apiPath =
        '$apiUrlPath?page=$page&results=$pageSize&${_getUnusedField()}${containsGender ? '' : _getSeed()}$queryString';
    final response = await http.get(Uri.parse('$apiUrlAuthority$apiPath'));

    if (response.statusCode == 200) {
      final dynamic decodedJson = jsonDecode(response.body);
      ret.patients = Helper.patientsJsonToPatientsList(decodedJson);
      if (query.keys.contains(QueryFields.FULL_NAME)) {
        final queryName = query[QueryFields.FULL_NAME]!;
        ret.patients = ret.patients
            .where((element) => element.fullName
                .getFullName()
                .toLowerCase()
                .contains(queryName.toLowerCase()))
            .toList();
      }
      maxPageToSearch ??= page + Constants.DEFAULT_MAX_PAGE_TO_SEARCH;
      if (previousResults != null) {
        ret.patients.addAll(previousResults.patients);
        ret.lastSearchedPage = previousResults.lastSearchedPage;
      }
      if (ret.patients.length < Constants.DEFAULT_PAGE_SIZE_MOBILE &&
          page < maxPageToSearch) {
        ret = await findAllPaginated(query,
            page: page + 1,
            maxPageToSearch: maxPageToSearch,
            pageSize: pageSize,
            previousResults: ret);
      } else {
        ret.lastSearchedPage = page;
      }
    } else {
      throw Exception('Failed to load Patients');
    }
    return ret;
  }

  String _getQueryString(Map<QueryFields, String>? query) {
    var ret = '';
    if (query != null && query.isNotEmpty) {
      for (final field in query.keys) {
        switch (field) {
          case QueryFields.FULL_NAME:
            // Do nothing
            break;
          case QueryFields.GENDER:
            ret += '&gender=${query[field]!.toLowerCase()}';
            break;
          case QueryFields.NATIONALITY:
            ret += '&nat=${query[field]}';
            break;
          case QueryFields.UNKNOWN:
            break;
        }
      }
    }
    return ret;
  }

  Future<Patient?> getByUid(int uid) async {
    final ret = Patient();
    return ret;
  }

  String _getUnusedField() {
    return 'exc=login, registered';
  }

  String _getSeed() {
    return '&seed=42';
  }
}

class SearchResult {
  List<Patient> patients = <Patient>[];
  int lastSearchedPage = 0;
}
