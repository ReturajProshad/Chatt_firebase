import 'package:chatt/firebaseFunction/activeStatusSender.dart';
import 'package:chatt/models/message_model.dart';
import 'package:chatt/ui/services/DB_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class converSation extends StatefulWidget {
  String ConvId;
  String ReceiverId;
  String ReceiverName;
  String ReceiverImage;
  converSation(
      this.ConvId, this.ReceiverId, this.ReceiverName, this.ReceiverImage);

  @override
  State<converSation> createState() => _converSationState();
}

class _converSationState extends State<converSation> {
  late double _height;
  late double _width;
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
      body: _conversationUI(),
    );
  }

  Widget _conversationUI() {
    return Stack(
      children: [
        _messageListView(),
      ],
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
              return CircularProgressIndicator();
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
                  bool isOK = false;
                  if (senderId == accountHolder) {
                    isOK = true;
                  }
                  return _textBubble(isOK, messageContent);
                },
              );
            } else {
              return Text('No data available');
            }
          }),
    );
  }

  Widget _textBubble(bool isOwnMessage, String _currentMessage) {
    List<Color> _colorScheme = isOwnMessage
        ? [
            Colors.blue,
            Color.fromRGBO(42, 117, 188, 1),
          ]
        : [
            Color.fromRGBO(69, 69, 69, 1),
            Color.fromRGBO(43, 43, 43, 1),
          ];
    return Container(
      height: _height * 0.10,
      width: _width * 0.75,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
            colors: _colorScheme,
            stops: [.30, 70],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(_currentMessage),
          Text(
            "a moment ago",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
