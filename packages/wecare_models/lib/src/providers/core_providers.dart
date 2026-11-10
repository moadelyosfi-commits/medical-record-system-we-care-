import 'package:riverpod/riverpod.dart';
import 'package:wecare_models/src/core/clock_and_ids.dart';
import 'package:wecare_models/src/repositories/mock_data_control.dart';
import 'package:wecare_models/src/repositories/patient_record_repository.dart';
import 'package:wecare_models/src/usecases/save_prescription_use_case.dart';

final appClockProvider = Provider<AppClock>((ref) => const SystemClock());
final idGeneratorProvider = Provider<IdGenerator>((ref) => UuidV7Generator());

final patientRecordRepositoryProvider = Provider<PatientRecordRepository>(
  (ref) => throw UnimplementedError('Override patientRecordRepositoryProvider'),
);
final appSettingsRepositoryProvider = Provider<AppSettingsRepository>(
  (ref) => throw UnimplementedError('Override appSettingsRepositoryProvider'),
);
final vaultSecurityBoundaryProvider = Provider<VaultSecurityBoundary>(
  (ref) => throw UnimplementedError('Override vaultSecurityBoundaryProvider'),
);

final mockDataControlProvider = Provider<MockDataControl?>((ref) => null);

final savePrescriptionUseCaseProvider = Provider<SavePrescriptionUseCase>(
  (ref) => SavePrescriptionUseCase(
    repository: ref.watch(patientRecordRepositoryProvider),
    clock: ref.watch(appClockProvider),
    ids: ref.watch(idGeneratorProvider),
  ),
);
