#!/usr/bin/env bash
set -euo pipefail

fail=0

echo "Running WeCare isolation and architecture checks..."

# 1. Nothing but wecare_storage itself and main_dev.dart may reference wecare_storage
hits=$(grep -rn --include='*.dart' --include='pubspec.yaml' 'wecare_storage' \
  packages/wecare_models packages/wecare_ui packages/wecare_feature_* apps/patient_app/lib apps/patient_app/pubspec.yaml \
  | grep -v 'apps/patient_app/lib/main_dev.dart' | grep -v 'apps/patient_app/pubspec.yaml' || true)

if [ -n "$hits" ]; then
  echo "ISOLATION VIOLATION (wecare_storage referenced outside main_dev.dart):"
  echo "$hits"
  fail=1
fi

# 2. No feature package depends on another feature package
for d in packages/wecare_feature_*; do
  self=$(basename "$d")
  hits=$(grep -n 'wecare_feature_' "$d/pubspec.yaml" | grep -v "name: $self" || true)
  if [ -n "$hits" ]; then
    echo "FEATURE-TO-FEATURE DEPENDENCY in $d:"
    echo "$hits"
    fail=1
  fi
done

# 3. No print / debugPrint outside test directories
hits=$(grep -rnE '(^|[^a-zA-Z_])(print|debugPrint)\(' --include='*.dart' packages apps | grep -v '/test/' | grep -v '\.g\.dart' || true)
if [ -n "$hits" ]; then
  echo "PRINT VIOLATION (print or debugPrint found):"
  echo "$hits"
  fail=1
fi

if [ $fail -eq 0 ]; then
  echo "All isolation and architectural checks PASSED!"
else
  echo "Isolation checks FAILED."
fi

exit $fail
