
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_tcg_card_collector/card/bloc/pokemon_bloc.dart';
import 'package:pokemon_tcg_card_collector/card/models/pokemon_card.dart';
import 'package:pokemon_tcg_card_collector/card/repositories/pokemon_repository.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  late PokemonBloc pokemonBloc;
  late MockPokemonRepository mockPokemonRepository;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    pokemonBloc = PokemonBloc(mockPokemonRepository, '');
  });

  tearDown(() {
    pokemonBloc.close();
  });

  group('PokemonBloc Tests', () {
    final mockPokemonCards = [
      PokemonCard(
        id: 'xy7-54',
        name: 'Pikachu',
        imageUrl: 'https://images.pokemontcg.io/basep/4_hires.png',
      ),
      PokemonCard(
        id: 'sm115-5',
        name: 'Charizard',
        imageUrl: 'https://images.pokemontcg.io/base5/4_hires.png',
      )
    ];

    blocTest<PokemonBloc, PokemonState>(
      'emits [PokemonLoading, PokemonLoaded] when LoadPokemonCards is added and repository fetches data successfully',
      build: () {
        when(() => mockPokemonRepository.fetchPokemonCards('Pikachu'))
            .thenAnswer((_) async => mockPokemonCards);
        return pokemonBloc;
      },
      act: (bloc) => bloc.add(LoadPokemonCards()),
      expect: () => [
        PokemonLoading(),
        PokemonLoaded(mockPokemonCards),
      ],
    );

    blocTest<PokemonBloc, PokemonState>(
      'emits [PokemonLoading, PokemonError] when LoadPokemonCards is added and repository throws an exception',
      build: () {
        when(() => mockPokemonRepository.fetchPokemonCards('Pikachu'))
            .thenThrow(Exception('Failed to fetch data'));
        return pokemonBloc;
      },
      act: (bloc) => bloc.add(LoadPokemonCards()),
      expect: () => [
        PokemonLoading(),
        PokemonError('Failed to fetch Pokémon cards.'),
      ],
    );
  });
}
