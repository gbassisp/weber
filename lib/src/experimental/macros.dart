
import 'package:lean_extensions/dart_essentials.dart';
import 'package:macros/macros.dart';
import 'package:weber/src/experimental/macros_abstractions.dart';

// final _controllerBase = Uri.parse('package:weber/weber.dart');
final _controllerBase = Uri.parse('package:weber/src/stable/controller_base.dart');
/// annotation to generate a controller class
macro class Controller implements ClassDeclarationsMacro {
  /// Creates a new [Controller] instance.
  const Controller([this._endpoint = string.empty]);
  final String _endpoint;
  String get _quotedEndpoint => '"$_endpoint"';
  ClassMember get _serveGet => MethodMember(
      type: 'void', 
      name: 'serveGet',
      body: '{$_quotedEndpoint;}',
  );
  ClassMember get _controllerAttribute => FieldMember(
    type: 'String',
    name: 'endpoint',
    value: _quotedEndpoint,
  );
  ClassMember _getControllerBase(Identifier controllerBase) => 
    SimpleIdentifiedFieldMember(
      typeIdentifier: controllerBase,
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
    ..addMember(_serveGet)
    // ..addMember(_getControllerBase(controller))
    ..addMember(_controllerAttribute);
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
