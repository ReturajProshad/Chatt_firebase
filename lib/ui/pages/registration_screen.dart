import 'dart:io';

import 'package:chatt/ui/provider/auth_provider.dart';
import 'package:chatt/ui/services/DB_service.dart';
import 'package:chatt/ui/services/cloudStorage_service.dart';
import 'package:chatt/ui/services/media_services.dart';
import 'package:chatt/ui/services/navigation_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class registrationPage extends StatefulWidget {
  const registrationPage({super.key});

  @override
  State<registrationPage> createState() => _registrationPageState();
}

// ignore: camel_case_types
class _registrationPageState extends State<registrationPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late GlobalKey<FormState> _formKey;
  late File? _image = null;
  AuthProvider? _auth;
  bool isImageSelected = false;
  final Color _textandCursorColor = kIsWeb ? Colors.black : Colors.white;
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  late String _email;
  late String _name;
  late String _password;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
          child: Container(
        //color: Colors.red,
        alignment: Alignment.center,
        child: ChangeNotifierProvider.value(
          value: AuthProvider.instance,
          child: Column(children: [
            SizedBox(
              height: _deviceHeight * .10,
            ),
            _registrationPageUI(),
          ]),
        ),
      )),
    );
  }

  Widget _registrationPageUI() {
    return Builder(builder: (_context) {
      _auth = Provider.of<AuthProvider>(_context);
      return Container(
        // color: Colors.red,
        height: _deviceHeight * 0.85,
        padding: EdgeInsets.symmetric(horizontal: _deviceWidth * .10),
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headingWidget(),
            _inputForm(),
            _registerButton(),
            _backToLogin(),
          ],
        ),
      );
    });
  }

  Widget _headingWidget() {
    return Container(
      // color: Colors.red,
      height: _deviceHeight * 0.15,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's Get Started..!!",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
          ),
          Text(
            "Please Enter your Detail's",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
          ),
        ],
      ),
    );
  }

  Widget _inputForm() {
    return Container(
      //color: Colors.red,
      height: _deviceHeight * 0.50,
      child: Form(
        key: _formKey,
        onChanged: () {
          _formKey.currentState?.save();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageSelector(),
            _nameTextField(),
            _emailTextField(),
            _passwordTextField(),
          ],
        ),
      ),
    );
  }

  Widget _imageSelector() {
    return GestureDetector(
      onTap: () async {
        File? _imageSelect = await mediaServices.instance.getImageFromFile();
        setState(() {
          _image = _imageSelect;
        });
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: _deviceHeight * .10,
          width: _deviceHeight * .10,
          decoration: BoxDecoration(
            color: const Color.fromARGB(81, 0, 0, 0),
            borderRadius: BorderRadius.circular(1000),
            image: _image != null
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(
                      File(_image!.path),
                    ),
                  )
                : const DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://cdn.vectorstock.com/i/1000x1000/17/61/select-image-vector-11591761.webp"),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _nameTextField() {
    return TextFormField(
      autocorrect: false,
      style: TextStyle(color: _textandCursorColor),
      validator: (_input) {
        return _input!.length != 0 ? null : "Please enter your name";
      },
      onSaved: (_input) {
        setState(() {
          _name = _input!;
        });
      },
      cursorColor: _textandCursorColor,
      decoration: InputDecoration(
        hintText: "Enter Your Name",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _textandCursorColor),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      autocorrect: false,
      style: TextStyle(color: _textandCursorColor),
      validator: (_input) {
        return _input!.length != 0 && _input.contains('@')
            ? null
            : "Please enter a valid email";
      },
      onSaved: (_input) {
        setState(() {
          _email = _input!;
        });
      },
      cursorColor: _textandCursorColor,
      decoration: InputDecoration(
        hintText: "Enter Your Email",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _textandCursorColor),
        ),
      ),
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      autocorrect: false,
      obscureText: true,
      style: TextStyle(color: _textandCursorColor),
      validator: (_input) {
        return _input!.length != 0 ? null : "Please enter a valid password";
      },
      onSaved: (_input) {
        setState(() {
          _password = _input!;
        });
      },
      cursorColor: _textandCursorColor,
      decoration: InputDecoration(
        hintText: "Enter a password",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _textandCursorColor),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return _auth?.status != AuthStatus.Authenticating
        ? Container(
            height: _deviceHeight * .06,
            width: _deviceWidth,
            child: MaterialButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() && _image != null) {
                  _auth?.registerWithE_P(_email, _password,
                      (String _uId) async {
                    var _result = await CloudStorageService.instance
                        .uploadUserImage(_uId, _image!);
                    var _imageUrl = await _result?.ref.getDownloadURL();
                    await dbService.instance
                        .createUser(_uId, _name, _imageUrl!, _email);
                  });
                }
                //setState(() {});
              },
              color: Colors.blue,
              child: const Text(
                "Register",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          )
        : const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
  }

  Widget _backToLogin() {
    return GestureDetector(
      onTap: () {
        navigationService.instance.goBack();
      },
      child: Container(
        height: _deviceHeight * .06,
        width: _deviceWidth,
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
