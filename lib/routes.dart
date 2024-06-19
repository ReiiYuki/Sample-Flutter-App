import 'package:sample_todo/features/counter/routes.dart';
import 'package:sample_todo/features/home/routes.dart';
import 'package:sample_todo/features/pokemon/routes.dart';
import 'package:sample_todo/features/todos/routes.dart';

var appRoutes = {
  ...homeRoutes,
  ...counterRoutes,
  ...pokemonRoutes,
  ...todoRoutes,
};
