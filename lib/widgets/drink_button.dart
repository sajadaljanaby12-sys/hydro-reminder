import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// زر كبير بارز لتسجيل كوب ماء جديد مع رسوم متحركة خفيفة عند الضغط
class DrinkButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;

  const DrinkButton({super.key, required this.onPressed, required this.label});

  @override
  State<DrinkButton> createState() => _DrinkButtonState();
}

class _DrinkButtonState extends State<DrinkButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
    lowerBound: 0.0,
    upperBound: 0.08,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1 - _controller.value;
        return Transform.scale(scale: scale, child: child);
      },
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.lightBlue, AppTheme.primaryBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.water_drop_rounded, color: Colors.white, size: 26),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
