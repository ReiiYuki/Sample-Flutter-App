import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sample_todo/feature/pokemon/data/network/pokemon_api_data_provider.dart';
import 'package:sample_todo/feature/pokemon/data/repository/pokemon_repository.dart';
import 'package:sample_todo/feature/pokemon/domain/pokemon.dart';
import 'package:sample_todo/feature/pokemon/presentation/widget/random_pokemon_button.dart';

class RandomPokemonPage extends StatefulWidget {
  final PokemonRepository _pokemonRepository = PokemonRepository(dataProvider: PokemonAPIDataProvider(client: Client()));

  RandomPokemonPage({super.key});

  @override
  State<RandomPokemonPage> createState() => _RandomPokemonState();
}

class _RandomPokemonState extends State<RandomPokemonPage> {
  Future<Pokemon>? randomPokemon;

  @override
  void initState() {
    super.initState();
    randomPokemon = widget._pokemonRepository.getPokemon(Random().nextInt(100));
  }

  _onRandom(int number) {
    setState(() {
      randomPokemon = widget._pokemonRepository.getPokemon(number);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Pokemon'),
      ),
      body: Center(
        child: FutureBuilder<Pokemon>(future: randomPokemon, builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.name);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        }),
      ),
      floatingActionButton: RandomPokemonButton(onRandom: _onRandom),
    );
  }
}