# WECARE — Sprint 1 Toolchain Verification & Environment Details

## Environment Summary
- **Flutter SDK**: 3.41.2 (Channel stable, revision 90673a4eef)
- **Dart SDK**: 3.11.0 (build 3.11.0 on linux_x64)
- **Java Runtime**: OpenJDK 21.0.10+7-Ubuntu-124.04 (Temurin compatible)
- **Android SDK**:
  - Platforms: Android API 35 (), API 34 ()
  - Build-Tools:
  - Target SDK: 35
  - Min SDK: 24
- **Melos**: Configured with pub workspaces in root .

## Deviation & Justification
The original specification proposed pinning Flutter 3.44.0 with Dart SDK .
In this sandbox environment, the pre-installed stable toolchain is **Flutter 3.41.2** with **Dart 3.11.0**.
As sanctioned by section 2 of the Sprint 1 specification, the SDK constraint across all workspace members has been adjusted to , and  pins .
Pub workspaces are supported (Dart 3.6+).

## Verification Status
- Workspace resolution:  succeeds.
- Toolchain script:
