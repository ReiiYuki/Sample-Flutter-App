import 'package:flutter/material.dart';
import 'package:sample_todo/features/counter/presentation/page/counter_page.dart';
import 'package:sample_todo/features/home/presentation/pages/home_page.dart';
import 'package:sample_todo/features/pokemon/presentation/pages/random_pokemon.dart';
import 'package:sample_todo/features/todos/presentation/pages/todo_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/counter': (context) => const CounterPage(title: 'Counter App'),
        '/pokemon': (context) => RandomPokemonPage(),
        '/todo':(context) => TodoListPage(),
      },
    );
  }
}

