import 'package:equatable/equatable.dart';
import 'package:wecare_models/src/core/clock_and_ids.dart';
import 'package:wecare_models/src/core/localized_text.dart';
import 'package:wecare_models/src/entities/enums.dart';
import 'package:wecare_models/src/entities/patient_task.dart';
import 'package:wecare_models/src/entities/prescription_record.dart';
import 'package:wecare_models/src/repositories/patient_record_repository.dart';

final class SavePrescriptionResult extends Equatable {
  const SavePrescriptionResult({
    required this.prescription,
    required this.createdTasks,
    this.requiresReminderConfiguration = false,
  });

  final PrescriptionRecord prescription;
  final List<PatientTask> createdTasks;
  final bool requiresReminderConfiguration;
  bool get hasIncompleteWarning => prescription.isIncompleteWarning;

  @override
  List<Object?> get props => [
    prescription,
    createdTasks,
    requiresReminderConfiguration,
  ];
}

final class SavePrescriptionUseCase {
  const SavePrescriptionUseCase({
    required PatientRecordRepository repository,
    required AppClock clock,
    required IdGenerator ids,
  }) : _repository = repository,
       _clock = clock,
       _ids = ids;

  final PatientRecordRepository _repository;
  final AppClock _clock;
  final IdGenerator _ids;

  static const int horizonDays = 7;

  Future<SavePrescriptionResult> call(PrescriptionRecord draft) async {
    final prescription = draft.copyWith(
      isIncompleteWarning: isPrescriptionIncomplete(draft),
    );

    final isEligible =
        (prescription.orderType == PrescriptionOrderType.regularCourse ||
            prescription.orderType ==
                PrescriptionOrderType.longTermMaintenance) &&
        !prescription.isIncompleteWarning;

    final hasExplicitTimes = prescription.doseTimesMinutes.isNotEmpty;
    final requiresConfig = isEligible && !hasExplicitTimes;

    final tasks = isEligible && hasExplicitTimes
        ? _buildTasks(prescription)
        : <PatientTask>[];

    await _repository.savePrescription(prescription);
    if (tasks.isNotEmpty) {
      await _repository.saveTasks(tasks);
    }

    return SavePrescriptionResult(
      prescription: prescription,
      createdTasks: tasks,
      requiresReminderConfiguration: requiresConfig,
    );
  }

  List<PatientTask> _buildTasks(PrescriptionRecord p) {
    final times = [...p.doseTimesMinutes]..sort();
    final days = p.orderType == PrescriptionOrderType.regularCourse
        ? (p.durationDays != null
              ? (p.durationDays! < horizonDays ? p.durationDays! : horizonDays)
              : horizonDays)
        : horizonDays;

    final now = _clock.nowUtc();
    final offset = _clock.utcOffset;
    final nowLocal = now.add(offset);
    final localMidnight = DateTime.utc(
      nowLocal.year,
      nowLocal.month,
      nowLocal.day,
    );

    final tasks = <PatientTask>[];
    for (var d = 0; d < days; d++) {
      for (final minutes in times) {
        final due = localMidnight
            .add(Duration(days: d, minutes: minutes))
            .subtract(offset);
        tasks.add(
          PatientTask(
            id: _ids.newId(),
            category: TaskCategory.medication,
            title: _title(p),
            dueAt: due,
            linkedEntityType: LinkedEntityType.prescription,
            linkedEntityId: p.id,
            source: TaskSource.system,
            createdAt: now,
          ),
        );
      }
    }
    return tasks;
  }

  LocalizedText _title(PrescriptionRecord p) {
    final dose = (p.doseAmount != null && p.doseUnit != null)
        ? ' ${_formatDose(p.doseAmount!)} ${p.doseUnit}'
        : '';
    return LocalizedText(
      ar: 'تناول ${p.medicationName.ar}$dose',
      en: 'Take ${p.medicationName.en}$dose',
    );
  }

  String _formatDose(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}
