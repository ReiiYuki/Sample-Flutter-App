import 'package:sample_todo/feature/pokemon/domain/pokemon.dart';

abstract class PokemonDataProvider {
  Future<Pokemon> getPokemon(int id);
}

class PokemonRepository {
  final PokemonDataProvider dataProvider;
  Pokemon? pokemon;

  PokemonRepository({ required this.dataProvider });

  Future<Pokemon> getPokemon(int id) async {
    pokemon = await dataProvider.getPokemon(id);

    return pokemon!;
  }
}
