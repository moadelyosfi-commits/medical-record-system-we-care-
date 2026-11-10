import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wecare_models/src/core/localized_text.dart';
import 'package:wecare_models/src/entities/enums.dart';

@immutable
final class PatientTask extends Equatable {
  PatientTask({
    required this.id,
    required this.category,
    required this.title,
    this.description,
    required this.dueAt,
    this.isCompleted = false,
    this.completedAt,
    this.linkedEntityType = LinkedEntityType.none,
    this.linkedEntityId,
    this.source = TaskSource.patient,
    required this.createdAt,
  }) : assert(dueAt.isUtc),
       assert(completedAt == null || completedAt.isUtc),
       assert(createdAt.isUtc);

  final String id;
  final TaskCategory category;
  final LocalizedText title;
  final LocalizedText? description;
  final DateTime dueAt;
  final bool isCompleted;
  final DateTime? completedAt;
  final LinkedEntityType linkedEntityType;
  final String? linkedEntityId;
  final TaskSource source;
  final DateTime createdAt;

  PatientTask copyWith({
    TaskCategory? category,
    LocalizedText? title,
    LocalizedText? description,
    DateTime? dueAt,
    bool? isCompleted,
    DateTime? completedAt,
    LinkedEntityType? linkedEntityType,
    String? linkedEntityId,
    TaskSource? source,
  }) => PatientTask(
    id: id,
    category: category ?? this.category,
    title: title ?? this.title,
    description: description ?? this.description,
    dueAt: dueAt ?? this.dueAt,
    isCompleted: isCompleted ?? this.isCompleted,
    completedAt: completedAt ?? this.completedAt,
    linkedEntityType: linkedEntityType ?? this.linkedEntityType,
    linkedEntityId: linkedEntityId ?? this.linkedEntityId,
    source: source ?? this.source,
    createdAt: createdAt,
  );

  @override
  List<Object?> get props => [
    id,
    category,
    title,
    description,
    dueAt,
    isCompleted,
    completedAt,
    linkedEntityType,
    linkedEntityId,
    source,
    createdAt,
  ];

  @override
  String toString() => 'PatientTask()';
}
