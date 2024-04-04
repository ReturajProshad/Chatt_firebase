// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:chatt/ui/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';

import '../../firebaseFunction/activeStatusSender.dart';
import '../../models/message_model.dart';
import '../services/DB_service.dart';

// ignore: must_be_immutable
class converSation extends StatefulWidget {
  String ConvId;
  String ReceiverId;
  String ReceiverName;
  String ReceiverImage;
  converSation(
      this.ConvId, this.ReceiverId, this.ReceiverName, this.ReceiverImage,
      {super.key});

  @override
  State<converSation> createState() => _converSationState();
}

class _converSationState extends State<converSation> {
  late double _height;
  late double _width;
  late AuthProvider _auth;
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;

    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(31, 31, 31, 1.0),
        title: Text(widget.ReceiverName),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider.value(
        value: AuthProvider.instance,
        child: _conversationUI(),
      ),
    );
  }

  Widget _conversationUI() {
    return Builder(
      builder: (BuildContext _context) {
        _auth = Provider.of<AuthProvider>(_context);
        return Stack(
          children: [
            _messageListView(),
          ],
        );
      },
    );
  }

  Widget _messageListView() {
    return Container(
      height: _height * 0.75,
      width: _width,
      child: StreamBuilder(
          stream: dbService.instance.getmessages(widget.ConvId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SpinKitWanderingCubes(
                color: Colors.blue,
                size: 20,
              );
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            var conversationData = snapshot.data;
            // print("id = ${widget.ConvId}");
            // print("Type of StreamBuilder: ${snapshot.runtimeType}");
            // print("Type of datta: ${snapshot.data}");
            // print("conv data= $conversationData");
            if (conversationData != null) {
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                itemCount: conversationData.messages != null
                    ? conversationData.messages!.length
                    : 0,
                itemBuilder: (BuildContext _context, int index) {
                  var message = conversationData.messages![index];
                  String messageContent = message.content;
                  String senderId = message.senderId;
                  Timestamp timestamp = message.timestamp;
                  messageType type = message.type;
                  String accountHolder = IamActive.instance.userId;
                  bool isOwnOk = false;
                  if (senderId == accountHolder) {
                    isOwnOk = true;
                  }
                  return _messageListViewChild(
                      isOwnOk, messageContent, timestamp);
                },
              );
            } else {
              return Text('No data available');
            }
          }),
    );
  }

  Widget _messageListViewChild(
      bool isOwnOk, String messageContent, Timestamp timestamp) {
    return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment:
              !isOwnOk ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            !isOwnOk ? _userImage() : SizedBox(),
            _textBubble(isOwnOk, messageContent, timestamp),
          ],
        ));
  }

  Widget _userImage() {
    return CircleAvatar(
      radius: _height * 0.02,
      backgroundImage: NetworkImage(widget.ReceiverImage),
    );
  }

  Widget _textBubble(
      bool isOwnMessage, String _currentMessage, Timestamp _sendingtime) {
    List<Color> _colorScheme = isOwnMessage
        ? [
            Colors.blue,
            const Color.fromRGBO(42, 117, 188, 1),
          ]
        : [
            const Color.fromRGBO(69, 69, 69, 1),
            const Color.fromRGBO(43, 43, 43, 1),
          ];
    return Container(
      height: _height * 0.10,
      width: _width * 0.75,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: _colorScheme,
          stops: const [.30, 70],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(_currentMessage),
          Text(
            timeago.format(_sendingtime.toDate()),
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
