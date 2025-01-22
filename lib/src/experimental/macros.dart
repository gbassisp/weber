
import 'package:lean_extensions/lean_extensions.dart';
import 'package:macros/macros.dart';
import 'package:weber/src/experimental/macros_abstractions.dart';


/// annotation to generate a controller class
macro class Controller implements SimplifiedMacro {
  /// Creates a new [Controller] instance.
  const Controller();
  
  @override
  void buildMacro(MacroBuilder builder) {
    builder.addMember(MethodMember(name: 'hello', type: 'void', body: '{assert(true, "Hello");}',));
  }

    @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final macroBuilder = MacroBuilder(clazz, builder);
    final fields = await builder.fieldsOf(clazz);
    final fieldsString = fields.map((f) => f.identifier.name); //.join(', ');

    macroBuilder.membersNames = fieldsString.toArray();

    macroBuilder.addMember(MethodMember(type: 'void', name: 'hello', body: '{}',));
  }
}

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