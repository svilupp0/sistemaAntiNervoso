import 'package:flutter/material.dart';
import 'dart:math';
import 'constants.dart';

class FloatingEmojis extends StatefulWidget {
  final List<String> emojis;
  final int count;

  const FloatingEmojis({
    super.key, 
    required this.emojis, 
    this.count = AppConstants.numeroEmojiDefault
  });

  @override
  State<FloatingEmojis> createState() => _FloatingEmojisState();
}

class _FloatingEmojisState extends State<FloatingEmojis>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Offset> _positions;
  late List<double> _speeds;
  late List<String> _selectedEmojis;
  late List<double> _sizes;
  final Random _random = Random(); // Cached random instance

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: AppConstants.durataAnimazioneSecondi),
    )..repeat();
    
    // Pre-calcola tutte le proprietà per evitare calcoli nel build
    _positions = List.generate(
      widget.count,
      (index) => Offset(_random.nextDouble(), _random.nextDouble()),
    );
    
    _speeds = List.generate(
      widget.count,
      (index) => AppConstants.velocitaAnimazioneMin + 
                 _random.nextDouble() * 
                 (AppConstants.velocitaAnimazioneMax - AppConstants.velocitaAnimazioneMin),
    );
    
    // Pre-seleziona emoji e dimensioni per evitare random nel build
    _selectedEmojis = List.generate(
      widget.count,
      (index) => widget.emojis[_random.nextInt(widget.emojis.length)],
    );
    
    _sizes = List.generate(
      widget.count,
      (index) => 30.0 + _random.nextInt(20).toDouble(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: List.generate(widget.count, (index) {
            // Calcola nuova posizione verticale (loop continuo)
            final double y = (_positions[index].dy +
                _speeds[index] * _controller.value * 1000) % 1.0;
            final double x = _positions[index].dx;
            
            return Positioned(
              left: x * screenSize.width,
              top: y * screenSize.height,
              child: Text(
                _selectedEmojis[index], // Usa emoji pre-selezionata
                style: TextStyle(fontSize: _sizes[index]), // Usa dimensione pre-calcolata
              ),
            );
          }),
        );
      },
    );
  }
}
