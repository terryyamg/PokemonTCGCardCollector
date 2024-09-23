// lib/card/bloc/pokemon_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';
import '../models/main_pokemon.dart';
import '../repositories/main_repository.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final MainRepository repository;

  MainBloc(this.repository) : super(MainInitial()) {
    on<LoadMainPokemon>((event, emit) async {
      emit(MainLoading());
      try {
        final pokemonCards = await repository.fetchPokemonList();
        emit(MainLoaded(pokemonCards));
      } catch (e) {
        logger.e("MainBloc: $e");
        emit(MainError('Failed to fetch Pokémon List.'));
      }
    });
  }
}
