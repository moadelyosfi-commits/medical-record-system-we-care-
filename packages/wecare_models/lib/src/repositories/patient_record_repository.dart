import 'package:wecare_models/src/entities/app_settings.dart';
import 'package:wecare_models/src/entities/attachment_meta.dart';
import 'package:wecare_models/src/entities/clinical_entry.dart';
import 'package:wecare_models/src/entities/encounter_record.dart';
import 'package:wecare_models/src/entities/enums.dart';
import 'package:wecare_models/src/entities/investigation_record.dart';
import 'package:wecare_models/src/entities/patient_profile.dart';
import 'package:wecare_models/src/entities/patient_task.dart';
import 'package:wecare_models/src/entities/prescription_record.dart';

abstract interface class PatientRecordRepository {
  Stream<PatientProfile> watchProfile();
  Future<void> updateProfile(PatientProfile updated);

  Stream<List<ClinicalEntry>> watchClinicalEntries({
    ClinicalCategory? category,
  });
  Stream<List<ClinicalEntry>> watchClinicalEntryHistory(String entryId);
  Future<void> addOrAmendClinicalEntry(
    ClinicalEntry entry, {
    String? amendmentReason,
  });

  Stream<List<EncounterRecord>> watchEncounters();
  Future<void> saveEncounter(EncounterRecord encounter);

  Stream<List<PrescriptionRecord>> watchPrescriptions({
    bool activeOnly = false,
  });
  Future<void> savePrescription(PrescriptionRecord prescription);

  Stream<List<InvestigationRecord>> watchInvestigations();
  Future<void> saveInvestigation(InvestigationRecord investigation);

  Stream<List<PatientTask>> watchTasks({DateTime? forDate});
  Future<void> saveTask(PatientTask task);
  Future<void> saveTasks(List<PatientTask> tasks);
  Future<void> toggleTaskCompletion(String taskId, {required bool isCompleted});

  Stream<List<AttachmentMeta>> watchAttachments({String? linkedEntityId});
  Future<void> addMockAttachment(AttachmentMeta attachment);
}

abstract interface class AppSettingsRepository {
  Stream<AppSettings> watchSettings();
  Future<void> setLocale(String languageCode);
  Future<void> updateSettings(AppSettings settings);
}

abstract interface class VaultSecurityBoundary {
  bool get isMockUnencryptedMode;
}
