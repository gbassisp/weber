import 'package:weber/weber.dart';
import 'controllers/controller1.dart';

void main(List<String> args) async {
  final server = WebServer();

  server.addController(Controller1());
  await server.start();
}
