import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wecare_models/src/core/localized_text.dart';
import 'package:wecare_models/src/entities/enums.dart';

@immutable
final class InvestigationStatusChange extends Equatable {
  InvestigationStatusChange({required this.status, required this.changedAt})
    : assert(changedAt.isUtc);

  final InvestigationStatus status;
  final DateTime changedAt;

  @override
  List<Object?> get props => [status, changedAt];

  @override
  String toString() => 'InvestigationStatusChange()';
}

@immutable
final class LabResultValue extends Equatable {
  const LabResultValue({
    required this.name,
    required this.value,
    this.unit,
    this.referenceRange,
    this.flag = LabFlag.unknown,
  });

  final LocalizedText name;
  final String value;
  final String? unit;
  final String? referenceRange;
  final LabFlag flag;

  @override
  List<Object?> get props => [name, value, unit, referenceRange, flag];

  @override
  String toString() => 'LabResultValue()';
}

@immutable
final class InvestigationRecord extends Equatable {
  InvestigationRecord({
    required this.id,
    this.encounterId,
    required this.testName,
    required this.patientFriendlyReason,
    required this.status,
    this.statusHistory = const [],
    this.results = const [],
    this.resultNote,
    this.provenance = ProvenanceStatus.patientReported,
    required this.createdAt,
    required this.updatedAt,
  }) : assert(createdAt.isUtc),
       assert(updatedAt.isUtc);

  final String id;
  final String? encounterId;
  final LocalizedText testName;
  final LocalizedText patientFriendlyReason;
  final InvestigationStatus status;
  final List<InvestigationStatusChange> statusHistory;
  final List<LabResultValue> results;
  final LocalizedText? resultNote;
  final ProvenanceStatus provenance;
  final DateTime createdAt;
  final DateTime updatedAt;

  InvestigationRecord copyWith({
    String? encounterId,
    LocalizedText? testName,
    LocalizedText? patientFriendlyReason,
    InvestigationStatus? status,
    List<InvestigationStatusChange>? statusHistory,
    List<LabResultValue>? results,
    LocalizedText? resultNote,
    ProvenanceStatus? provenance,
    DateTime? updatedAt,
  }) => InvestigationRecord(
    id: id,
    encounterId: encounterId ?? this.encounterId,
    testName: testName ?? this.testName,
    patientFriendlyReason: patientFriendlyReason ?? this.patientFriendlyReason,
    status: status ?? this.status,
    statusHistory: statusHistory ?? this.statusHistory,
    results: results ?? this.results,
    resultNote: resultNote ?? this.resultNote,
    provenance: provenance ?? this.provenance,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  List<Object?> get props => [
    id,
    encounterId,
    testName,
    patientFriendlyReason,
    status,
    statusHistory,
    results,
    resultNote,
    provenance,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() => 'InvestigationRecord()';
}
