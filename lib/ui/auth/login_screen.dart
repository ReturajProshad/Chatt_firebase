// ignore_for_file: unused_field, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  late String _Email;
  late String _Password;
  var _auth = AuthProvider();
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late double _deviceHeight;
  late double _deviceWidth;
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Align(
        alignment: Alignment.center,
        child: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance,
          child: _loginUi(),
        ),
      ),
    );
  }

  Widget _loginUi() {
    return Builder(builder: (BuildContext _context) {
      _auth = Provider.of<AuthProvider>(_context);
      print(_auth.user);
      return Container(
        height: _deviceHeight * .60,
        padding: EdgeInsets.symmetric(horizontal: _deviceWidth * .10),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headingTxt(),
            _inputField(),
            _loginButton(),
            _registerButton()
          ],
        ),
      );
    });
  }

  Widget _headingTxt() {
    return Container(
      height: _deviceHeight * 0.15,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome Back!",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
          ),
          Text(
            "Please Login To Continue",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
          ),
        ],
      ),
    );
  }

  Widget _inputField() {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _emailinput(),
          _passwordinput(),
        ],
      ),
    );
  }

  Widget _emailinput() {
    return TextFormField(
      controller: _emailController,
      autocorrect: false,
      validator: (_input) {
        return _input!.length != 0 && _input.contains("@")
            ? null
            : "Please enter a valid email";
      },
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: "Email Address",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _passwordinput() {
    return TextFormField(
      controller: _passWordController,
      autocorrect: false,
      obscureText: true,
      validator: (_input) {
        return _input!.length != 0 ? null : "Enter a password";
      },
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: "Enter The Password",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return _auth.status == AuthStatus.Authenticating
        ? Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
        : Container(
            height: _deviceHeight * .06,
            width: _deviceWidth,
            child: MaterialButton(
              onPressed: () {
                _Email = _emailController.text;
                _Password = _passWordController.text;
                print(_Email);
                print(_Password);
                if (verifyEmail(_Email) && varifyPass(_Password)) {
                  _auth.loginWithE_P(_Email, _Password);
                }
                //setState(() {});
              },
              color: Colors.blue,
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          );
  }

  Widget _registerButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: _deviceHeight * .06,
        width: _deviceWidth,
        child: const Text(
          "Register",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w200,
            color: Colors.white60,
          ),
        ),
      ),
    );
  }

  bool verifyEmail(String Email) {
    if (Email.contains('@')) {
      return true;
    } else
      return false;
  }

  bool varifyPass(String pass) {
    if (pass.length >= 4) {
      return true;
    } else
      return false;
  }
}
