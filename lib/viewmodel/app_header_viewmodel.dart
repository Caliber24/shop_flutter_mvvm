// این کلاس وظیفه مدیریت منطق بخش جستجو در هدر اپلیکیشن را دارد.
import 'package:flutter/material.dart';
import '../screens/search_results.dart';

class AppHeaderViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool _searchMode = false;
  bool get searchMode => _searchMode;

  set searchMode(bool value) {
    _searchMode = value;
    notifyListeners();
  }

  AppHeaderViewModel() {
    focusNode.addListener(() {
      _searchMode = focusNode.hasFocus;
      notifyListeners();
    });
  }

  void clearSearch() {
    searchController.clear();
    focusNode.unfocus();
    searchMode = false;
  }

  void onSearchSubmitted(
      BuildContext context,
      String query,
      Function(String) navigateToResult,
      ) {
    if (query.trim().isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultsScreen(query: query),
      ),
    );

    clearSearch();
  }

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
