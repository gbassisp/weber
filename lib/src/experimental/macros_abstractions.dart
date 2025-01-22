import 'package:lean_extensions/dart_essentials.dart';
import 'package:lean_extensions/lean_extensions.dart';
import 'package:macros/macros.dart';

class MacroBuilder {
  MacroBuilder(this._clazz, this._builder);
  final ClassDeclaration _clazz;
  final MemberDeclarationBuilder _builder;

  List<String> membersNames = [];

  void addMember(ClassMember member) {
    if (membersNames.contains(member.name)) {
      return;
    }
    _builder.declareInType(member.toDeclarationCode());
  }
}

abstract class ClassMember {
  String get type;
  String get name;
  DeclarationCode toDeclarationCode();
}

class FieldMember implements ClassMember {
  FieldMember({
    required this.type,
    required this.name,
    required this.value,
  });
  @override
  final String name;
  @override
  final String type;
  final String value;

  @override
  String toString() => 'final $type $name;';
  @override
  DeclarationCode toDeclarationCode() {
    return DeclarationCode.fromParts([
      'final',
      ' ',
      type,
      ' ',
      name,
      ' ',
      '=',
      ' ',
      value,
      ' ',
      ';',
    ]);
  }
}

class MethodMember implements ClassMember {
  MethodMember({
    required this.type,
    required this.name,
    this.args = string.empty,
    this.body = string.empty,
  });
  @override
  final String name;
  @override
  final String type;

  final String args;

  final String body;

  @override
  String toString() => '$type $name($args) $body';

  @override
  DeclarationCode toDeclarationCode() {
    return DeclarationCode.fromParts([
      type,
      ' ',
      name,
      ' ',
      '($args)',
      ' ',
      body,
    ]);
  }
}

// final _dartCore = Uri.parse('dart:core');

abstract class SimplifiedMacro implements ClassDeclarationsMacro {
  const SimplifiedMacro();

  void buildMacro(MacroBuilder builder);

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final macroBuilder = MacroBuilder(clazz, builder);
    final fields = await builder.fieldsOf(clazz);
    final fieldsString = fields.map((f) => f.identifier.name); //.join(', ');

    macroBuilder.membersNames = fieldsString.toArray();
    //   // ignore: deprecated_member_use - experimental API
    //   final print = await builder.resolveIdentifier(_dartCore, 'print');

    //   builder.declareInType(
    //     DeclarationCode.fromParts([
    //       'void hello() {',
    //       print,
    //       '("Hello! I am ${clazz.identifier.name}. I have $fieldsString.");}',
    //     ]),
    //   );
  }
}
