// یک ویجت تعاملی برای نمایش دسته‌بندی‌ها به صورت "پیل" (Pill) با آیکون و متن.

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/category_icons.dart';

class CategoryPill extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const CategoryPill({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  State<CategoryPill> createState() => _CategoryPillState();
}

class _CategoryPillState extends State<CategoryPill> {
  bool _hovering = false;
  bool _pressed = false;
  late final LinearGradient _gradient;

  static const List<LinearGradient> _presets = [
    LinearGradient(
      colors: [Color(0xFFFFC371), Color(0xFFFF5F6D)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF6EE7F9), Color(0xFF736EFE)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF84FAB0), Color(0xFF8FD3F4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFAD0C4), Color(0xFFFFD1FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFBD3E9), Color(0xFFBB377D)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF30CFD0), Color(0xFF330867)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFFE259), Color(0xFFFFA751)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFEE9CA7), Color(0xFFFFDDE1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF2AF598), Color(0xFF009EFD)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF2A2F33), Color(0xFF1B1E21)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];

  @override
  void initState() {
    super.initState();

    final seed = widget.label.hashCode ^ widget.icon.codePoint;
    final rnd = Random(seed);
    _gradient = _presets[rnd.nextInt(_presets.length)];
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        scale: _pressed ? 0.96 : (_hovering ? 1.02 : 1.0),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(18),
            onTapDown: (_) => setState(() => _pressed = true),
            onTapCancel: () => setState(() => _pressed = false),
            onTapUp: (_) => setState(() => _pressed = false),
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: _gradient,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.30),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                  if (_hovering || _pressed)
                    BoxShadow(
                      color: AppColors.yellowPrimary.withOpacity(0.35),
                      blurRadius: 18,
                      spreadRadius: 1,
                      offset: const Offset(0, 6),
                    ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(_hovering ? 0.10 : 0.06),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.6],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Container(
                              width: 46,
                              height: 46,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.10),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.18),
                                  width: 1,
                                ),
                                boxShadow: [
                                  if (_hovering || _pressed)
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.12),
                                      blurRadius: 8,
                                    ),
                                ],
                              ),
                              child: Icon(
                                widget.icon,
                                size: 26,
                                color: _hovering
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.92),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Flexible(
                          child: Text(
                            widget.label,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: _hovering
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              height: 1.15,
                              letterSpacing: 0.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
