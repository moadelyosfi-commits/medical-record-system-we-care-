import 'package:test/test.dart';
import 'package:wecare_models/wecare_models.dart';

class _FakePatientRecordRepository implements PatientRecordRepository {
  PrescriptionRecord? savedPrescription;
  List<PatientTask> savedTasks = [];

  @override
  Future<void> savePrescription(PrescriptionRecord prescription) async {
    savedPrescription = prescription;
  }

  @override
  Future<void> saveTasks(List<PatientTask> tasks) async {
    savedTasks.addAll(tasks);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('LocalizedText', () {
    test('resolve fallback in both directions', () {
      const arOnly = LocalizedText(ar: 'مرحبا', en: '');
      expect(arOnly.resolve('ar'), 'مرحبا');
      expect(arOnly.resolve('en'), 'مرحبا');

      const enOnly = LocalizedText(ar: '', en: 'Hello');
      expect(enOnly.resolve('ar'), 'Hello');
      expect(enOnly.resolve('en'), 'Hello');

      const both = LocalizedText(ar: 'مرحبا', en: 'Hello');
      expect(both.resolve('ar'), 'مرحبا');
      expect(both.resolve('en'), 'Hello');
    });

    test('equality and copy', () {
      const t1 = LocalizedText(ar: 'أ', en: 'A');
      const t2 = LocalizedText(ar: 'أ', en: 'A');
      const t3 = LocalizedText(ar: 'ب', en: 'B');
      expect(t1, equals(t2));
      expect(t1, isNot(equals(t3)));
    });
  });

  group('InvestigationStatus', () {
    test('canTransitionTo is forward-only across all 6 states', () {
      const statuses = InvestigationStatus.values;
      expect(statuses.length, 6);

      for (var i = 0; i < statuses.length; i++) {
        for (var j = 0; j < statuses.length; j++) {
          final canMove = statuses[i].canTransitionTo(statuses[j]);
          if (j > i) {
            expect(
              canMove,
              isTrue,
              reason: '${statuses[i]} should transition to ${statuses[j]}',
            );
          } else {
            expect(
              canMove,
              isFalse,
              reason:
                  '${statuses[i]} should NOT transition backwards or equal to ${statuses[j]}',
            );
          }
        }
      }
    });
  });

  group('UTC asserts on entities', () {
    final nonUtc = DateTime(2026, 1, 1, 10, 0); // local time
    final utc = DateTime.utc(2026, 1, 1, 10, 0);

    test('PatientProfile requires UTC timestamps', () {
      expect(
        () => PatientProfile(
          id: '1',
          fullName: const LocalizedText(ar: 'أحمد', en: 'Ahmed'),
          city: const LocalizedText(ar: 'طرابلس', en: 'Tripoli'),
          baladiya: const LocalizedText(ar: 'المركز', en: 'Center'),
          updatedAt: nonUtc,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => PatientProfile(
          id: '1',
          fullName: const LocalizedText(ar: 'أحمد', en: 'Ahmed'),
          dateOfBirth: nonUtc,
          city: const LocalizedText(ar: 'طرابلس', en: 'Tripoli'),
          baladiya: const LocalizedText(ar: 'المركز', en: 'Center'),
          updatedAt: utc,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('ClinicalEntry requires UTC timestamps', () {
      expect(
        () => ClinicalEntry(
          entryId: '1',
          category: ClinicalCategory.allergy,
          title: const LocalizedText(ar: 'بنسلين', en: 'Penicillin'),
          recordedAt: nonUtc,
          versionCreatedAt: utc,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => ClinicalEntry(
          entryId: '1',
          category: ClinicalCategory.allergy,
          title: const LocalizedText(ar: 'بنسلين', en: 'Penicillin'),
          recordedAt: utc,
          versionCreatedAt: nonUtc,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('EncounterRecord requires UTC timestamps', () {
      expect(
        () => EncounterRecord(
          id: '1',
          type: EncounterType.consultation,
          occurredAt: nonUtc,
          facilityName: const LocalizedText(ar: 'مستشفى', en: 'Hospital'),
          chiefComplaint: const LocalizedText(ar: 'صداع', en: 'Headache'),
          createdAt: utc,
          updatedAt: utc,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('PrescriptionRecord requires UTC timestamps', () {
      expect(
        () => PrescriptionRecord(
          id: '1',
          medicationName: const LocalizedText(ar: 'أسبرين', en: 'Aspirin'),
          orderType: PrescriptionOrderType.regularCourse,
          startedAt: nonUtc,
          createdAt: utc,
          updatedAt: utc,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('InvestigationRecord and status change requires UTC timestamps', () {
      expect(
        () => InvestigationRecord(
          id: '1',
          testName: const LocalizedText(ar: 'تحليل دم', en: 'Blood Test'),
          patientFriendlyReason: const LocalizedText(
            ar: 'فحص دوري',
            en: 'Routine check',
          ),
          status: InvestigationStatus.suggested,
          createdAt: nonUtc,
          updatedAt: utc,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => InvestigationStatusChange(
          status: InvestigationStatus.ordered,
          changedAt: nonUtc,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('PatientTask requires UTC timestamps', () {
      expect(
        () => PatientTask(
          id: '1',
          category: TaskCategory.medication,
          title: const LocalizedText(ar: 'دواء', en: 'Medication'),
          dueAt: nonUtc,
          createdAt: utc,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('AttachmentMeta requires UTC timestamps', () {
      expect(
        () => AttachmentMeta(
          id: '1',
          kind: AttachmentKind.prescriptionPhoto,
          displayName: const LocalizedText(ar: 'وصفة', en: 'Prescription'),
          mockAssetKey: 'assets/mock.png',
          capturedAt: nonUtc,
          createdAt: utc,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('isPrescriptionIncomplete Matrix Test', () {
    final now = DateTime.utc(2026, 1, 1);

    test('regularCourse completeness rules', () {
      final complete = PrescriptionRecord(
        id: '1',
        medicationName: const LocalizedText(ar: 'مضاد', en: 'Antibiotic'),
        orderType: PrescriptionOrderType.regularCourse,
        doseAmount: 500,
        doseUnit: 'mg',
        frequencyPerDay: 3,
        durationDays: 7,
        startedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(isPrescriptionIncomplete(complete), isFalse);

      final missingDose = complete.copyWith(doseAmount: 0);
      expect(isPrescriptionIncomplete(missingDose), isTrue);

      final missingUnit = complete.copyWith(doseUnit: ' ');
      expect(isPrescriptionIncomplete(missingUnit), isTrue);

      final missingFreq = complete.copyWith(frequencyPerDay: 0);
      expect(isPrescriptionIncomplete(missingFreq), isTrue);

      final missingDuration = complete.copyWith(durationDays: 0);
      expect(isPrescriptionIncomplete(missingDuration), isTrue);
    });

    test('longTermMaintenance completeness rules', () {
      final complete = PrescriptionRecord(
        id: '2',
        medicationName: const LocalizedText(ar: 'ضغط', en: 'BP Med'),
        orderType: PrescriptionOrderType.longTermMaintenance,
        doseAmount: 10,
        doseUnit: 'mg',
        frequencyPerDay: 1,
        startedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(isPrescriptionIncomplete(complete), isFalse);

      final missingDose = complete.copyWith(doseAmount: 0);
      expect(isPrescriptionIncomplete(missingDose), isTrue);

      final missingFreq = complete.copyWith(frequencyPerDay: 0);
      expect(isPrescriptionIncomplete(missingFreq), isTrue);
    });

    test('prnAsNeeded completeness rules', () {
      final complete = PrescriptionRecord(
        id: '3',
        medicationName: const LocalizedText(
          ar: 'باراسيتامول',
          en: 'Paracetamol',
        ),
        orderType: PrescriptionOrderType.prnAsNeeded,
        doseAmount: 500,
        doseUnit: 'mg',
        prnIndication: const LocalizedText(ar: 'للألم', en: 'For pain'),
        prnMaxPerDay: 4,
        startedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(isPrescriptionIncomplete(complete), isFalse);

      final missingIndication = PrescriptionRecord(
        id: '3b',
        medicationName: const LocalizedText(
          ar: 'باراسيتامول',
          en: 'Paracetamol',
        ),
        orderType: PrescriptionOrderType.prnAsNeeded,
        doseAmount: 500,
        doseUnit: 'mg',
        prnMaxPerDay: 4,
        startedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(isPrescriptionIncomplete(missingIndication), isTrue);

      final missingMax = complete.copyWith(prnMaxPerDay: 0);
      expect(isPrescriptionIncomplete(missingMax), isTrue);
    });

    test('singleStatDose completeness rules', () {
      final complete = PrescriptionRecord(
        id: '4',
        medicationName: const LocalizedText(ar: 'جرعة', en: 'Stat Dose'),
        orderType: PrescriptionOrderType.singleStatDose,
        doseAmount: 1,
        doseUnit: 'ampoule',
        startedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(isPrescriptionIncomplete(complete), isFalse);

      final missingDose = complete.copyWith(doseAmount: 0);
      expect(isPrescriptionIncomplete(missingDose), isTrue);
    });

    test('topicalOrTitrated completeness rules', () {
      final complete = PrescriptionRecord(
        id: '5',
        medicationName: const LocalizedText(ar: 'مرهم', en: 'Ointment'),
        orderType: PrescriptionOrderType.topicalOrTitrated,
        instructions: const LocalizedText(
          ar: 'مرتين يومياً',
          en: 'Twice daily',
        ),
        startedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(isPrescriptionIncomplete(complete), isFalse);

      final missingInstructions = PrescriptionRecord(
        id: '5b',
        medicationName: const LocalizedText(ar: 'مرهم', en: 'Ointment'),
        orderType: PrescriptionOrderType.topicalOrTitrated,
        startedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      expect(isPrescriptionIncomplete(missingInstructions), isTrue);

      final emptyInstructions = complete.copyWith(
        instructions: const LocalizedText(ar: '', en: ' '),
      );
      expect(isPrescriptionIncomplete(emptyInstructions), isTrue);
    });
  });

  group('SavePrescriptionUseCase — Clinical Safety and Task Generation', () {
    final fixedClock = FixedClock(DateTime.utc(2026, 3, 1, 8, 0));
    final idGen = SequentialIdGenerator();

    test(
      'MANDATORY CLINICAL SAFETY: Frequency without explicit administration times creates 0 tasks and requires configuration',
      () async {
        final repo = _FakePatientRecordRepository();
        final useCase = SavePrescriptionUseCase(
          repository: repo,
          clock: fixedClock,
          ids: idGen,
        );

        final prescription = PrescriptionRecord(
          id: 'rx-1',
          medicationName: const LocalizedText(
            ar: 'أموكسيسيلين',
            en: 'Amoxicillin',
          ),
          orderType: PrescriptionOrderType.regularCourse,
          doseAmount: 500,
          doseUnit: 'mg',
          frequencyPerDay: 3,
          durationDays: 5,
          doseTimesMinutes: const [], // NO explicit administration times!
          startedAt: fixedClock.nowUtc(),
          createdAt: fixedClock.nowUtc(),
          updatedAt: fixedClock.nowUtc(),
        );

        final result = await useCase(prescription);

        expect(
          result.createdTasks,
          isEmpty,
          reason: 'Must never invent administration times from frequency alone',
        );
        expect(result.requiresReminderConfiguration, isTrue);
        expect(repo.savedTasks, isEmpty);
        expect(repo.savedPrescription, isNotNull);
      },
    );

    test(
      'Explicit administration times generate appropriate tasks capped by horizon and duration',
      () async {
        final repo = _FakePatientRecordRepository();
        final useCase = SavePrescriptionUseCase(
          repository: repo,
          clock: fixedClock,
          ids: idGen,
        );

        final prescription = PrescriptionRecord(
          id: 'rx-2',
          medicationName: const LocalizedText(
            ar: 'أموكسيسيلين',
            en: 'Amoxicillin',
          ),
          orderType: PrescriptionOrderType.regularCourse,
          doseAmount: 500,
          doseUnit: 'mg',
          frequencyPerDay: 3,
          durationDays: 5,
          doseTimesMinutes: const [
            480,
            840,
            1200,
          ], // 08:00, 14:00, 20:00 explicitly set
          startedAt: fixedClock.nowUtc(),
          createdAt: fixedClock.nowUtc(),
          updatedAt: fixedClock.nowUtc(),
        );

        final result = await useCase(prescription);

        // 5 days * 3 times = 15 tasks
        expect(result.createdTasks.length, 15);
        expect(result.requiresReminderConfiguration, isFalse);
        expect(repo.savedTasks.length, 15);

        // Verify task titles contain Western digits only
        for (final task in result.createdTasks) {
          expect(task.title.ar, contains('500'));
          expect(task.title.en, contains('500'));
          // Must not contain Arabic-Indic digits
          expect(task.title.ar.contains(RegExp(r'[\u0660-\u0669]')), isFalse);
          expect(task.source, TaskSource.system);
          expect(task.category, TaskCategory.medication);
          expect(task.linkedEntityId, 'rx-2');
        }
      },
    );

    test(
      'Long-term maintenance with explicit administration times creates tasks for 7-day horizon',
      () async {
        final repo = _FakePatientRecordRepository();
        final useCase = SavePrescriptionUseCase(
          repository: repo,
          clock: fixedClock,
          ids: idGen,
        );

        final prescription = PrescriptionRecord(
          id: 'rx-3',
          medicationName: const LocalizedText(
            ar: 'أملوديبين',
            en: 'Amlodipine',
          ),
          orderType: PrescriptionOrderType.longTermMaintenance,
          doseAmount: 5,
          doseUnit: 'mg',
          frequencyPerDay: 1,
          doseTimesMinutes: const [480], // 08:00
          startedAt: fixedClock.nowUtc(),
          createdAt: fixedClock.nowUtc(),
          updatedAt: fixedClock.nowUtc(),
        );

        final result = await useCase(prescription);

        // 7 days * 1 time = 7 tasks
        expect(result.createdTasks.length, 7);
        expect(result.requiresReminderConfiguration, isFalse);
      },
    );

    test(
      'Incomplete prescription generates 0 tasks and sets warning',
      () async {
        final repo = _FakePatientRecordRepository();
        final useCase = SavePrescriptionUseCase(
          repository: repo,
          clock: fixedClock,
          ids: idGen,
        );

        final incompleteRx = PrescriptionRecord(
          id: 'rx-4',
          medicationName: const LocalizedText(
            ar: 'دواء ناقص',
            en: 'Incomplete Rx',
          ),
          orderType: PrescriptionOrderType.regularCourse,
          doseAmount: 0, // Incomplete!
          doseUnit: 'mg',
          frequencyPerDay: 2,
          durationDays: 5,
          doseTimesMinutes: const [480, 1200],
          startedAt: fixedClock.nowUtc(),
          createdAt: fixedClock.nowUtc(),
          updatedAt: fixedClock.nowUtc(),
        );

        final result = await useCase(incompleteRx);

        expect(result.hasIncompleteWarning, isTrue);
        expect(result.createdTasks, isEmpty);
        expect(repo.savedTasks, isEmpty);
      },
    );

    test(
      'PRN, stat dose, and topical never get automatic reminder tasks',
      () async {
        final repo = _FakePatientRecordRepository();
        final useCase = SavePrescriptionUseCase(
          repository: repo,
          clock: fixedClock,
          ids: idGen,
        );

        final prn = PrescriptionRecord(
          id: 'rx-5',
          medicationName: const LocalizedText(
            ar: 'باراسيتامول',
            en: 'Paracetamol',
          ),
          orderType: PrescriptionOrderType.prnAsNeeded,
          doseAmount: 500,
          doseUnit: 'mg',
          prnIndication: const LocalizedText(ar: 'للألم', en: 'For pain'),
          prnMaxPerDay: 3,
          startedAt: fixedClock.nowUtc(),
          createdAt: fixedClock.nowUtc(),
          updatedAt: fixedClock.nowUtc(),
        );

        final result = await useCase(prn);
        expect(result.createdTasks, isEmpty);
        expect(result.requiresReminderConfiguration, isFalse);
      },
    );
  });

  group('Privacy: toString() exposed data test', () {
    test('Entity toString() never exposes clinical/personal fields', () {
      final profile = PatientProfile(
        id: 'secret-id-123',
        fullName: const LocalizedText(ar: 'سالم أحمد', en: 'Salem Ahmed'),
        city: const LocalizedText(ar: 'بنغازي', en: 'Benghazi'),
        baladiya: const LocalizedText(ar: 'الصابري', en: 'Sabri'),
        emergencyContact: const EmergencyContact(
          name: LocalizedText(ar: 'فاطمة', en: 'Fatima'),
          relationship: LocalizedText(ar: 'أخت', en: 'Sister'),
          phone: '+218910000000',
        ),
        updatedAt: DateTime.utc(2026, 1, 1),
      );

      final str = profile.toString();
      expect(str.contains('Salem'), isFalse);
      expect(str.contains('سالم'), isFalse);
      expect(str.contains('secret-id-123'), isFalse);
      expect(str.contains('+218910000000'), isFalse);
      expect(str, 'PatientProfile()');

      final entry = ClinicalEntry(
        entryId: 'entry-secret-999',
        category: ClinicalCategory.chronicCondition,
        title: const LocalizedText(ar: 'السكري', en: 'Diabetes'),
        details: const LocalizedText(ar: 'النوع 2', en: 'Type 2'),
        recordedAt: DateTime.utc(2026, 1, 1),
        versionCreatedAt: DateTime.utc(2026, 1, 1),
      );
      expect(entry.toString().contains('Diabetes'), isFalse);
      expect(entry.toString().contains('entry-secret-999'), isFalse);
      expect(entry.toString(), 'ClinicalEntry()');

      final encounter = EncounterRecord(
        id: 'enc-secret-555',
        type: EncounterType.emergency,
        occurredAt: DateTime.utc(2026, 1, 1),
        facilityName: const LocalizedText(
          ar: 'مستشفى طرابلس',
          en: 'Tripoli Hospital',
        ),
        chiefComplaint: const LocalizedText(
          ar: 'ألم في الصدر',
          en: 'Chest pain',
        ),
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      );
      expect(encounter.toString().contains('Tripoli'), isFalse);
      expect(encounter.toString().contains('enc-secret-555'), isFalse);
      expect(encounter.toString(), 'EncounterRecord()');
    });
  });
}
