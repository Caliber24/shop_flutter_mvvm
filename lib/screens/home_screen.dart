import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../services/api_service.dart';
import '../utils/colors.dart';
import '../widget/product_card.dart';
import '../widget/section_header.dart';
import '../widget/category_pill.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider(ApiService())..loadPopular(),
      child: Consumer<ProductProvider>(
        builder: (_, vm, __) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------- Hero Banner (Carousel)
                SizedBox(
                  height: 180,
                  child: PageView(
                    controller: PageController(viewportFraction: 0.9),
                    children: const [
                      _PromoCard(
                        title: 'Payday Deals!',
                        subtitle: 'Up to 80% OFF • May 25–30',
                        c1: Color(0xFFFFC371),
                        c2: Color(0xFFFF5F6D),
                        image:
                        'https://images.unsplash.com/photo-1585386959984-a41552231658?w=1200&q=80',
                      ),
                      _PromoCard(
                        title: 'Summer Essentials',
                        subtitle: 'Fresh arrivals for you',
                        c1: Color(0xFF6EE7F9),
                        c2: Color(0xFF736EFE),
                        image:
                        'https://images.unsplash.com/photo-1541643600914-78b084683601?w=1200&q=80',
                      ),
                    ],
                  ),
                ),

                // -------- Categories row
                const SectionHeader('Product Categories', actionText: 'See all'),
                SizedBox(
                  height: 110,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: const [
                      CategoryPill(icon: Icons.spa_rounded, label: 'Fragrance'),
                      CategoryPill(icon: Icons.local_florist_rounded, label: 'Bodycare'),
                      CategoryPill(icon: Icons.brush_rounded, label: 'Haircare'),
                      CategoryPill(icon: Icons.face_retouching_natural_rounded, label: 'Facial'),
                      CategoryPill(icon: Icons.bubble_chart_rounded, label: 'Serum'),
                      CategoryPill(icon: Icons.waves_rounded, label: 'Bath'),
                    ],
                  ),
                ),

                // -------- Popular Products (Grid 2-column)
                const SectionHeader('Popular Products', actionText: 'View all'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: vm.loading
                      ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.yellowPrimary),
                    ),
                  )
                      : vm.error != null
                      ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(vm.error!,
                          style: const TextStyle(color: Colors.red)),
                    ),
                  )
                      : _ProductsGrid(products: vm.popular),
                ),

                // -------- Promotion strip
                const SectionHeader('Promotion'),
                const _WidePromo(),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// ------- small promo card for carousel
class _PromoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final Color c1, c2;
  const _PromoCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.c1,
    required this.c2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: [c1, c2], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            right: 6,
            child: Align(
              alignment: Alignment.bottomRight,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16)),
                child: Image.network(image, width: 180, height: 140, fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Shop Now', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------- products grid using your ProductCard
class _ProductsGrid extends StatelessWidget {
  final List products;
  const _ProductsGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text('No products yet', style: TextStyle(color: AppColors.gray))),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,            // 2 ستونه
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.78,       // نسبت کارت‌ها
      ),
      itemCount: products.length.clamp(0, 8), // اولین‌ها برای نمای اولیه
      itemBuilder: (_, i) => ProductCard(product: products[i]),
    );
  }
}

/// ------- bottom promotion banner
class _WidePromo extends StatelessWidget {
  const _WidePromo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'New scent, new you.\nIntroducing Chance Eau De Spray\n40% OFF!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Icon(Icons.local_offer_rounded, color: Colors.white, size: 36),
            ],
          ),
        ),
      ),
    );
  }
}
