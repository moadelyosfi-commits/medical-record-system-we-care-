import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wecare_models/src/core/localized_text.dart';
import 'package:wecare_models/src/entities/enums.dart';

@immutable
final class AttachmentMeta extends Equatable {
  AttachmentMeta({
    required this.id,
    required this.kind,
    required this.displayName,
    required this.mockAssetKey,
    this.mimeType = 'image/png',
    this.linkedEntityType = LinkedEntityType.none,
    this.linkedEntityId,
    this.provenance = ProvenanceStatus.patientReported,
    required this.capturedAt,
    required this.createdAt,
  }) : assert(capturedAt.isUtc),
       assert(createdAt.isUtc);

  final String id;
  final AttachmentKind kind;
  final LocalizedText displayName;
  final String mockAssetKey;
  final String mimeType;
  final LinkedEntityType linkedEntityType;
  final String? linkedEntityId;
  final ProvenanceStatus provenance;
  final DateTime capturedAt;
  final DateTime createdAt;

  AttachmentMeta copyWith({
    AttachmentKind? kind,
    LocalizedText? displayName,
    String? mockAssetKey,
    String? mimeType,
    LinkedEntityType? linkedEntityType,
    String? linkedEntityId,
    ProvenanceStatus? provenance,
    DateTime? capturedAt,
  }) => AttachmentMeta(
    id: id,
    kind: kind ?? this.kind,
    displayName: displayName ?? this.displayName,
    mockAssetKey: mockAssetKey ?? this.mockAssetKey,
    mimeType: mimeType ?? this.mimeType,
    linkedEntityType: linkedEntityType ?? this.linkedEntityType,
    linkedEntityId: linkedEntityId ?? this.linkedEntityId,
    provenance: provenance ?? this.provenance,
    capturedAt: capturedAt ?? this.capturedAt,
    createdAt: createdAt,
  );

  @override
  List<Object?> get props => [
    id,
    kind,
    displayName,
    mockAssetKey,
    mimeType,
    linkedEntityType,
    linkedEntityId,
    provenance,
    capturedAt,
    createdAt,
  ];

  @override
  String toString() => 'AttachmentMeta()';
}
