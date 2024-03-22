import 'package:chatt/models/contact_model.dart';
import 'package:chatt/ui/services/DB_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../provider/auth_provider.dart';

// ignore: must_be_immutable
class searchPage extends StatefulWidget {
  double _height;
  double _width;
  searchPage(this._height, this._width);

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  late AuthProvider _auth;
  String _searchText = '';
  @override
  void initState() {
    _searchText = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _searchPageUI(),
      ),
    );
  }

  Widget _searchPageUI() {
    return Builder(builder: (context) {
      _auth = Provider.of<AuthProvider>(context);
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _searchBar(),
          _userList(),
        ],
      );
    });
  }

  Widget _searchBar() {
    return Container(
      height: this.widget._height * .08,
      width: this.widget._width,
      padding: EdgeInsets.symmetric(vertical: this.widget._height * .02),
      child: TextField(
        autocorrect: false,
        style: TextStyle(color: Colors.white),
        onSubmitted: (_input) {
          _searchText = _input;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          prefixIconColor: Colors.white,
          label: Text("Search"),
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

  Widget _userList() {
    return Container(
      height: this.widget._height * 0.73,
      //color: Colors.red,
      child: StreamBuilder<List<Contact>>(
          stream: dbService.instance.userSearchList(_searchText),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var _data = snapshot.data!;
              if (_data != null) {
                _data.removeWhere((Contact) => Contact.id == _auth.user!.uid);
              }
              return ListView.builder(
                itemCount: _data.length,
                itemBuilder: (BuildContext context, int _index) {
                  var _currentTime = DateTime.now();
                  var isActive = !_data[_index].lastSeen.toDate().isBefore(
                        _currentTime.subtract(
                          Duration(minutes: 20),
                        ),
                      );
                  return ListTile(
                    onTap: () {},
                    leading: _avaterImage(_data[_index].image),
                    title: Text(_data[_index].name),
                    trailing: _trailingList(_data[_index].lastSeen, isActive),
                  );
                },
              );
            } else if (snapshot.hasError) {
              //print("Error");
              return Text("Error fetching data");
            } else {
              return SpinKitWanderingCubes(
                color: Colors.blue,
                size: 50.0,
              );
            }
          }),
    );
  }

  Widget _avaterImage(String _ImgUrl) {
    return CircleAvatar(
      radius: 20,
      backgroundImage: NetworkImage(_ImgUrl),
    );
  }

  Widget _trailingList(Timestamp _lastMessageTime, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        isActive
            ? Text(
                "Active Now",
                style: TextStyle(fontSize: 15),
              )
            : Text(
                "Last Seen",
                style: TextStyle(fontSize: 15),
              ),
        isActive
            ? CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 5,
              )
            : Text(
                timeago.format(_lastMessageTime.toDate()),
                style: TextStyle(fontSize: 12),
              ),
      ],
    );
  }
}
