// names are not camel case because they match the dart core types
// ignore_for_file: non_constant_identifier_names

import 'package:macros/macros.dart';
import 'package:meta/meta.dart';
import 'package:weber/src/experimental/macros_abstractions.dart';

@internal
class CoreTypes {
  CoreTypes({
    required this.$String,
    required this.$int,
    required this.$double,
    required this.$num,
    required this.$bool,
  });

  final Identifier $String;
  final Identifier $int;
  final Identifier $double;
  final Identifier $num;
  final Identifier $bool;

  static Future<CoreTypes> fromMacros(MacroBuilder builder) async {
    final futures = <Future<Identifier>>[
      builder.loadPackage(Uri.parse('dart:core'), 'String'),
      builder.loadPackage(Uri.parse('dart:core'), 'int'),
      builder.loadPackage(Uri.parse('dart:core'), 'double'),
      builder.loadPackage(Uri.parse('dart:core'), 'num'),
      builder.loadPackage(Uri.parse('dart:core'), 'bool'),
    ];
    final results = await Future.wait(futures);
    return CoreTypes(
      $String: results[0],
      $int: results[1],
      $double: results[2],
      $num: results[3],
      $bool: results[4],
    );
  }

  final String lib = 'dart:core';
  late final Uri uri = Uri.parse(lib);
}
