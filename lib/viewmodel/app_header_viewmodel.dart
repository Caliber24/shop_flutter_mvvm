import 'package:flutter/material.dart';

class AppHeaderViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool _searchMode = false;
  bool get searchMode => _searchMode;

  AppHeaderViewModel() {
    focusNode.addListener(() {
      _searchMode = focusNode.hasFocus;
      notifyListeners();
    });
  }

  void clearSearch() {
    searchController.clear();
    focusNode.unfocus();
  }

  void onSearchSubmitted(
      BuildContext context,
      String query,
      Function(String) navigateToResult,
      ) {
    if (query.trim().isEmpty) return;
    navigateToResult(query);
    clearSearch();
  }

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
