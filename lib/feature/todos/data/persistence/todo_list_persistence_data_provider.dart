import 'package:sample_todo/feature/todos/data/repository/todo_list_repository.dart';
import 'package:sample_todo/feature/todos/domain/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListPersistenceDataProvider extends TodoListDataProvider {
  @override
  Future<List<Todo>> getTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var data = prefs.getStringList("todos")?.map((title) => Todo(title: title)).toList();

    if (data == null) {
      return [];
    }

    return data;
  }

  @override
  Future<List<Todo>> updateTodos(List<Todo> todos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList("todos", todos.map((todo) => todo.title).toList());

    return todos;
  }
}
