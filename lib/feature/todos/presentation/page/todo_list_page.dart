import 'package:flutter/material.dart';
import 'package:sample_todo/feature/todos/data/persistence/todo_list_persistence_data_provider.dart';
import 'package:sample_todo/feature/todos/data/repository/todo_list_repository.dart';
import 'package:sample_todo/feature/todos/domain/todo.dart';

class TodoListPage extends StatefulWidget {
  final _todoListRepository = TodoListRepository(dataProvider: TodoListPersistenceDataProvider());

  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListState();
}
class _TodoListState extends State<TodoListPage> {
  Future<List<Todo>>? todoList;

  @override
  void initState() {
    super.initState();

    todoList = widget._todoListRepository.getTodos();
  }

  _addTodo(String text) async {
    var todoListData = await todoList;

    setState(() {
      todoList = widget._todoListRepository.updateTodos([...todoListData!, Todo(title: text)]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Column(
        children: <Widget>[
          TextButton(
            onPressed: () async {
              _addTodo('Test');
            },
            child: const Text("Add TODO"),
          ),
          FutureBuilder<List<Todo>>(
            future: todoList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index].title),
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
