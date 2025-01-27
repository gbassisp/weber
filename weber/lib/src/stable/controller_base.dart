// import 'package:shelf/shelf.dart';

/// a wrapper for the shelf package
mixin ControllerBase {
  // implemented by macro:

  /// the endpoint of the controller
  String get endpoint;

  /// temporary method for experimentation
  String serveGet();

  // concrete methods:

  /// the normalized endpoint of the controller
  String get normalizedEndpoint =>
      endpoint.endsWith('/') ? endpoint : '$endpoint/';
}
