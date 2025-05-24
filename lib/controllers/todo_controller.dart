import 'package:darto/darto.dart';
import 'package:dartonic/dartonic.dart';
import 'package:zard/zard.dart';

import '../database/db.dart';

class TodoController {
  void getAllTodos(Request req, Response res) async {
    final todos = await db.select().from('todos');
    return res.status(200).json(todos);
  }

  Future<void> create(Request req, Response res) async {
    final bodySchema = z.map({'title': z.string().min(3).max(100), 'completed': z.bool().optional()});

    try {
      final todo = bodySchema.parse(await req.body);
      await db.insert('todos').values(todo!);
      return res.status(201).end();
    } on ZardError catch (e) {
      return res.status(400).json({'error': e.format()});
    }
  }

  Future<void> update(Request req, Response res) async {
    final paramsSchema = z.coerce.int();
    final bodySchema = z.map({'title': z.string().min(3).max(100).optional(), 'completed': z.bool().optional()});

    try {
      final id = paramsSchema.parse(req.params['id']);
      final body = bodySchema.parse(await req.body);

      final todoExists = await db.select().from('todos').where(eq('todos.id', id));

      if (todoExists.isEmpty) return res.status(404).json({'error': 'Todo not found'});

      final todo = await db.update('todos').set(body!).where(eq('todos.id', id)).returning();
      return res.status(200).json(todo);
    } on ZardError catch (e) {
      return res.status(400).json({'error': e.format()});
    }
  }

  void delete(Request req, Response res) async {
    final paramsSchema = z.coerce.int();

    try {
      final id = paramsSchema.parse(req.params['id']);

      final index = await db.select().from('todos').where(eq('todos.id', id));

      if (index.isEmpty) return res.status(404).json({'error': 'Todo not found'});

      await db.delete('todos').where(eq('todos.id', id));
      return res.status(204).end();
    } on ZardError catch (e) {
      return res.status(400).json({'error': e.format()});
    }
  }
}
