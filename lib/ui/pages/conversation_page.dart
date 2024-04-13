// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:async';

import 'package:chatt/firebaseFunction/messageCreated.dart';
import 'package:chatt/ui/provider/auth_provider.dart';
import 'package:chatt/ui/services/cloudStorage_service.dart';
import 'package:chatt/ui/services/media_services.dart';
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
  GlobalKey<FormState>? _formkey;
  String? _messageTextForSend;
  ScrollController? _listViewController = ScrollController();
  @override
  void initState() {
    _formkey = GlobalKey<FormState>();
    _messageTextForSend = "";
    // TODO: implement initState
    _listViewController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_messageTextForSend);

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
            Align(
                alignment: Alignment.bottomCenter,
                child: _messageField(_context)),
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
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_listViewController != null &&
                    _listViewController!.hasClients) {
                  _listViewController!.animateTo(
                    _listViewController!.position.maxScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });

              return ListView.builder(
                controller: _listViewController,
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
                      isOwnOk, messageContent, timestamp, type);
                },
              );
            } else {
              return Text('No data available');
            }
          }),
    );
  }

  Widget _messageListViewChild(bool isOwnOk, String messageContent,
      Timestamp timestamp, messageType type) {
    return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment:
              !isOwnOk ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            !isOwnOk ? _userImage() : SizedBox(),
            type == messageType.text
                ? _textBubble(isOwnOk, messageContent, timestamp)
                : _imageMessageBuble(isOwnOk, messageContent, timestamp),
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
      height: _height * 0.10 + (_messageTextForSend!.length / 20 * 5.0),
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

  Widget _imageMessageBuble(
      bool isOwnMessage, String _imageUrl, Timestamp _sendingtime) {
    List<Color> _colorScheme = isOwnMessage
        ? [
            Colors.blue,
            const Color.fromRGBO(42, 117, 188, 1),
          ]
        : [
            const Color.fromRGBO(69, 69, 69, 1),
            const Color.fromRGBO(43, 43, 43, 1),
          ];
    // DecorationImage _image =
    //     DecorationImage(image: NetworkImage(_imageUrl), fit: BoxFit.cover);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          Container(
            height: _height * .30,
            width: _width * 0.40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: NetworkImage(_imageUrl), fit: BoxFit.cover),
            ),
          ),
          Text(
            timeago.format(_sendingtime.toDate()),
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _messageField(BuildContext _context) {
    return Container(
      height: _height * 0.08,
      decoration: BoxDecoration(
        color: Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: _width * 0.04, vertical: _height * 0.03),
      child: Form(
        key: _formkey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _messageTextField(),
            _messageSendIcon(_context),
            _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _width * 0.55,
      child: TextFormField(
        validator: (_input) {
          if (_input!.length == 0) {
            return "Please Enter a message";
          }
          return null;
        },
        onChanged: (_input) {
          _formkey!.currentState?.save();
        },
        onSaved: (_input) {
          _messageTextForSend = _input;
        },
        cursorColor: Colors.white,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: "Type a message"),
        autocorrect: false,
      ),
    );
  }

  Widget _messageSendIcon(BuildContext _context) {
    return SizedBox(
      height: _height * 0.05,
      width: _width * 0.08,
      child: IconButton(
        icon: const Icon(
          Icons.send,
          color: Colors.white,
        ),
        onPressed: () {
          MessageCreateService.instance.onMessageUpdate(
              _auth.user!.uid, widget.ReceiverId, "text", _messageTextForSend!);

          _messageTextForSend = "";
          _formkey?.currentState!.reset();
          FocusScope.of(_context).unfocus();
        },
      ),
    );
  }

  Widget _imageMessageButton() {
    return Container(
      //
      height: _height * 0.05,
      width: _width * 0.09,
      child: FloatingActionButton(
        onPressed: () async {
          var _image = await mediaServices.instance.getImageFromFile();
          if (_image != null) {
            var _result = await CloudStorageService.instance
                .uploadMediaMessage(_auth.user!.uid, _image);
            var _imageUrl = await _result!.ref.getDownloadURL();
            await MessageCreateService.instance.onMessageUpdate(_auth.user!.uid,
                widget.ReceiverId, messageType.media.toString(), _imageUrl);
          }
        },
        child: const Icon(
          Icons.camera_enhance,
        ),
      ),
    );
  }
}
