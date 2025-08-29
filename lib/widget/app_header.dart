import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/app_header_viewmodel.dart';
import '../utils/colors.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final Function(String) onSearchNavigate;

  const AppHeader({
    super.key,
    required this.username,
    required this.onSearchNavigate,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppHeaderViewModel>();

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: AppColors.background.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // 🔹 Username (Fade & Slide out when searching)
              AnimatedSlide(
                offset: viewModel.searchMode ? const Offset(-0.2,0) : Offset.zero,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  opacity: viewModel.searchMode ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    "Welcome، $username",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // 🔹 Animated Search Bar
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.elasticOut,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: viewModel.searchMode
                          ? Colors.white.withOpacity(0.3)
                          : Colors.transparent,
                      width: 1,
                    ),
                    boxShadow: viewModel.searchMode
                        ? [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                              spreadRadius: 2,
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: TextField(
                    controller: viewModel.searchController,
                    focusNode: viewModel.focusNode,
                    onSubmitted: (query) =>
                        viewModel.onSearchSubmitted(context, query, onSearchNavigate),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      hintText: 'Search...',
                      hintStyle: const TextStyle(
                        color: Colors.white60,
                        fontSize: 15,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: viewModel.searchMode
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.white70),
                              onPressed: viewModel.clearSearch,
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // 🔹 Logo (Ripple Effect & Fade)
              AnimatedSlide(
                offset: viewModel.searchMode ? const Offset(0.2,0) : Offset.zero,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  opacity: viewModel.searchMode ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {
                      // مثلا navigate به home
                    },
                    splashColor: Colors.white24,
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
