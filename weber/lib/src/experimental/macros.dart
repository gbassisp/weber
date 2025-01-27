
import 'dart:async';

import 'package:lean_extensions/dart_essentials.dart';
import 'package:macros/macros.dart';
import 'macros_abstractions.dart';

final _controllerBase = Uri.parse('package:weber/src/stable/controller_base.dart');
/// annotation to generate a controller class
macro class Controller implements ClassDeclarationsMacro, ClassTypesMacro {
  /// Creates a new [Controller] instance.
  const Controller([this._endpoint = string.empty]);
  final String _endpoint;
  String get _quotedEndpoint => '"$_endpoint"';
  ClassMember _getServeGet(MacroBuilder builder) => MethodMember(
      type: builder.coreTypes.$String, 
      name: 'serveGet',
      body: '''
{
  return $_quotedEndpoint;
}
''',
  );
  ClassMember _getEndpoint(MacroBuilder builder) => GetterMember(
    type: builder.coreTypes.$String,
    name: 'endpoint',
    body: '''
{
// macro is generated with a failing part directive analysis
// ignore_for_file: non_part_of_directive_in_part

  return $_quotedEndpoint;
}
''',
  );
  ClassMember _getControllerBase(Identifier controllerBase) => 
    SimpleIdentifiedFieldMember(
      type: controllerBase,
      name: 'controller',
    );
  
    @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final macroBuilder = await loadMacroBuilder(clazz, builder);
    final controller = await macroBuilder.loadPackage(
      _controllerBase, 
    'ControllerBase',
    );
    final _ = _getControllerBase(controller);

    macroBuilder
    ..addMember(_getServeGet(macroBuilder))
    // ..addMember(_getControllerBase(controller))
    ..addMember(_getEndpoint(macroBuilder));
  }

  @override
  FutureOr<void> buildTypesForClass(
    ClassDeclaration clazz, 
    ClassTypeBuilder builder,
  ) async {
    final macroBuilder = await loadMacroBuilder(clazz, builder);
    final c = macroBuilder.coreTypes.$ControllerBase;
    builder.appendMixins([NamedTypeAnnotationCode(name: c)]);
  }
}

// adapted from Alexey Inkin example:
// https://medium.com/@alexey.inkin/creating-your-own-macro-instead-of-code-generation-in-dart-3-5-27274f8a5bf6

// final _dartCore = Uri.parse('dart:core');


// macro class Controller2 implements ClassDeclarationsMacro {
//   const Controller2();
 
//   @override
//   Future<void> buildDeclarationsForClass(
//     ClassDeclaration clazz,
//     MemberDeclarationBuilder builder,
//   ) async {
//     final fields = await builder.fieldsOf(clazz);
//     final fieldsString = fields.map((f) => f.identifier.name).join(', ');

//     // ignore: deprecated_member_use - experimental API
//     final print = await builder.resolveIdentifier(_dartCore, 'print');

//     builder.declareInType(
//       DeclarationCode.fromParts([
//         'void hello() {',
//         // print,
//         'assert(true, "Hello");}',
//         // '("Hello! I am ${clazz.identifier.name}. I have $fieldsString.");}',
//       ]),
//     );
//   } 
// }
