part of 'main_bloc.dart';

abstract class MainState extends Equatable {
  @override
  List<Object> get props => [];
}

class MainInitial extends MainState {}

class MainLoading extends MainState {}

class MainLoaded extends MainState {
  final List<MainPokemon> mainPokemon;

  MainLoaded(this.mainPokemon);

  @override
  List<Object> get props => [mainPokemon];
}

class MainError extends MainState {
  final String message;

  MainError(this.message);

  @override
  List<Object> get props => [message];
}
