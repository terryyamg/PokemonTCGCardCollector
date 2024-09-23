import 'package:flutter/material.dart';

import '../colors.dart';

class AnimatedCard extends StatefulWidget {
  final String imageUrl;
  final String name;
  final int index;
  final VoidCallback onTap;

  const AnimatedCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.index,
    required this.onTap,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _imageLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _controller.addListener(() {
      if (_controller.isCompleted && !_imageLoaded) {
        _imageLoaded = true;
        widget.onTap();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTap() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.rotationY(_animation.value * 3.14 * 2),
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 0.0, right: 20.0, bottom: 0.0),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        if (!_imageLoaded) {
                          _imageLoaded = true;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _onItemTap();
                          });
                        }
                        return child;
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(color: iconColor),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),
          widget.name.isEmpty
              ? const SizedBox(height: 0.0)
              : const SizedBox(height: 8),
          widget.name.isEmpty
              ? const SizedBox(height: 0.0)
              : Text(
                  widget.name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
        ],
      ),
    );
  }
}
