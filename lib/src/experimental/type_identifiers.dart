// names are not camel case because they match the dart core types
// ignore_for_file: non_constant_identifier_names

import 'package:macros/macros.dart';
import 'package:meta/meta.dart';

@internal
class CoreTypes {
  CoreTypes({required this.String});

  final Identifier String;
}
