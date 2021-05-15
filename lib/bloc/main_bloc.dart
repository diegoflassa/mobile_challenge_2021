import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_challenge_2021/bloc/patients_bloc.dart';

class MainBloc {
  static List<BlocProvider> allBlocs() {
    return [
      BlocProvider<PatientsBloc>(
        lazy: true,
        create: (context) => PatientsBloc(),
      ),
    ];
  }
}
