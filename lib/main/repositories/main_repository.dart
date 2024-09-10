// lib/main/repositories/main_repository.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/main_pokemon.dart';

class MainRepository {
  final String baseUrl = 'https://pokeapi.co/api/v2/pokemon?limit=2000';
  final String imageUrl =
      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/number.png";

  Future<List<MainPokemon>> fetchPokemonList() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> mainPokemonJson = data['results'];
      List<MainPokemon> list =
          mainPokemonJson.map((json) => MainPokemon.fromJson(json)).toList();
      for (var element in list) {
        element.imageUrl = _getImageUrl(element.url);
      }
      return list;
    } else {
      throw Exception('Failed to load Pokémon list');
    }
  }

  String _getImageUrl(String url) {
    final uri = Uri.parse(url);
    final lastSegment =
        uri.pathSegments.lastWhere((segment) => segment.isNotEmpty);
    return imageUrl.replaceAll("number", lastSegment);
  }
}
