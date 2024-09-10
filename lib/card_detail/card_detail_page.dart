// lib/card_detail/card_detail_page.dart
import 'package:flutter/material.dart';
import 'package:pokemon_tcg_card_collector/colors.dart';

class CardDetailPage extends StatelessWidget {
  final String imageUrl;

  const CardDetailPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: iconColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
