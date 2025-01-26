import 'package:lean_extensions/dart_essentials.dart';
import 'package:macros/macros.dart';
import 'package:meta/meta.dart';
import 'package:weber/src/experimental/type_identifiers.dart';

/// create and load a [MacroBuilder] instance
Future<MacroBuilder> loadMacroBuilder(
  ClassDeclaration clazz,
  Builder builder,
) async {
  final b = MacroBuilder._(clazz, builder);
  await b._load();

  return b;
}

@internal
class MacroBuilder {
  MacroBuilder._(this._clazz, this._builder);
  final ClassDeclaration _clazz;
  final Builder _builder;

  Future<void> _load() async {
    final b = _builder;
    if (b is MemberDeclarationBuilder) {
      final fields = await b.fieldsOf(_clazz);
      final fieldsString = fields.map((f) => f.identifier.name).toList();
      _membersNames = fieldsString;
      await _loadCoreTypes();
    }
  }

  Future<void> _loadCoreTypes() async {
    coreTypes = await CoreTypes.fromMacros(this);
  }

  List<String> _membersNames = [];
  late final CoreTypes coreTypes;
  void addMember(ClassMember member) {
    final b = _builder;
    if (_membersNames.contains(member.name)) {
      return;
    }
    if (b is MemberDeclarationBuilder) {
      _membersNames.add(member.name);
      b.declareInType(member.toDeclarationCode());
    }
  }

  /// loads a member from a package
  Future<Identifier?> tryLoadPackage(Uri uri, String member) async {
    final b = _builder;
    if (b is MemberDeclarationBuilder) {
      return b.loadPackage(uri, member);
    }
    return null;
  }

  /// loads a member from a package
  Future<Identifier> loadPackage(Uri uri, String member) {
    return tryLoadPackage(uri, member).then((value) => value!);
  }
}

@internal
extension TypeLoadingExtensions on Builder {
  Future<Identifier> loadPackage(Uri uri, String member) async {
    final b = this;
    if (b is DeclarationBuilder) {
      // ignore: deprecated_member_use - unstable API
      return b.resolveIdentifier(uri, member);
    }
    if (b is TypeBuilder) {
      // ignore: deprecated_member_use - unstable API
      return b.resolveIdentifier(uri, member);
    }
    throw StateError('Builder is not a MemberDeclarationBuilder');
  }

  Future<Identifier> get $ControllerBase async {
    return loadPackage(
      Uri.parse('package:weber/src/stable/controller_base.dart'),
      'ControllerBase',
    );
  }
}

@internal
abstract class ClassMember {
  /// the type of the member
  Identifier get type;

  /// the name of the member
  String get name;

  /// the macro declaration code used to generate the member
  DeclarationCode toDeclarationCode();
}

/// a final attribute with a default constructor instance value
class SimpleIdentifiedFieldMember implements ClassMember {
  /// creates a new [SimpleIdentifiedFieldMember] instance
  SimpleIdentifiedFieldMember({
    required this.type,
    required this.name,
  });
  @override
  final String name;
  @override
  final Identifier type;

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
      type,
      '()',
      ';',
    ]);
  }
}

/// simple getter member
class GetterMember implements ClassMember {
  /// creates a new [GetterMember] instance
  GetterMember({
    required this.type,
    required this.name,
    required this.body,
  });
  @override
  final String name;
  @override
  final Identifier type;

  /// the body of the getter
  final String body;

  @override
  String toString() => '$type get $name $body';
  @override
  DeclarationCode toDeclarationCode() {
    return DeclarationCode.fromParts([
      type,
      ' ',
      'get',
      ' ',
      name,
      ' ',
      body,
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
  final Identifier type;

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
  final Identifier type;

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
