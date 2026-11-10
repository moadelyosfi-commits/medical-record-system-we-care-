import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wecare_feature_clinical_vault/routes.dart';

void main() {
  test(
    'clinical_vault branches and root routes return valid route definitions',
    () {
      final rootNavKey = GlobalKey<NavigatorState>();
      expect(recordsBranch().routes.isNotEmpty, isTrue);
      expect(encountersBranch().routes.isNotEmpty, isTrue);
      expect(medicationsBranch().routes.isNotEmpty, isTrue);
      expect(clinicalVaultRootRoutes(rootNavKey).length, 2);
    },
  );
}
