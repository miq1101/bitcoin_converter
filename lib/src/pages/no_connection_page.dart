import 'package:flutter/material.dart';

class BtcNoConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Icon(Icons.wifi_lock,size: 50,),
        ),
      ),
    );
  }
}
