import 'package:equatable/equatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_challenge_2021/data/entities/address.dart';
import 'package:mobile_challenge_2021/data/entities/dob.dart';
import 'package:mobile_challenge_2021/data/entities/full_name.dart';
import 'package:mobile_challenge_2021/data/entities/id.dart';
import 'package:mobile_challenge_2021/data/entities/picture.dart';
import 'package:mobile_challenge_2021/enums/gender.dart';
import 'package:mobile_challenge_2021/helpers/helper.dart';

part 'patient.g.dart';

@JsonSerializable(explicitToJson: true)
// ignore: must_be_immutable
class Patient extends Equatable {
  Patient();

  /// A necessary factory constructor for creating a new Patient instance
  /// from a map. Pass the map to the generated `_$PatientFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Patient.
  factory Patient.fromJson(Map<String, dynamic> json) =>
      Patient._fromJson(json);

  @override
  List<Object?> get props => [
        id,
        picture,
        fullName,
        email,
        gender,
        dateOfBirth,
        telephone,
        cellphone,
        nationality,
        address,
      ];

  static const String ID = 'id';
  static const String PICTURE = 'picture';
  static const String FULL_NAME = 'name';
  static const String EMAIL = 'email';
  static const String GENDER = 'gender';
  static const String DATE_OF_BIRTH = 'dob';
  static const String TELEPHONE = 'phone';
  static const String CELLPHONE = 'cell';
  static const String NATIONALITY = 'nat';
  static const String ADDRESS = 'location';

  @JsonKey(name: ID)
  Id id = Id();
  @JsonKey(name: PICTURE)
  Picture picture = Picture();
  @JsonKey(name: FULL_NAME)
  FullName fullName = FullName();
  @JsonKey(name: EMAIL)
  String email = '';
  @JsonKey(name: GENDER)
  String gender = '';
  @JsonKey(name: DATE_OF_BIRTH)
  Dob dateOfBirth = Dob();
  @JsonKey(name: TELEPHONE)
  String telephone = '';
  @JsonKey(name: CELLPHONE)
  String cellphone = '';
  @JsonKey(name: NATIONALITY)
  String nationality = '';
  @JsonKey(name: ADDRESS)
  Address address = Address();

  Patient copyWith(Patient patient) {
    final ret = Patient()
      ..id.name = patient.id.name
      ..id.value = patient.id.value
      ..picture.largeUrl = patient.picture.largeUrl
      ..picture.mediumUrl = patient.picture.mediumUrl
      ..picture.thumbnailUrl = patient.picture.thumbnailUrl
      ..fullName.title = patient.fullName.title
      ..fullName.first = patient.fullName.first
      ..fullName.last = patient.fullName.last
      ..email = patient.email
      ..gender = patient.gender
      ..dateOfBirth.date = patient.dateOfBirth.date
      ..dateOfBirth.age = patient.dateOfBirth.age
      ..telephone = patient.telephone
      ..nationality = patient.nationality
      ..address.street = patient.address.street
      ..address.city = patient.address.city
      ..address.state = patient.address.state
      ..address.postCode = patient.address.postCode;

    return ret;
  }

  Patient getCopy() {
    return copyWith(this);
  }

  /// A necessary factory constructor for creating a new Patient instance
  /// from a map. Pass the map to the generated `_$PatientFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Patient.
  static Patient _fromJson(Map<String, dynamic> json) {
    final patient = _$PatientFromJson(json);
    return patient;
  }

  ///`toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$PatientToJson`.
  Map<String, dynamic> toJson() => _$PatientToJson(this);

  Gender getGenderAsEnum() {
    return Helper.genderStringToEnum(gender);
  }
}
