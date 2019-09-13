import 'package:flutter/material.dart';
import 'controller.dart';
import 'createWidgets.dart';

class ConvertScreen extends StatefulWidget {
  @override
  _ConvertScreenState createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  CreateWidgets create;
  Controller ctrl;
  int _selectedIndex;
  Icon homeIcon, listIcon;
  String home, list;
  @override
  void initState() {
    create = CreateWidgets();
    ctrl = Controller();
    _selectedIndex = 0;
    homeIcon = Icon(
      Icons.home,
      color: Colors.white,
    );
    listIcon = Icon(
      Icons.list,
      color: Colors.white,
    );
    home = "Home";
    list = "All list";

    super.initState();
  }

  void changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem bottomNavigationBarItem(Icon icon, String text) {
    return BottomNavigationBarItem(
        icon: icon,
        title: Text(
          text,
          style: TextStyle(color: Colors.white),
        ));
  }

  Widget noConnectDialog() {
    return AlertDialog(
      title: Text("No connection"),
      actions: <Widget>[
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  Widget body(int index) {
    if (index == 0) {
      return create.forCriptoConvert(context);
    }

    return create.forAllList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: Icon(Icons.blur_on),
              title: Text("BITCOIN CONVERTER"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  color: Colors.white,
                  onPressed: () async {
                    if (!(await ctrl.upDateDB())) {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return noConnectDialog();
                          });
                    }
                  },
                ),
              ],
            ),
            body: body(_selectedIndex),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.blue,
              items: <BottomNavigationBarItem>[
                bottomNavigationBarItem(homeIcon, home),
                bottomNavigationBarItem(listIcon, list),
              ],
              currentIndex: _selectedIndex,
              onTap: changeIndex,
            )));
  }
}
