import 'package:darto/darto.dart';

import 'database/db.dart';
import 'router.dart';

void main() async {
  await dartonic.sync();

  final app = Darto();

  app.use('/api/v1', rootRouter());

  app.listen(3000, () {
    print("Server is running");
  });
}
