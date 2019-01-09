// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analysis_server/src/services/correction/fix.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'fix_processor.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(RemoveDeadCodeTest);
  });
}

@reflectiveTest
class RemoveDeadCodeTest extends FixProcessorTest {
  @override
  FixKind get kind => DartFixKind.REMOVE_DEAD_CODE;

  test_condition() async {
    await resolveTestUnit('''
main(int p) {
  if (true || p > 5) {
    print(1);
  }
}
''');
    await assertHasFix('''
main(int p) {
  if (true) {
    print(1);
  }
}
''');
  }

  test_statements_one() async {
    await resolveTestUnit('''
int main() {
  print(0);
  return 42;
  print(1);
}
''');
    await assertHasFix('''
int main() {
  print(0);
  return 42;
}
''');
  }

  test_statements_two() async {
    await resolveTestUnit('''
int main() {
  print(0);
  return 42;
  print(1);
  print(2);
}
''');
    await assertHasFix('''
int main() {
  print(0);
  return 42;
}
''');
  }
}
