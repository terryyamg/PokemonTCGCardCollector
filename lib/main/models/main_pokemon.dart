// lib/main/models/main_pokemon.dart
class MainPokemon {
  final String name;
  final String url;
  String? imageUrl;

  MainPokemon({required this.name, required this.url, this.imageUrl});

  factory MainPokemon.fromJson(Map<String, dynamic> json) {
    return MainPokemon(
        name: json['name'] as String, url: json['url'] as String, imageUrl: '');
  }

  @override
  String toString() =>
      'MainPokemon(name: $name, url: $url, imageUrl: $imageUrl)';
}
