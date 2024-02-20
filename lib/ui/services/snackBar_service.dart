import 'package:flutter/material.dart';

class snackBarService {
  static snackBarService instance = snackBarService();

  //snackBarService() {}
  late BuildContext _thiscontext;

  set thisContext(BuildContext _context) {
    _thiscontext = _context;
  }

  void LoginError(String _message) {
    ScaffoldMessenger.of(_thiscontext).showSnackBar(
      SnackBar(
        content: Text(
          _message,
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void LoginSuccess(String _message) {
    ScaffoldMessenger.of(_thiscontext).showSnackBar(
      SnackBar(
        content: Text(
          _message,
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
