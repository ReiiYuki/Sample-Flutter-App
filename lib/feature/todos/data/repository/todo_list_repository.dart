
import 'package:sample_todo/feature/todos/domain/todo.dart';

abstract class TodoListDataProvider {
  Future<List<Todo>> getTodos();
  Future<List<Todo>> updateTodos(List<Todo> todos);
}

class TodoListRepository {
  final TodoListDataProvider dataProvider;

  TodoListRepository({ required this.dataProvider});

  Future<List<Todo>> getTodos() {
    return dataProvider.getTodos();
  }

  Future<List<Todo>> updateTodos(List<Todo> todos) {
    return dataProvider.updateTodos(todos);
  }
}
