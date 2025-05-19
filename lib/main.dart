import 'package:darto/darto.dart';

import 'router.dart';

void main() {
  final app = Darto();

  app.use('/api/v1', rootRouter());

  app.listen(3000, () {
    print("Server is running");
  });
}
