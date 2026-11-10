import 'package:flutter_test/flutter_test.dart';
import 'package:wecare_feature_home_tasks/routes.dart';

void main() {
  test('homeTasksBranch returns valid StatefulShellBranch', () {
    final branch = homeTasksBranch();
    expect(branch.routes.isNotEmpty, isTrue);
  });
}
