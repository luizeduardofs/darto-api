import 'package:darto/darto.dart';

loggerMiddleware(Request req, Response res, Next next) {
  print('${req.method} | ${req.path} | ${DateTime.now()}');
  next();
}
