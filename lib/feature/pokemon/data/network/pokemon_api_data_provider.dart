import 'dart:convert';

import 'package:sample_todo/feature/pokemon/data/repository/pokemon_repository.dart';
import 'package:sample_todo/feature/pokemon/domain/pokemon.dart';
import 'package:http/http.dart' as http;

class PokemonAPIDataProvider extends PokemonDataProvider {
  @override
  Future<Pokemon> getPokemon(int id) async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'));

    if (response.statusCode == 200) {
      return Pokemon.fromJSON(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Pokemon');
    }
  }
}
