import 'package:dartonic/dartonic.dart';

import '../schemas/todo_table_schema.dart';

final dartonic = Dartonic('sqlite::memory:', schemas: [todoTableSchema]);

final db = dartonic.I;
