import 'package:chatt/ui/services/DB_service.dart';
import 'package:chatt/ui/services/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class profilePage extends StatelessWidget {
  late final double _height;
  late final double _width;
  profilePage(this._height, this._width);
  late AuthProvider _auth;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: AuthProvider.instance,
        child: Container(child: _profilePageUi()));
  }

  Widget _profilePageUi() {
    return Builder(
      builder: (_context) {
        _auth = Provider.of<AuthProvider>(_context);
        return StreamBuilder(
            stream: _auth.user != null
                ? dbService.instance.getuserdata(_auth.user!.uid)
                : null,
            builder: (_context, _snapshot) {
              var _userData = _snapshot.data;
              if (_snapshot.hasError) {
                navigationService.instance.navigatorRepalacement("login");
              }
              return _snapshot.hasData
                  ? Align(
                      child: SizedBox(
                        height: _height * .60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            _userProfileImage(_userData!.image),
                            _userName(_userData.name),
                            _userEmail(_userData.email),
                            _logoutButton()
                          ],
                        ),
                      ),
                    )
                  : SpinKitSpinningLines(
                      color: Colors.blue,
                      size: _width * .60,
                    );
            });
      },
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
        onPressed: () {
          AuthProvider.instance.logoutFunction();
          // snackBarService.instance
          // .LoginStatusMessage("Successfully Logged OUT", Colors.red);
        },
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
