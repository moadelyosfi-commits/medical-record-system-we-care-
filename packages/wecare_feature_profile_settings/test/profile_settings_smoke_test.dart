import 'package:flutter_test/flutter_test.dart';
import 'package:wecare_feature_profile_settings/routes.dart';

void main() {
  test('settingsBranch returns valid StatefulShellBranch', () {
    final branch = settingsBranch();
    expect(branch.routes.isNotEmpty, isTrue);
  });
}
