# WECARE — Sprint 1 Revised Plan & Contracts (WECARE-DEV-KICKOFF-003)
Responds to: WECARE-DEV-KICKOFF-002 (Sprint 1 Plan Revision Directive) Baseline: ALIGN-002 (unchanged). No strategic decisions reopened. Commit this file to the repo as docs/sprint1/SPEC.md. It is the single source of truth for Sprint 1.
Verification status. The Dart code in sections 4 and 5 was written without a Dart SDK available and has not been compiled. Compiling it, with flutter analyze at 0 issues and the tests passing, is part of the S1-01 Definition of Done. If anything in the contracts fails to compile, fix the contract in S1-01 itself. Do not work around it downstream.

## 0. Decisions and corrections at a glance
| Item | Decision |
| :--- | :--- |
| State management and DI | Riverpod (flutter_riverpod; riverpod in pure-Dart packages). All DI is Riverpod providers. |
| Navigation | go_router. Each feature package exports its own routes. The app only composes them. |
| Investigation status | suggested → ordered → collected → processing → resultAvailable → reviewed. The UI stepper shows all six. |
| Medication-task creation | SavePrescriptionUseCase in wecare_models. Storage-independent. Clinical correction: Generate medication reminder tasks only when explicit administration times have been supplied/selected; never invent arbitrary administration times from frequency alone. |
| resetToSeedData() | Only on MockDataControl, never on PatientRecordRepository. |
| Mock isolation | Import rule, runtime guard and CI checks (see §8.2). |
| Digits | Western digits (0–9) for all clinical values in AR and EN. |
| Time | UTC everywhere in models. AppClock is injectable. IDs are UUIDv7 via IdGenerator. |
| Correction: Melos | Melos 7+ uses pub workspaces. melos.yaml no longer exists; configuration lives in the root pubspec.yaml under melos:. KICKOFF-001 said melos.yaml. That is technically obsolete, so this spec uses the root pubspec.yaml. |
| Correction: package layout | wecare_feature_onboarding_tasks is renamed wecare_feature_home_tasks, and Profile/Settings move into a new package wecare_feature_profile_settings. Sprint 1 has no onboarding. |
| android="false" in the directive | Interpreted as android:allowBackup="false" (plus data-extraction rules). |
| FLAG_SECURE | Evaluated and adopted (see §8.4). |

## 1. Revised Sprint 1 task breakdown
Rules for all tasks: feature branch feat/s1-..., one PR per task, 1 approving review, CI green, squash-merge to main. Every PR includes its own tests.
| ID | Branch | Owner | Milestone items | Depends on |
| :--- | :--- | :--- | :--- | :--- |
| S1-01 | feat/s1-01-monorepo-contracts | AI 1 | #1 foundation, contracts, CI, Android hardening | none |
| S1-02 | feat/s1-02-mock-repositories | AI 3 | storage for all workflows | S1-01 |
| S1-03 | feat/s1-03-design-system-l10n | AI 5 | #11 RTL/LTR, #12 components | S1-01 |
| S1-04 | feat/s1-04-home-tasks | AI 5 | #2 Home, #8 Tasks | S1-01 (merge after S1-02, S1-03) |
| S1-05 | feat/s1-05-profile-settings | AI 3 | #3 Profile, #10 Settings | S1-01 (merge after S1-02, S1-03) |
| S1-06 | feat/s1-06-records-encounters | AI 4 | #4 Records, #5 Encounters | S1-01 (merge after S1-02, S1-03) |
| S1-07 | feat/s1-07-meds-labs-attachments | AI 4 | #6 Medications, #7 Investigations, #9 Attachments | S1-06 |
| S1-08 | feat/s1-08-qa-apk-build | AI 6 | QA and installable APK | S1-04 to S1-07 |

The 10 screens:
1. Home Dashboard (/home, wecare_feature_home_tasks)
2. Tasks & Reminders (/home/tasks, wecare_feature_home_tasks)
3. Medical Records (/records, wecare_feature_clinical_vault)
4. Encounters & History (timeline) (/encounters, wecare_feature_clinical_vault)
5. Encounter Detail (/encounters/:id, wecare_feature_clinical_vault)
6. Medications (/medications, wecare_feature_clinical_vault)
7. Investigations (/investigations root route, wecare_feature_clinical_vault)
8. Attachments (/attachments root route, wecare_feature_clinical_vault)
9. Patient Profile (/settings/profile, wecare_feature_profile_settings)
10. Settings (/settings, wecare_feature_profile_settings)
Bottom tabs (5): Home/Tasks (/home), Records (/records), Visits (/encounters), Medications (/medications), Settings (/settings).
