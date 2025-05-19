import 'package:darto/darto.dart';
import 'package:zard/zard.dart';

class TodoController {
  int _idCounter = 0;
  final List _todos = [];

  void getAllTodos(Request req, Response res) {
    return res.status(200).json(_todos);
  }

  Future<void> create(Request req, Response res) async {
    final bodySchema = z.map({
      'title': z.string().min(3).max(100),
      'completed': z.bool().optional(),
    });

    try {
      final todo = bodySchema.parse(await req.body);
      _todos.add({'id': _idCounter++, ...todo!});
      return res.status(201).end();
    } on ZardError catch (e) {
      return res.status(400).json({'error': e.format()});
    }
  }

  Future<void> update(Request req, Response res) async {
    final paramsSchema = z.coerce.int();
    final bodySchema = z.map({
      'title': z.string().min(3).max(100).optional(),
      'completed': z.bool().optional(),
    });

    try {
      final id = paramsSchema.parse(req.params['id']);
      final body = bodySchema.parse(await req.body);

      final index = _todos.indexWhere((todo) => todo['id'] == id);
      if (index == -1) return res.status(404).json({'error': 'Todo not found'});

      _todos[index] = {'id': id, ...body!};
      return res.status(200).json(_todos[index]);
    } on ZardError catch (e) {
      return res.status(400).json({'error': e.format()});
    }
  }

  void delete(Request req, Response res) {
    final paramsSchema = z.coerce.int();

    try {
      final id = paramsSchema.parse(req.params['id']);

      final index = _todos.indexWhere((todo) => todo['id'] == id);

      if (index == -1) return res.status(404).json({'error': 'Todo not found'});

      _todos.removeAt(index);
      return res.status(204).end();
    } on ZardError catch (e) {
      return res.status(400).json({'error': e.format()});
    }
  }
}
