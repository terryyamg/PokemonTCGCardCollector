// lib/card/repositories/pokemon_repository.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon_card.dart';

class PokemonRepository {
  final String baseUrl = 'https://api.pokemontcg.io/v2/cards?q=name:saymyname';

  Future<List<PokemonCard>> fetchPokemonCards(String name) async {
    final response =
        await http.get(Uri.parse(baseUrl.replaceAll('saymyname', name)));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> cardsJson = data['data'];
      return cardsJson.map((json) => PokemonCard.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Pokémon cards');
    }
  }
}
