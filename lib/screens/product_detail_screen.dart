// صفحه جزئیات یک محصول خاص در اپلیکیشن.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/product_detail_viewmodel.dart';
import '../viewmodel/cart_viewmodel.dart';
import '../services/api_service.dart';
import '../utils/colors.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final ProductDetailViewModel _vm;
  bool _changed = false;

  @override
  void initState() {
    super.initState();
    _vm = ProductDetailViewModel(ApiService(), widget.productId);
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  void _markChanged() {
    if (!_changed) {
      setState(() => _changed = true);
    }
  }

  Future<bool> _onWillPop() async {

    Navigator.pop(context, _changed);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();

    return ChangeNotifierProvider<ProductDetailViewModel>.value(
      value: _vm,
      child: Consumer<ProductDetailViewModel>(
        builder: (context, vm, _) {
          if (vm.loading) {
            return const Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child:
                CircularProgressIndicator(color: AppColors.yellowPrimary),
              ),
            );
          }

          if (vm.error != null) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: Text(vm.error!, style: const TextStyle(color: Colors.red)),
              ),
            );
          }

          final Product product = vm.product!;
          final int quantity = cart.items
              .firstWhere(
                (e) => e.product.id == product.id,
            orElse: () => CartItem(product: product, quantity: 0),
          )
              .quantity;

          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.background,
                foregroundColor: Colors.white,
                title: Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context, _changed);
                  },
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        product.thumbnail,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.grayBlack,
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image_rounded,
                              color: Colors.white54),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      product.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.yellowPrimary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '€${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      product.description ?? 'No description available',
                      style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 24),

                    Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.yellowPrimary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.yellowPrimary.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: quantity == 0
                            ? GestureDetector(
                          onTap: () {
                            context.read<CartViewModel>().addProduct(product);
                            _markChanged();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            child: Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                            : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                context.read<CartViewModel>().removeOne(product);
                                _markChanged();
                              },
                              icon: const Icon(Icons.remove, color: Colors.white),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '$quantity',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                context.read<CartViewModel>().addProduct(product);
                                _markChanged();
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
