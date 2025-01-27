// the test is meant to check the macros, so we want test to run even if the
// macros fail. This will give better feedback to the user.
// ignore_for_file: avoid_dynamic_calls

// type checking is part of the tests
// ignore_for_file: unnecessary_type_check

import 'package:expector/expector.dart';
import 'package:test/test.dart';
import 'package:weber/weber.dart';

void main() {
  group('macros', () {
    final c1 = Controller1();

    setUp(() {
      // Additional setup goes here.
    });

    test('has augmented methods', () {
      expectThat(c1).isNotNull;
      expectThat(c1.serveGet).isNotNull;
    });

    test('has endpoint', () {
      expectThat(c1.endpoint).isNotNull;
    });

    test('implements interface', () {
      expectThat(c1 is ControllerBase).isTrue;
    });
  });
}

@Controller('test')
class Controller1 {}
