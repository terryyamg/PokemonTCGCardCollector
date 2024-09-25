import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_tcg_card_collector/main/bloc/main_bloc.dart';
import 'package:pokemon_tcg_card_collector/main/bloc/main_event.dart';
import 'package:pokemon_tcg_card_collector/main/bloc/main_state.dart';
import 'package:pokemon_tcg_card_collector/main/models/main_pokemon.dart';
import 'package:pokemon_tcg_card_collector/main/repositories/main_repository.dart';

class MockMainRepository extends Mock implements MainRepository {}

void main() {
  late MainBloc mainBloc;
  late MockMainRepository mockMainRepository;

  setUp(() {
    mockMainRepository = MockMainRepository();
    mainBloc = MainBloc(mockMainRepository);
  });

  tearDown(() {
    mainBloc.close();
  });

  group('MainBloc Tests', () {
    final mockMainPokemon = [
      MainPokemon(
        name: 'Pikachu',
        url: '',
        imageUrl: 'https://images.pokemontcg.io/basep/4_hires.png',
      ),
      MainPokemon(
        name: 'Charizard',
        url: '',
        imageUrl: 'https://images.pokemontcg.io/base5/4_hires.png',
      )
    ];

    blocTest<MainBloc, MainState>(
      'emits [MainLoading, MainLoaded] when LoadMainPokemon is added and repository fetches data successfully',
      build: () {
        when(() => mockMainRepository.fetchPokemonList())
            .thenAnswer((_) async => mockMainPokemon);
        return mainBloc;
      },
      act: (bloc) => bloc.add(LoadMainPokemon()),
      expect: () => [
        MainLoading(),
        MainLoaded(mockMainPokemon),
      ],
    );

    blocTest<MainBloc, MainState>(
      'emits [MainLoading, MainError] when LoadMainPokemon is added and repository throws an exception',
      build: () {
        when(() => mockMainRepository.fetchPokemonList())
            .thenThrow(Exception('Failed to fetch data'));
        return mainBloc;
      },
      act: (bloc) => bloc.add(LoadMainPokemon()),
      expect: () => [
        MainLoading(),
        MainError('Failed to fetch Pokémon List.'),
      ],
    );
  });
}
