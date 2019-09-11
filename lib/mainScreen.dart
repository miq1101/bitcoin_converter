import 'package:flutter/material.dart';
import 'controller.dart';
import 'createWidgets.dart';

class ConvertScreen extends StatefulWidget {
  @override
  _ConvertScreenState createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> with CreateWidgets {
  Widget topLeading;
  Widget topTitle ;
  Widget topSubtitle ;
  Widget topTrailing ;
  Widget bottomLeading ;
  Widget bottomTitle ;
  Widget bottomSubtitle ;
  Widget bottomTrailing;
  int _selectedIndex = 0;
  @override
  void initState() {
    topLeading = Image.asset("assets/BTC.png");
    topTitle =  Text(
      "BTC",
      style: TextStyle(color: Colors.white, fontSize: 30.0),
    );
    topSubtitle = Text("Bitcoin",
        style: TextStyle(
          color: Colors.white,
        ));
    topTrailing = Icon(
      Icons.arrow_drop_down_circle,
      color: Colors.white,
      size: 20.0,
    );
    bottomLeading = Image.asset("assets/AMD.png");
    bottomTitle = Text(
      "AMD",
      style: TextStyle(color: Colors.white, fontSize: 30.0),
    );
    bottomSubtitle = Text("Armenian dram",
        style: TextStyle(
          color: Colors.white,
        ));
    bottomTrailing = Icon(
      Icons.arrow_drop_down_circle,
      color: Colors.white,
      size: 20.0,
    );
    super.initState();
  }
  void changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget body(int index) {
    if (index == 0) {
      return forCriptoConvert(topLeading,topTitle,topSubtitle,topTrailing,bottomLeading,bottomTitle,bottomSubtitle,bottomTrailing);
    }

    return forAllList();
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
                  onPressed: () {},
                ),
              ],
            ),
            body: body(_selectedIndex),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.blue,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Home",
                      style: TextStyle(color: Colors.white),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    title: Text("All list",
                        style: TextStyle(color: Colors.white))),
              ],
              currentIndex: _selectedIndex,
              onTap: changeIndex,
            )));
  }
}
