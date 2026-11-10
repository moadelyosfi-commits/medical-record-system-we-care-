import 'dart:async';
import 'package:wecare_models/wecare_models.dart';

// TODO(S1-02): This is a temporary minimal in-memory development mock for S1-01.
// AI 3 will replace this in S1-02 with the mock storage library once S1-02 merges.

final class DevMockVaultSecurityBoundary implements VaultSecurityBoundary {
  const DevMockVaultSecurityBoundary();
  @override
  bool get isMockUnencryptedMode => true;
}

final class DevMockSettingsRepository implements AppSettingsRepository {
  DevMockSettingsRepository() {
    _controller.add(_settings);
  }

  var _settings = const AppSettings();
  final _controller = StreamController<AppSettings>.broadcast();

  @override
  Stream<AppSettings> watchSettings() => _controller.stream;

  @override
  Future<void> setLocale(String languageCode) async {
    _settings = _settings.copyWith(languageCode: languageCode);
    _controller.add(_settings);
  }

  @override
  Future<void> updateSettings(AppSettings settings) async {
    _settings = settings;
    _controller.add(_settings);
  }
}

final class DevMockPatientRecordRepository
    implements PatientRecordRepository, MockDataControl {
  DevMockPatientRecordRepository({required this.clock, required this.ids}) {
    _profileController.add(_profile);
    _entriesController.add(_entries);
    _encountersController.add(_encounters);
    _prescriptionsController.add(_prescriptions);
    _investigationsController.add(_investigations);
    _tasksController.add(_tasks);
    _attachmentsController.add(_attachments);
  }

  final AppClock clock;
  final IdGenerator ids;

  DemoPatientId _activeDemo = DemoPatientId.chronicHypertensionDiabetes;

  @override
  DemoPatientId get activeDemoPatient => _activeDemo;

  var _profile = PatientProfile(
    id: 'demo-patient-1',
    fullName: const LocalizedText(ar: 'مريض تجريبي', en: 'Demo Patient'),
    city: const LocalizedText(ar: 'طرابلس', en: 'Tripoli'),
    baladiya: const LocalizedText(ar: 'حي الأندلس', en: 'Hai Al-Andalus'),
    updatedAt: DateTime.utc(2026, 1, 1),
  );
  final _profileController = StreamController<PatientProfile>.broadcast();

  final List<ClinicalEntry> _entries = [];
  final _entriesController = StreamController<List<ClinicalEntry>>.broadcast();

  final List<EncounterRecord> _encounters = [];
  final _encountersController =
      StreamController<List<EncounterRecord>>.broadcast();

  final List<PrescriptionRecord> _prescriptions = [];
  final _prescriptionsController =
      StreamController<List<PrescriptionRecord>>.broadcast();

  final List<InvestigationRecord> _investigations = [];
  final _investigationsController =
      StreamController<List<InvestigationRecord>>.broadcast();

  final List<PatientTask> _tasks = [];
  final _tasksController = StreamController<List<PatientTask>>.broadcast();

  final List<AttachmentMeta> _attachments = [];
  final _attachmentsController =
      StreamController<List<AttachmentMeta>>.broadcast();

  @override
  Future<void> loadDemoPatient(DemoPatientId id) async {
    _activeDemo = id;
  }

  @override
  Future<void> resetToSeedData() async {}

  @override
  Stream<PatientProfile> watchProfile() => _profileController.stream;

  @override
  Future<void> updateProfile(PatientProfile updated) async {
    _profile = updated;
    _profileController.add(_profile);
  }

  @override
  Stream<List<ClinicalEntry>> watchClinicalEntries({
    ClinicalCategory? category,
  }) {
    return _entriesController.stream.map((list) {
      if (category == null) return list;
      return list.where((e) => e.category == category).toList();
    });
  }

  @override
  Stream<List<ClinicalEntry>> watchClinicalEntryHistory(String entryId) {
    return _entriesController.stream.map((list) {
      return list.where((e) => e.entryId == entryId).toList()
        ..sort((a, b) => b.versionNumber.compareTo(a.versionNumber));
    });
  }

  @override
  Future<void> addOrAmendClinicalEntry(
    ClinicalEntry entry, {
    String? amendmentReason,
  }) async {
    _entries.add(entry);
    _entriesController.add(List.unmodifiable(_entries));
  }

  @override
  Stream<List<EncounterRecord>> watchEncounters() =>
      _encountersController.stream;

  @override
  Future<void> saveEncounter(EncounterRecord encounter) async {
    _encounters.add(encounter);
    _encountersController.add(List.unmodifiable(_encounters));
  }

  @override
  Stream<List<PrescriptionRecord>> watchPrescriptions({
    bool activeOnly = false,
  }) {
    return _prescriptionsController.stream.map((list) {
      if (!activeOnly) return list;
      final now = clock.nowUtc();
      return list.where((p) => p.isActiveAt(now)).toList();
    });
  }

  @override
  Future<void> savePrescription(PrescriptionRecord prescription) async {
    final checked = prescription.copyWith(
      isIncompleteWarning: isPrescriptionIncomplete(prescription),
    );
    _prescriptions.add(checked);
    _prescriptionsController.add(List.unmodifiable(_prescriptions));
  }

  @override
  Stream<List<InvestigationRecord>> watchInvestigations() =>
      _investigationsController.stream;

  @override
  Future<void> saveInvestigation(InvestigationRecord investigation) async {
    _investigations.add(investigation);
    _investigationsController.add(List.unmodifiable(_investigations));
  }

  @override
  Stream<List<PatientTask>> watchTasks({DateTime? forDate}) =>
      _tasksController.stream;

  @override
  Future<void> saveTask(PatientTask task) async {
    _tasks.add(task);
    _tasksController.add(List.unmodifiable(_tasks));
  }

  @override
  Future<void> saveTasks(List<PatientTask> tasks) async {
    _tasks.addAll(tasks);
    _tasksController.add(List.unmodifiable(_tasks));
  }

  @override
  Future<void> toggleTaskCompletion(
    String taskId, {
    required bool isCompleted,
  }) async {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx != -1) {
      _tasks[idx] = _tasks[idx].copyWith(
        isCompleted: isCompleted,
        completedAt: isCompleted ? clock.nowUtc() : null,
      );
      _tasksController.add(List.unmodifiable(_tasks));
    }
  }

  @override
  Stream<List<AttachmentMeta>> watchAttachments({String? linkedEntityId}) {
    return _attachmentsController.stream.map((list) {
      if (linkedEntityId == null) return list;
      return list.where((a) => a.linkedEntityId == linkedEntityId).toList();
    });
  }

  @override
  Future<void> addMockAttachment(AttachmentMeta attachment) async {
    _attachments.add(attachment);
    _attachmentsController.add(List.unmodifiable(_attachments));
  }
}
