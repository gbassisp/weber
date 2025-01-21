import 'package:expector/expector.dart';
import 'package:test/test.dart';
import 'package:weber/weber.dart';

void main() {
  group('A group of tests', () {
    final awesome = WebServer();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expectThat(awesome).isNotNull;
    });
  });
}
