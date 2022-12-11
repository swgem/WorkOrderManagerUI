import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/shared/authentication_manager.dart';
import 'package:work_order_manager_ui/ui/pages/routes.dart';

class InitialPageUi extends StatefulWidget {
  static const String routeName = "/initialPage";
  const InitialPageUi({super.key});

  @override
  State<InitialPageUi> createState() => _InitialPageUiState();
}

class _InitialPageUiState extends State<InitialPageUi> {
  @override
  void initState() {
    super.initState();

    _checkTokenAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Future _checkTokenAndNavigate() async {
    if (await _isTokenValid()) {
      Navigator.pushReplacementNamed(context, Routes.home);
    } else {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }

  Future<bool> _isTokenValid() async {
    try {
      var expirationDate = await AuthenticationManager.getExpirationDate();
      var expirationDateTime = DateTime.parse(expirationDate).toLocal();
      if (expirationDateTime.compareTo(DateTime.now()) > 0) {
        return true;
      } else {
        AuthenticationManager.clearAuth();
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
