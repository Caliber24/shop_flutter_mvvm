// ویجتی تعاملی برای نمایش محصول در لیست یا گرید.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../viewmodel/cart_viewmodel.dart';
import '../utils/colors.dart';
import '../models/cart_item.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.margin,
    this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();
    final p = widget.product;

    final quantity = cart.items
        .firstWhere(
          (e) => e.product.id == p.id,
      orElse: () => CartItem(product: p, quantity: 0),
    )
        .quantity;

    final width = MediaQuery.of(context).size.width;

    final pillWidth = (width * 0.15).clamp(60, 120) as double;
    final pillHeight = (width * 0.08).clamp(30, 50) as double;
    final btnSize = (width * 0.08).clamp(30, 50) as double;
    final fontSize = (width * 0.03).clamp(10.0, 16.0).toDouble();

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: _pressed ? 0.98 : (_hover ? 1.02 : 1.0),
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
                Flexible(
                  flex: 6,
                  child: GestureDetector(
                    onTap: widget.onTap,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          p.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.grayBlack,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.broken_image_rounded,
                              color: Colors.white54,
                            ),
                          ),
                        ),
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
                        Positioned(
                          top: 8,
                          left: 8,
                          child: _FrostedChip(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  p.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 8),
                            child: Text(
                              p.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                                fontSize: fontSize,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            _PricePill(price: p.price, width: pillWidth - 15.5, height: pillHeight, fontSize: fontSize-2.2),
                            const Spacer(),
                            if (quantity > 0)
                              Row(
                                children: [
                                  _QuantityButton(icon: Icons.remove, onTap: () => cart.removeOne(p), size: btnSize),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                    padding: EdgeInsets.symmetric(horizontal: btnSize * 0.4, vertical: btnSize * 0.2),
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '$quantity',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize),
                                    ),
                                  ),
                                  _QuantityButton(icon: Icons.add, onTap: () => cart.addProduct(p), size: btnSize),
                                ],
                              )
                            else
                              GestureDetector(
                                onTap: () => cart.addProduct(p),
                                behavior: HitTestBehavior.opaque,
                                child: _AddMiniButton(size: btnSize),
                              ),
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
    );
  }
}


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

class _PricePill extends StatelessWidget {
  final double price;
  final double width;
  final double height;
  final double fontSize;

  const _PricePill({required this.price, required this.width, required this.height, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
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
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: fontSize),
      ),
    );
  }
}

class _AddMiniButton extends StatelessWidget {
  final double size;
  const _AddMiniButton({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: size,
        width: size,
        child: Icon(Icons.add_rounded, color: Colors.white, size: size * 0.5),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const _QuantityButton({required this.icon, required this.onTap, required this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.white, size: size * 0.5),
      ),
    );
  }
}
