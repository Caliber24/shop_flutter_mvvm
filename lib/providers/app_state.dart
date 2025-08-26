import 'package:flutter/material.dart';

enum AppStatus {
  firstTime,   // بار اول وارد شده
  loggedOut,   // لاگ اوت
  loggedIn,    // لاگین شده
  loading,     // در حال لود اطلاعات بعد از لاگین
}

class AppStateProvider extends ChangeNotifier {
  AppStatus _status = AppStatus.firstTime;

  AppStatus get status => _status;

  void setStatus(AppStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }
}
