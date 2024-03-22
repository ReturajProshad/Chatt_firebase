import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(31, 31, 31, 1.0),
        title: Text(widget.ReceiverName),
        centerTitle: true,
      ),
    );
  }
}
