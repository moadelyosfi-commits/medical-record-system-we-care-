import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wecare_models/src/core/localized_text.dart';
import 'package:wecare_models/src/entities/enums.dart';

@immutable
final class ClinicalEntry extends Equatable {
  ClinicalEntry({
    required this.entryId,
    this.versionNumber = 1,
    required this.category,
    required this.title,
    this.details,
    this.numericValue,
    this.unit,
    this.provenance = ProvenanceStatus.patientReported,
    this.amendmentReason,
    required this.recordedAt,
    required this.versionCreatedAt,
  }) : assert(versionNumber >= 1),
       assert(recordedAt.isUtc),
       assert(versionCreatedAt.isUtc);

  final String entryId;
  final int versionNumber;
  final ClinicalCategory category;
  final LocalizedText title;
  final LocalizedText? details;
  final double? numericValue;
  final String? unit;
  final ProvenanceStatus provenance;
  final String? amendmentReason;
  final DateTime recordedAt;
  final DateTime versionCreatedAt;

  ClinicalEntry copyWith({
    int? versionNumber,
    ClinicalCategory? category,
    LocalizedText? title,
    LocalizedText? details,
    double? numericValue,
    String? unit,
    ProvenanceStatus? provenance,
    String? amendmentReason,
    DateTime? recordedAt,
    DateTime? versionCreatedAt,
  }) => ClinicalEntry(
    entryId: entryId,
    versionNumber: versionNumber ?? this.versionNumber,
    category: category ?? this.category,
    title: title ?? this.title,
    details: details ?? this.details,
    numericValue: numericValue ?? this.numericValue,
    unit: unit ?? this.unit,
    provenance: provenance ?? this.provenance,
    amendmentReason: amendmentReason ?? this.amendmentReason,
    recordedAt: recordedAt ?? this.recordedAt,
    versionCreatedAt: versionCreatedAt ?? this.versionCreatedAt,
  );

  @override
  List<Object?> get props => [
    entryId,
    versionNumber,
    category,
    title,
    details,
    numericValue,
    unit,
    provenance,
    amendmentReason,
    recordedAt,
    versionCreatedAt,
  ];

  @override
  String toString() => 'ClinicalEntry()';
}
