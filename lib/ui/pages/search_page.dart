import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class searchPage extends StatefulWidget {
  double _height;
  double _width;
  searchPage(this._height, this._width);

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _searchPageUI(),
    );
  }

  Widget _searchPageUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [_searchBar(), _userList()],
    );
  }

  Widget _searchBar() {
    return Container(
      height: this.widget._height * .08,
      width: this.widget._width,
      padding: EdgeInsets.symmetric(vertical: this.widget._height * .02),
      child: TextField(
        autocorrect: false,
        style: TextStyle(color: Colors.white),
        onSubmitted: (_input) {},
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
      child: ListView.builder(
        itemCount: 100,
        itemBuilder: (BuildContext context, int _index) {
          return ListTile(
            leading: _avaterImage(""),
            title: Text("Returaj"),
            trailing: _trailingList(Timestamp(5, 20)),
          );
        },
      ),
    );
  }

  Widget _avaterImage(String _ImgUrl) {
    return CircleAvatar(
      radius: 20,
      backgroundImage: NetworkImage(_ImgUrl),
    );
  }

  Widget _trailingList(Timestamp _lastMessageTime) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          "Last Seen",
          style: TextStyle(fontSize: 15),
        ),
        Text(
          timeago.format(_lastMessageTime.toDate()),
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
