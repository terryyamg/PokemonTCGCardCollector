// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:pokemon_tcg_card_collector/main/repositories/main_repository.dart';

import '../card/card_page.dart';
import '../colors.dart';
import 'animated_card.dart';
import 'bloc/main_bloc.dart';

var logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    levelColors: {
      Level.trace: AnsiColor.fg(AnsiColor.grey(0.5)),
      Level.debug: const AnsiColor.fg(35),
      Level.info: const AnsiColor.fg(32),
      Level.warning: const AnsiColor.fg(220),
      Level.error: const AnsiColor.fg(196),
      Level.fatal: const AnsiColor.fg(199),
    },
    levelEmojis: {
      Level.trace: '',
      Level.debug: '🟢',
      Level.info: '🔵',
      Level.warning: '🟡',
      Level.error: '🔴',
      Level.fatal: '🟣',
    }
  ),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon TCG',
      theme: ThemeData(
        primaryColor: appBarColor,
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: BlocProvider(
        create: (context) => MainBloc(MainRepository())..add(LoadMainPokemon()),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pokémon TCG',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: iconColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MainBloc>().add(LoadMainPokemon());
            },
          ),
        ],
      ),
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state is MainLoading) {
            return const Center(
                child: CircularProgressIndicator(color: iconColor));
          } else if (state is MainLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: state.mainPokemon.length,
              itemBuilder: (context, index) {
                final pokemonList = state.mainPokemon[index];

                return AnimatedCard(
                  imageUrl: pokemonList.imageUrl ?? '',
                  name: pokemonList.name,
                  index: index,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardPage(name: pokemonList.name),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is MainError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: textColor)));
          } else {
            return const Center(
                child: Text('Press a button to load Pokémon cards',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: textColor)));
          }
        },
      ),
    );
  }
}
