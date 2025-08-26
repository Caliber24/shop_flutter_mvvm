import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../viewmodel/splash_viewmodel.dart';

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
                  /// PageView
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
                            Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 600),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(
                                        scale: animation, child: child),
                                child: Image.asset(
                                  splashData[index]["image"]!,
                                  key: ValueKey(index),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            SizedBox(height: 30),

                            Text(
                              splashData[index]["title"]!,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.gray,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: 12),

                            Text(
                              splashData[index]["description"]!,
                              style: TextStyle(
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

                  /// Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      splashData.length,
                          (index) => AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 5),
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

                  SizedBox(height: 30),

                  /// Bottom Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        /// Skip Button
                        if (viewModel.currentPage != splashData.length - 1)
                          TextButton(
                            onPressed: () {
                              viewModel.pageController
                                  .jumpToPage(splashData.length - 1);
                            },
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.gray,
                              ),
                            ),
                          )
                        else
                          SizedBox(width: 60),

                        Spacer(),

                        /// Next / Get Started
                        TextButton(
                          onPressed: () {
                            if (viewModel.currentPage ==
                                splashData.length - 1) {
                              // TODO: بعداً به Login یا RootScreen منتقل بشه
                            } else {
                              viewModel.pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Text(
                            viewModel.currentPage == splashData.length - 1
                                ? "Get Started"
                                : "Next",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.yellowPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
