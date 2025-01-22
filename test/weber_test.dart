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
      expectThat((c1 as dynamic).hello).isNotNull;
    });
  });
}

@Controller()
class Controller1 {}
