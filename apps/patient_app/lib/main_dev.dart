import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patient_app/app.dart';
import 'package:patient_app/dev/dev_mock_storage.dart';
import 'package:wecare_models/wecare_models.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const clock = SystemClock();
  final ids = UuidV7Generator();
  final mockRepo = DevMockPatientRecordRepository(clock: clock, ids: ids);
  final mockSettings = DevMockSettingsRepository();
  const mockBoundary = DevMockVaultSecurityBoundary();

  runApp(
    ProviderScope(
      overrides: [
        appClockProvider.overrideWithValue(clock),
        idGeneratorProvider.overrideWithValue(ids),
        patientRecordRepositoryProvider.overrideWithValue(mockRepo),
        appSettingsRepositoryProvider.overrideWithValue(mockSettings),
        vaultSecurityBoundaryProvider.overrideWithValue(mockBoundary),
        mockDataControlProvider.overrideWithValue(mockRepo),
      ],
      child: const WeCareApp(),
    ),
  );
}
