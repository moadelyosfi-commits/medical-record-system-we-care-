import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wecare_models/src/core/localized_text.dart';
import 'package:wecare_models/src/entities/enums.dart';

@immutable
final class EncounterFinding extends Equatable {
  const EncounterFinding({required this.label, required this.value});
  final LocalizedText label;
  final String value;

  @override
  List<Object?> get props => [label, value];

  @override
  String toString() => 'EncounterFinding()';
}

@immutable
final class EncounterRecord extends Equatable {
  EncounterRecord({
    required this.id,
    required this.type,
    required this.occurredAt,
    required this.facilityName,
    this.clinicianName,
    required this.chiefComplaint,
    this.findings = const [],
    this.workingDiagnosis,
    this.patientSummary,
    this.provenance = ProvenanceStatus.patientReported,
    required this.createdAt,
    required this.updatedAt,
  }) : assert(occurredAt.isUtc),
       assert(createdAt.isUtc),
       assert(updatedAt.isUtc);

  final String id;
  final EncounterType type;
  final DateTime occurredAt;
  final LocalizedText facilityName;
  final LocalizedText? clinicianName;
  final LocalizedText chiefComplaint;
  final List<EncounterFinding> findings;
  final LocalizedText? workingDiagnosis;
  final LocalizedText? patientSummary;
  final ProvenanceStatus provenance;
  final DateTime createdAt;
  final DateTime updatedAt;

  EncounterRecord copyWith({
    EncounterType? type,
    DateTime? occurredAt,
    LocalizedText? facilityName,
    LocalizedText? clinicianName,
    LocalizedText? chiefComplaint,
    List<EncounterFinding>? findings,
    LocalizedText? workingDiagnosis,
    LocalizedText? patientSummary,
    ProvenanceStatus? provenance,
    DateTime? updatedAt,
  }) => EncounterRecord(
    id: id,
    type: type ?? this.type,
    occurredAt: occurredAt ?? this.occurredAt,
    facilityName: facilityName ?? this.facilityName,
    clinicianName: clinicianName ?? this.clinicianName,
    chiefComplaint: chiefComplaint ?? this.chiefComplaint,
    findings: findings ?? this.findings,
    workingDiagnosis: workingDiagnosis ?? this.workingDiagnosis,
    patientSummary: patientSummary ?? this.patientSummary,
    provenance: provenance ?? this.provenance,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  List<Object?> get props => [
    id,
    type,
    occurredAt,
    facilityName,
    clinicianName,
    chiefComplaint,
    findings,
    workingDiagnosis,
    patientSummary,
    provenance,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() => 'EncounterRecord()';
}
