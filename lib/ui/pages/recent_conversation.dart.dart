import 'package:chatt/models/conversation_model.dart';
import 'package:chatt/ui/pages/conversation_page.dart';
import 'package:chatt/ui/provider/auth_provider.dart';
import 'package:chatt/ui/services/DB_service.dart';
import 'package:chatt/ui/services/navigation_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class recentConversation extends StatelessWidget {
  final double _height;
  final double _width;
  recentConversation(this._height, this._width);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: AuthProvider.instance,
      child: _conversationList(),
    );
  }

  Widget _conversationList() {
    return Builder(builder: (_context) {
      var _auth = Provider.of<AuthProvider>(_context);
      return Container(
        height: _height,
        width: _width,
        child: StreamBuilder<List<Conversations>>(
          stream: dbService.instance.getConversations(_auth.user!.uid),
          builder: (_context, _snapshot) {
            if (_snapshot.hasData) {
              var _data = _snapshot.data!;
              return _data.length == 0
                  ? Center(
                      child: Text("Hey.. There Is No Conversation Yet..!!"),
                    )
                  : ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (_context, index) {
                        return ListTile(
                          onTap: () {
                            navigationService.instance.navigateToRoute(
                              MaterialPageRoute(
                                builder: (context) {
                                  return converSation(
                                      _data[index].conversationID,
                                      _data[index].id,
                                      _data[index].name,
                                      _data[index].image);
                                },
                              ),
                            );
                          },
                          title: Text(
                            _data[index].name,
                            style: TextStyle(fontSize: 20),
                          ),
                          subtitle: _data[index].type == "text"
                              ? Text(_data[index].lastmessage)
                              : Text("Attachment"),
                          leading: _avaterImage(_data[index].image),
                          trailing: _trailingList(_data[index].timestamp),
                        );
                      },
                    );
            } else if (_snapshot.hasError) {
              return Text('Error: ${_snapshot.error}');
            } else {
              return SpinKitWanderingCubes(
                color: Colors.blue,
                size: 50.0,
              );
            }
          },
        ),
      );
    });
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
          timeago.format(_lastMessageTime.toDate()),
          style: TextStyle(fontSize: 15),
        ),
        CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 5,
        ),
      ],
    );
  }
}
