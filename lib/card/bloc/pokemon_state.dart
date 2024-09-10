part of 'pokemon_bloc.dart';

abstract class PokemonState extends Equatable {
  @override
  List<Object> get props => [];
}

class PokemonInitial extends PokemonState {}

class PokemonLoading extends PokemonState {}

class PokemonLoaded extends PokemonState {
  final List<PokemonCard> pokemonCards;

  PokemonLoaded(this.pokemonCards);

  @override
  List<Object> get props => [pokemonCards];
}

class PokemonError extends PokemonState {
  final String message;

  PokemonError(this.message);

  @override
  List<Object> get props => [message];
}
