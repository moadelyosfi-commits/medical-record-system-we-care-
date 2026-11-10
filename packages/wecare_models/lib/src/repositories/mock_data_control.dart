enum DemoPatientId { chronicHypertensionDiabetes, acuteRespiratory }

abstract interface class MockDataControl {
  DemoPatientId get activeDemoPatient;
  Future<void> resetToSeedData();
  Future<void> loadDemoPatient(DemoPatientId id);
}
