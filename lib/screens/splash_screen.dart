// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../providers/app_state_provider.dart';
import 'login_screen.dart';

class SplashViewModel extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  final PageController pageController = PageController();

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }
}

class SplashScreen extends StatelessWidget {
  final List<Map<String, String>> splashData = [
    {
      "title": "Welcome to Shop",
      "description": "Discover amazing products and exclusive deals every day.",
      "image": "assets/images/splash/1.png"
    },
    {
      "title": "New Collections Weekly",
      "description": "Explore fresh arrivals and trending items every week.",
      "image": "assets/images/splash/2.png"
    },
    {
      "title": "Fast & Secure Checkout",
      "description": "Enjoy quick delivery and safe payment methods.",
      "image": "assets/images/splash/3.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashViewModel(),
      child: Consumer<SplashViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: viewModel.pageController,
                      onPageChanged: (index) => viewModel.setPage(index),
                      itemCount: splashData.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 600),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(scale: animation, child: child),
                                child: Image.asset(
                                  splashData[index]["image"]!,
                                  key: ValueKey(index),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              splashData[index]["title"]!,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.gray,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              splashData[index]["description"]!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.iconColor,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      splashData.length,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        height: 8,
                        width: viewModel.currentPage == index ? 28 : 8,
                        decoration: BoxDecoration(
                          color: viewModel.currentPage == index
                              ? AppColors.yellowPrimary
                              : AppColors.grayBlack,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        if (viewModel.currentPage != splashData.length - 1)
                          TextButton(
                            onPressed: () {
                              viewModel.pageController.jumpToPage(splashData.length - 1);
                            },
                            child: const Text(
                              "Skip",
                              style: TextStyle(fontSize: 16, color: AppColors.gray),
                            ),
                          )
                        else
                          const SizedBox(width: 60),
                        const Spacer(),
                        TextButton(
                          onPressed: () async {
                            if (viewModel.currentPage == splashData.length - 1) {
                              // فقط وقتی به آخر رسیدیم: first_time=false و برو لاگین
                              await context.read<AppStateProvider>().setFirstTimeDone();
                              if (!context.mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => LoginScreen()),
                              );
                            } else {
                              viewModel.pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Text(
                            viewModel.currentPage == splashData.length - 1 ? "Get Started" : "Next",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.yellowPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
