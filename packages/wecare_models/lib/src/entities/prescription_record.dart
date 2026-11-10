import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wecare_models/src/core/localized_text.dart';
import 'package:wecare_models/src/entities/enums.dart';

@immutable
final class PrescriptionRecord extends Equatable {
  PrescriptionRecord({
    required this.id,
    this.encounterId,
    required this.medicationName,
    required this.orderType,
    this.strength,
    this.doseAmount,
    this.doseUnit,
    this.frequencyPerDay,
    this.doseTimesMinutes = const [],
    this.durationDays,
    this.prnIndication,
    this.prnMaxPerDay,
    this.instructions,
    this.provenance = ProvenanceStatus.patientReported,
    this.isIncompleteWarning = false,
    required this.startedAt,
    this.endedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : assert(startedAt.isUtc),
       assert(endedAt == null || endedAt.isUtc),
       assert(createdAt.isUtc),
       assert(updatedAt.isUtc);

  final String id;
  final String? encounterId;
  final LocalizedText medicationName;
  final PrescriptionOrderType orderType;
  final String? strength;
  final double? doseAmount;
  final String? doseUnit;
  final int? frequencyPerDay;
  final List<int> doseTimesMinutes;
  final int? durationDays;
  final LocalizedText? prnIndication;
  final int? prnMaxPerDay;
  final LocalizedText? instructions;
  final ProvenanceStatus provenance;
  final bool isIncompleteWarning;
  final DateTime startedAt;
  final DateTime? endedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool isActiveAt(DateTime nowUtc) {
    if (provenance == ProvenanceStatus.enteredInError) return false;
    if (endedAt != null && !endedAt!.isAfter(nowUtc)) return false;
    if (orderType == PrescriptionOrderType.regularCourse &&
        durationDays != null) {
      return startedAt.add(Duration(days: durationDays!)).isAfter(nowUtc);
    }
    return true;
  }

  PrescriptionRecord copyWith({
    String? encounterId,
    LocalizedText? medicationName,
    PrescriptionOrderType? orderType,
    String? strength,
    double? doseAmount,
    String? doseUnit,
    int? frequencyPerDay,
    List<int>? doseTimesMinutes,
    int? durationDays,
    LocalizedText? prnIndication,
    int? prnMaxPerDay,
    LocalizedText? instructions,
    ProvenanceStatus? provenance,
    bool? isIncompleteWarning,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? updatedAt,
  }) => PrescriptionRecord(
    id: id,
    encounterId: encounterId ?? this.encounterId,
    medicationName: medicationName ?? this.medicationName,
    orderType: orderType ?? this.orderType,
    strength: strength ?? this.strength,
    doseAmount: doseAmount ?? this.doseAmount,
    doseUnit: doseUnit ?? this.doseUnit,
    frequencyPerDay: frequencyPerDay ?? this.frequencyPerDay,
    doseTimesMinutes: doseTimesMinutes ?? this.doseTimesMinutes,
    durationDays: durationDays ?? this.durationDays,
    prnIndication: prnIndication ?? this.prnIndication,
    prnMaxPerDay: prnMaxPerDay ?? this.prnMaxPerDay,
    instructions: instructions ?? this.instructions,
    provenance: provenance ?? this.provenance,
    isIncompleteWarning: isIncompleteWarning ?? this.isIncompleteWarning,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  List<Object?> get props => [
    id,
    encounterId,
    medicationName,
    orderType,
    strength,
    doseAmount,
    doseUnit,
    frequencyPerDay,
    doseTimesMinutes,
    durationDays,
    prnIndication,
    prnMaxPerDay,
    instructions,
    provenance,
    isIncompleteWarning,
    startedAt,
    endedAt,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() => 'PrescriptionRecord()';
}

bool isPrescriptionIncomplete(PrescriptionRecord p) {
  final hasDose =
      (p.doseAmount ?? 0) > 0 && (p.doseUnit?.trim().isNotEmpty ?? false);
  final hasFrequency = (p.frequencyPerDay ?? 0) > 0;
  return switch (p.orderType) {
    PrescriptionOrderType.regularCourse =>
      !(hasDose && hasFrequency && (p.durationDays ?? 0) > 0),
    PrescriptionOrderType.longTermMaintenance => !(hasDose && hasFrequency),
    PrescriptionOrderType.prnAsNeeded =>
      !(hasDose && p.prnIndication != null && (p.prnMaxPerDay ?? 0) > 0),
    PrescriptionOrderType.singleStatDose => !hasDose,
    PrescriptionOrderType.topicalOrTitrated =>
      p.instructions == null ||
          (p.instructions!.ar.trim().isEmpty &&
              p.instructions!.en.trim().isEmpty),
  };
}
