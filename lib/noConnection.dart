import 'package:flutter/material.dart';

class NoConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.indigo,
        child: Column(
          children: <Widget>[
            SizedBox(height: 200,),
            Icon(Icons.signal_cellular_connected_no_internet_4_bar,color: Colors.white,size: 50.0,),
            Text("no Connection",style: TextStyle(color: Colors.white,fontSize:30.0 ),),

          ],
        ),
      ),
    );
  }
}
