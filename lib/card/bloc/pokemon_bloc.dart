// lib/card/bloc/pokemon_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/pokemon_card.dart';
import '../repositories/pokemon_repository.dart';

part 'pokemon_event.dart';

part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonRepository repository;
  final String name;

  PokemonBloc(this.repository, this.name) : super(PokemonInitial()) {
    on<LoadPokemonCards>((event, emit) async {
      emit(PokemonLoading());
      try {
        final pokemonCards = await repository.fetchPokemonCards(name);
        emit(PokemonLoaded(pokemonCards));
      } catch (e) {
        emit(PokemonError('Failed to fetch Pokémon cards.'));
      }
    });
  }
}
