import 'package:flutter/material.dart';

import 'controller.dart';
import 'currensy.dart';

mixin CreateWidgets {
  Controller ctrl = Controller();
  bool enabledPopup = true;

  Widget createListTile(
      {Widget leading = const Text(""),
        Widget title = const Text(""),
        Widget subtitle = const Text(""),
        Widget trailing = const Text(""),
        Function() onTap  }) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
    );
  }


  Widget topListTile (Widget leading,Widget title,Widget subtitle,Widget trailing ) {
    return createListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: () {
      },
    );
  }
  Widget bottomListTile (Widget leading,Widget title,Widget subtitle,Widget trailing) {
    return createListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: () {
      },
    );
  }
  Future<List<Cripto>> _getCripto() async {
    return await ctrl.getAllCriptoInfo();
  }

  Widget forCriptoConvert(topLeading,topTitle,topSubtitle,topTrailing,bottomLeading,bottomTitle,bottomSubtitle,bottomTrailing){
    return Container(
      padding: EdgeInsets.only(left: 20.0,right: 20.0),
      color: Colors.lightBlue,
      child: Column(
        children: <Widget>[
          SizedBox(height: 70.0),
          topListTile(topLeading,topTitle,topSubtitle,topTrailing),
          TextFormField(
            style: TextStyle(color: Colors.white, fontSize: 30.0),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                hintText: "0.0",
                hintStyle: TextStyle(color: Colors.white, fontSize: 30.0)),
          ),

          SizedBox(height: 30.0),
          bottomListTile(bottomLeading,bottomTitle,bottomSubtitle,bottomTrailing),
          TextFormField(
            readOnly: true,
            style: TextStyle(color: Colors.white, fontSize: 30.0),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                hintText: "0.0",
                hintStyle: TextStyle(color: Colors.white, fontSize: 30.0)),
          ),

        ],
      ),
    );
  }

  Widget forAllList(){
    return Container(
      child: FutureBuilder(
        future: _getCripto(),
        builder: (BuildContext context, AsyncSnapshot<List<Cripto>> snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text("Loading..."),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return createListTile(
                  leading: Image.asset(snapshot.data[index].flagPath),
                  title: Text(snapshot.data[index].moneyType),
                  subtitle: Text(snapshot.data[index].countryName),
                  trailing: Text(snapshot.data[index].value.toString()),
                );
              },
            );
          }
        },
      ),
    );
  }
}
