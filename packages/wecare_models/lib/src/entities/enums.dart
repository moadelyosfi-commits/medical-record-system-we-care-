enum ProvenanceStatus {
  patientReported,
  clinicianVerified,
  disputedConflict,
  enteredInError,
}

enum PrescriptionOrderType {
  regularCourse,
  longTermMaintenance,
  prnAsNeeded,
  singleStatDose,
  topicalOrTitrated,
}

enum InvestigationStatus {
  suggested,
  ordered,
  collected,
  processing,
  resultAvailable,
  reviewed;

  bool canTransitionTo(InvestigationStatus next) => next.index > index;
}

enum TaskCategory { medication, investigation, followUp, generalInstruction }

enum TaskSource { system, patient }

enum ClinicalCategory { allergy, chronicCondition, surgery, vital }

enum LinkedEntityType {
  none,
  encounter,
  prescription,
  investigation,
  clinicalEntry,
}

enum AttachmentKind { prescriptionPhoto, labResultPhoto, other }

enum EncounterType { consultation, emergency, followUp, patientLogged }

enum Sex { female, male, unspecified }

enum BloodGroup {
  aPositive,
  aNegative,
  bPositive,
  bNegative,
  abPositive,
  abNegative,
  oPositive,
  oNegative,
  unknown,
}

enum ThemePreference { system, light, dark }

enum LabFlag { normal, low, high, critical, unknown }
