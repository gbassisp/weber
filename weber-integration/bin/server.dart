import 'package:weber/weber.dart';
import 'controllers/controller1.dart';

void main(List<String> args) async {
  final server = WebServer();
  final controller1 = Controller1();
  final _ = controller1.endpoint;

  server.addController(Controller1());
  await server.start();
}
