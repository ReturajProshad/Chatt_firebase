import 'dart:ffi';

import 'package:flutter/material.dart';

class profilePage extends StatelessWidget {
  late double _height;
  late double _width;
  profilePage(this._height, this._width);

  @override
  Widget build(BuildContext context) {
    return Container(child: _profilePageUi());
  }

  Widget _profilePageUi() {
    return Align(
      child: SizedBox(
        height: _height * .60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _userProfileImage(
                "https://media.istockphoto.com/id/1457441464/photo/luxury-private-jet.jpg?s=1024x1024&w=is&k=20&c=4fiFgC-LJWWiIVdqc1JII4rvQsY3P_2xPCWKHFFX62I="),
            _userName("Returaj"),
            _userEmail("Returaj@gmail.com"),
            _logoutButton()
          ],
        ),
      ),
    );
  }

  Widget _userProfileImage(_imgUrl) {
    return CircleAvatar(
      radius: _height * .20,
      backgroundColor: Colors.red,
      backgroundImage: NetworkImage(_imgUrl),
    );
  }

  Widget _userName(String _uName) {
    return Container(
      height: _height * .05,
      width: _width,
      child: Text(
        _uName,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25),
      ),
    );
  }

  Widget _userEmail(String _uEmail) {
    return Container(
      height: _height * .05,
      width: _width,
      child: Text(
        _uEmail,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _logoutButton() {
    return Container(
      height: _height * 0.06,
      width: _width * .80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        onPressed: () {},
        child: const Text(
          "LOGOUT",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
