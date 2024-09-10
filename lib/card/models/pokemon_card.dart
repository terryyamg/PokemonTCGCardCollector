// lib/card/models/pokemon_card.dart
class PokemonCard {
  final String id;
  final String name;
  final String imageUrl;

  PokemonCard({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
    return PokemonCard(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['images']['large'] as String,
    );
  }

  @override
  String toString() => 'PokemonCard(id: $id, name: $name, imageUrl: $imageUrl)';
}
