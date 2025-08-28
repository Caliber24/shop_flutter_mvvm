// lib/widget/product_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/colors.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;

  const ProductCard({
    super.key,
    required this.product,
    this.margin,
    this.onTap,
    this.onAdd,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: _pressed ? 0.98 : (_hover ? 1.02 : 1.0),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: Container(
            margin: widget.margin ?? EdgeInsets.zero,
            decoration: BoxDecoration(
              color: AppColors.itemBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.grayBlack),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_hover ? 0.35 : 0.25),
                  blurRadius: _hover ? 16 : 8,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Image area (stacked overlays)
                  Flexible(
                    flex: 6,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // تصویر
                        Image.network(
                          p.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.grayBlack,
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image_rounded, color: Colors.white54),
                          ),
                        ),
                        // گرادیان پایین برای خوانایی
                        Positioned.fill(
                          child: IgnorePointer(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.15),
                                    Colors.black.withOpacity(0.30),
                                  ],
                                  stops: const [0.55, 0.80, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // چیپ امتیاز
                        Positioned(
                          top: 8,
                          left: 8,
                          child: _FrostedChip(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  p.rating.toStringAsFixed(1),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ===== Info area
                  Flexible(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // عنوان
                          Text(
                            p.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),

                          // قیمت + دکمه Add
                          Row(
                            children: [
                              _PricePill(price: p.price),
                              const Spacer(),
                              _AddMiniButton(onPressed: widget.onAdd),
                            ],
                          ),
                        ],
                      ),
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

/// شیشه‌ای کوچک برای امتیاز/برچسب‌ها
class _FrostedChip extends StatelessWidget {
  final Widget child;
  const _FrostedChip({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.20), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// چیپ قیمت برجسته
class _PricePill extends StatelessWidget {
  final double price;
  const _PricePill({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.yellowPrimary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.yellowPrimary.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        '€${price.toStringAsFixed(2)}',
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
      ),
    );
  }
}

/// دکمه Add کوچک
class _AddMiniButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const _AddMiniButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: const SizedBox(
          height: 36,
          width: 36,
          child: Icon(Icons.add_rounded, color: Colors.white),
        ),
      ),
    );
  }
}
