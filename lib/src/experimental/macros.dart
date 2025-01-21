import 'dart:async';

import 'package:macros/macros.dart';

final _dartCore = Uri.parse('dart:core');


/// annotation to generate a controller class
macro class Controller implements ClassDeclarationsMacro {
  /// Creates a new [Controller] instance.
  const Controller();

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final fields = await builder.fieldsOf(clazz);
    final fieldsString = fields.map((f) => f.identifier.name).join(', ');

    // ignore: deprecated_member_use - experimental API
    final print = await builder.resolveIdentifier(_dartCore, 'print');

    builder.declareInType(
      DeclarationCode.fromParts([
        'void hello() {',
        print,
        '("Hello! I am ${clazz.identifier.name}. I have $fieldsString.");}',
      ]),
    );
  }
}
