import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wecare_models/src/core/localized_text.dart';
import 'package:wecare_models/src/entities/enums.dart';

@immutable
final class EmergencyContact extends Equatable {
  const EmergencyContact({
    required this.name,
    required this.relationship,
    required this.phone,
  });

  final LocalizedText name;
  final LocalizedText relationship;
  final String phone;

  EmergencyContact copyWith({
    LocalizedText? name,
    LocalizedText? relationship,
    String? phone,
  }) => EmergencyContact(
    name: name ?? this.name,
    relationship: relationship ?? this.relationship,
    phone: phone ?? this.phone,
  );

  @override
  List<Object?> get props => [name, relationship, phone];

  @override
  String toString() => 'EmergencyContact()';
}

@immutable
final class PatientProfile extends Equatable {
  PatientProfile({
    required this.id,
    required this.fullName,
    this.dateOfBirth,
    this.sex = Sex.unspecified,
    this.bloodGroup = BloodGroup.unknown,
    required this.city,
    required this.baladiya,
    this.emergencyContact,
    required this.updatedAt,
  }) : assert(dateOfBirth == null || dateOfBirth.isUtc),
       assert(updatedAt.isUtc);

  final String id;
  final LocalizedText fullName;
  final DateTime? dateOfBirth;
  final Sex sex;
  final BloodGroup bloodGroup;
  final LocalizedText city;
  final LocalizedText baladiya;
  final EmergencyContact? emergencyContact;
  final DateTime updatedAt;

  PatientProfile copyWith({
    LocalizedText? fullName,
    DateTime? dateOfBirth,
    Sex? sex,
    BloodGroup? bloodGroup,
    LocalizedText? city,
    LocalizedText? baladiya,
    EmergencyContact? emergencyContact,
    DateTime? updatedAt,
  }) => PatientProfile(
    id: id,
    fullName: fullName ?? this.fullName,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    sex: sex ?? this.sex,
    bloodGroup: bloodGroup ?? this.bloodGroup,
    city: city ?? this.city,
    baladiya: baladiya ?? this.baladiya,
    emergencyContact: emergencyContact ?? this.emergencyContact,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  List<Object?> get props => [
    id,
    fullName,
    dateOfBirth,
    sex,
    bloodGroup,
    city,
    baladiya,
    emergencyContact,
    updatedAt,
  ];

  @override
  String toString() => 'PatientProfile()';
}
