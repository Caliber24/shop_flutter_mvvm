import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  final PageController pageController = PageController();

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }
}
