import 'package:lean_extensions/dart_essentials.dart';
import 'package:macros/macros.dart';

/// create and load a [MacroBuilder] instance
Future<MacroBuilder> loadMacroBuilder(
  ClassDeclaration clazz,
  MemberDeclarationBuilder builder,
) async {
  final b = MacroBuilder._(clazz, builder);
  await b._load();

  return b;
}

/// a high level abstraction to delegate the building of a macro with easier
/// to use methods
class MacroBuilder {
  MacroBuilder._(this._clazz, this._builder);
  final ClassDeclaration _clazz;
  final MemberDeclarationBuilder _builder;

  Future<void> _load() async {
    final fields = await _builder.fieldsOf(_clazz);
    final fieldsString = fields.map((f) => f.identifier.name).toList();
    _membersNames = fieldsString;
  }

  List<String> _membersNames = [];

  /// safely adds a new [ClassMember] to the class
  void addMember(ClassMember member) {
    if (_membersNames.contains(member.name)) {
      return;
    }
    _membersNames.add(member.name);
    _builder.declareInType(member.toDeclarationCode());
  }

  /// loads a member from a package
  Future<Identifier> loadPackage(Uri uri, String member) {
    // ignore: deprecated_member_use - unstable API
    return _builder.resolveIdentifier(uri, member);
  }
}

/// a high level abstraction to build a class member
abstract class ClassMember {
  /// the type of the member
  String get type;

  /// the name of the member
  String get name;

  /// the macro declaration code used to generate the member
  DeclarationCode toDeclarationCode();
}

/// a final attribute with a default constructor instance value
class SimpleIdentifiedFieldMember implements ClassMember {
  /// creates a new [SimpleIdentifiedFieldMember] instance
  SimpleIdentifiedFieldMember({
    required this.typeIdentifier,
    required this.name,
  });
  @override
  final String name;
  @override
  String get type => typeIdentifier.name;

  /// the [Identifier] type of the member
  final Identifier typeIdentifier;

  @override
  String toString() => 'final $type $name;';
  @override
  DeclarationCode toDeclarationCode() {
    return DeclarationCode.fromParts([
      'final',
      ' ',
      typeIdentifier,
      ' ',
      name,
      ' ',
      '=',
      ' ',
      typeIdentifier,
      '()',
      ';',
    ]);
  }
}

/// simple field member with a default value
class FieldMember implements ClassMember {
  /// creates a new [FieldMember] instance
  FieldMember({
    required this.type,
    required this.name,
    required this.value,
  });
  @override
  final String name;
  @override
  final String type;

  /// the default value of the member
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

/// a method member with a body
class MethodMember implements ClassMember {
  /// creates a new [MethodMember] instance
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

  /// the arguments of the method
  final String args;

  /// the body of the method
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
