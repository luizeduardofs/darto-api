import 'package:darto/darto.dart';

import 'controllers/todo_controller.dart';
import 'middleware/logger_middleware.dart';

Router rootRouter() {
  final router = Router();

  final todoController = TodoController();

  router.get("/todo", loggerMiddleware, todoController.getAllTodos);
  router.post("/todo", loggerMiddleware, todoController.create);
  router.put("/todo/:id", loggerMiddleware, todoController.update);
  router.delete("/todo/:id", loggerMiddleware, todoController.delete);

  return router;
}
