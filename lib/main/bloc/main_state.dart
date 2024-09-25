import 'package:equatable/equatable.dart';

import '../models/main_pokemon.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class MainInitial extends MainState {}

class MainLoading extends MainState {}

class MainLoaded extends MainState {
  final List<MainPokemon> mainPokemon;

  const MainLoaded(this.mainPokemon);

  @override
  List<Object> get props => [mainPokemon];
}

class MainError extends MainState {
  final String message;

  const MainError(this.message);

  @override
  List<Object> get props => [message];
}
