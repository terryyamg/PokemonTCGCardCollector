// lib/card/card_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_tcg_card_collector/card_detail/card_detail_page.dart';

import '../colors.dart';
import '../main/AnimatedCard.dart';
import 'bloc/pokemon_bloc.dart';
import 'repositories/pokemon_repository.dart';

class CardPage extends StatelessWidget {
  final String name;

  const CardPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PokemonBloc(PokemonRepository(), name)..add(LoadPokemonCards()),
      child: const PokemonPage(),
    );
  }
}

class PokemonPage extends StatelessWidget {
  const PokemonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: iconColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PokemonBloc>().add(LoadPokemonCards());
            },
          ),
        ],
      ),
      body: BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, state) {
          if (state is PokemonLoading) {
            return const Center(
                child: CircularProgressIndicator(color: iconColor));
          } else if (state is PokemonLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: state.pokemonCards.length,
              itemBuilder: (context, index) {
                final pokemonCard = state.pokemonCards[index];
                return  AnimatedCard(
                  imageUrl: pokemonCard.imageUrl,
                  name: '',
                  index: index,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardDetailPage(imageUrl: pokemonCard.imageUrl),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is PokemonError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(
                child: Text('Press a button to load Pokémon cards'));
          }
        },
      ),
    );
  }
}
