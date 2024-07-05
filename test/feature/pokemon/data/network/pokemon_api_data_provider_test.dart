import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sample_todo/feature/pokemon/data/network/pokemon_api_data_provider.dart';
import 'package:sample_todo/feature/pokemon/domain/pokemon.dart';
import 'package:test/test.dart';

import 'pokemon_api_data_provider_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  group('getPokemon()', () {
    test(
        'It should perform get pokemon from pokemon api with input id then return response body decoded as pokemon',
        () async {
      final client = MockClient();
      when(client.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/1')))
          .thenAnswer(
              (_) async => Response('{"id": 1, "name": "bulbasaur"}', 200));

      final pokemonApiDataProvider = PokemonAPIDataProvider(client: client);

      final pokemon = await pokemonApiDataProvider.getPokemon(1);

      expect(pokemon, isA<Pokemon>());
      expect(pokemon.id, 1);
      expect(pokemon.name, 'bulbasaur');

      verify(client.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/1'))).called(1);
    });

    test('It should perform get pokemon from pokemon api with input id then throw exception if response status is not 200', () async {
      final client = MockClient();
      when(client.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/1')))
          .thenAnswer((_) async => Response('Not Found', 404));

      final pokemonApiDataProvider = PokemonAPIDataProvider(client: client);

      expect(() async => await pokemonApiDataProvider.getPokemon(1), throwsException);

      verify(client.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/1'))).called(1);
    });
  });
}
