import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sample_todo/feature/pokemon/data/repository/pokemon_repository.dart';
import 'package:sample_todo/feature/pokemon/domain/pokemon.dart';
import 'package:test/test.dart';

import 'pokemon_repository_test.mocks.dart';

@GenerateMocks([PokemonDataProvider])
void main() {
  group('getPokemon', () {
    
    test('It should perform get pokemon from data provider with input id and return value', () async {
      final dataProvider = MockPokemonDataProvider();
      
      final mockPokemon = Pokemon(id: 1, name: 'test');

      when(dataProvider.getPokemon(1)).thenAnswer((_) async =>  mockPokemon);

      final repository = PokemonRepository(dataProvider: dataProvider);

      final pokemon = await repository.getPokemon(1);

      expect(pokemon, mockPokemon);
      verify(dataProvider.getPokemon(1)).called(1);
    });
  });
}
