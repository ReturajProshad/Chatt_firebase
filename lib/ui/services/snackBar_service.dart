import 'package:flutter/material.dart';

class snackBarService {
  static snackBarService instance = snackBarService();

  //snackBarService() {}
  late BuildContext _thiscontext;

  set thisContext(BuildContext _context) {
    _thiscontext = _context;
  }

  void LoginStatusMessage(String _message, Color ColorOfS) {
    ScaffoldMessenger.of(_thiscontext).showSnackBar(
      SnackBar(
        content: Text(
          _message,
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        backgroundColor: ColorOfS,
      ),
    );
  }
}
