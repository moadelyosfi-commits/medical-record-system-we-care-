#!/usr/bin/env bash
set -euo pipefail

echo "=== WECARE Toolchain Verification ==="
echo "Flutter version:"
flutter --version
echo "-------------------------------------"
echo "Dart version:"
dart --version
echo "-------------------------------------"
echo "Java version:"
java -version
echo "-------------------------------------"
echo "Android SDK location: ${ANDROID_HOME:-not set}"
if [ -d "${ANDROID_HOME:-/opt/android-sdk}/build-tools" ]; then
  echo "Android build-tools:"
  ls -1 "${ANDROID_HOME:-/opt/android-sdk}/build-tools" || true
fi
if [ -d "${ANDROID_HOME:-/opt/android-sdk}/platforms" ]; then
  echo "Android platforms:"
  ls -1 "${ANDROID_HOME:-/opt/android-sdk}/platforms" || true
fi
echo "====================================="
echo "Building debug APK for verification..."
(cd apps/patient_app && flutter build apk --debug -t lib/main_dev.dart)
echo "Verification complete!"
