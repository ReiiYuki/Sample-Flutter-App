import 'package:sample_todo/feature/counter/routes.dart';
import 'package:sample_todo/feature/home/routes.dart';
import 'package:sample_todo/feature/overlay/routes.dart';
import 'package:sample_todo/feature/pokemon/routes.dart';
import 'package:sample_todo/feature/todos/routes.dart';

var appRoutes = {
  ...homeRoutes,
  ...counterRoutes,
  ...pokemonRoutes,
  ...todoRoutes,
  ...overlayRoutes,
};
