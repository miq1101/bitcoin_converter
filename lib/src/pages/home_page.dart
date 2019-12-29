import 'dart:async';
import 'package:bitcoin_converter/src/repository/connection_status.dart';
import 'package:bitcoin_converter/src/utils/constants.dart';

import 'package:flutter/material.dart';

class BtcHomePage extends StatefulWidget {
  @override
  _BtcHomePageState createState() => _BtcHomePageState();
}

class _BtcHomePageState extends State<BtcHomePage> with WidgetsBindingObserver {
  final _myController = TextEditingController();
  final _searchController = TextEditingController();
  PageController _pageController;
  Widget _connectionStatusBar;
  int _bottomSelectedIndex;
  Icon _homeIcon;
  Icon _listIcon;
  String _selectedValue;
  String _home;
  String _list;
  Timer _timer;
  int _startTimer;
  Widget _appBar() {
    return AppBar(
      leading: Icon(Icons.blur_on),
      title: Text("BITCOIN CONVERTER"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          color: Colors.white,
          onPressed: () {
            if (BtcConstants.connectionStatus) {
              BtcConstants.changeCurrencyBloc.updateDb();
              print("#################################");
            }
          },
        ),
      ],
    );
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

  void _pageChanged(int index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
  }

  Widget _dividerField() {
    return Container(
      height: BtcConstants.screenHeight / 18.32,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      child: Divider(
        color: Colors.black,
        height: BtcConstants.screenHeight / 284,
        indent: BtcConstants.screenWidth / 2.37,
        endIndent: BtcConstants.screenWidth / 2.37,
      ),
    );
  }

  Widget _searchField() {
    return Container(
      height: BtcConstants.screenHeight / 9,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white,
      child: TextField(
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        controller: _searchController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x4437474F),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
          hintText: "Search country...",
          contentPadding: const EdgeInsets.only(
            left: 16,
            right: 20,
            top: 14,
            bottom: 14,
          ),
        ),
        onChanged: (input) {
          BtcConstants.changeCurrencyBloc.setSearchText =
              _searchController.text[0].toUpperCase() +
                  _searchController.text.substring(1);
          BtcConstants.changeCurrencyBloc.allListForSelectSink.add(null);
        },
      ),
    );
  }

  Widget _listForSelect(String position) {
    return Container(
      color: Colors.white,
      height: BtcConstants.screenHeight - BtcConstants.screenHeight / 3.8,
      child: StreamBuilder(
        stream: BtcConstants.changeCurrencyBloc.listSelect,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    leading: Image.asset(snapshot.data[index].flagPath),
                    title: Text(snapshot.data[index].moneyType),
                    subtitle: Text(snapshot.data[index].countryName),
                    onTap: () async {
                      if (position == "top") {
                        BtcConstants.changeCurrencyBloc.updateSelectedValue(
                            {"firstSelected": snapshot.data[index].moneyType});
                        BtcConstants.firstValue = snapshot.data[index].value;
                      } else {
                        BtcConstants.changeCurrencyBloc.updateSelectedValue(
                            {"secondSelected": snapshot.data[index].moneyType});
                        BtcConstants.secondValue = snapshot.data[index].value;
                      }
                      BtcConstants.changeCurrencyBloc.addSink(position);
                      BtcConstants.changeCurrencyBloc.exchangeSink.add(null);
                      Navigator.pop(context);
                    });
              },
            );
          }
        },
      ),
    );
  }

  Widget _bottomSheet(String position) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        _dividerField(),
        _searchField(),
        _listForSelect(position),
      ],
    );
  }

  Widget _listTile(Widget leading, Widget title, Widget subtitle,
      BuildContext context, String position) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      onTap: () async {
        BtcConstants.changeCurrencyBloc.searchText = "";
        _searchController.text = "";
        BtcConstants.changeCurrencyBloc.allListForSelectSink.add(null);
        showModalBottomSheet<Null>(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) => _bottomSheet(position));
      },
    );
  }

  Widget _topCurrency() {
    return StreamBuilder(
      stream: BtcConstants.changeCurrencyBloc.changeFirst,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return _listTile(
              Image.asset(snapshot.data.flagPath),
              Text(snapshot.data.moneyType),
              Text(snapshot.data.countryName),
              context,
              "top");
        }
      },
    );
  }

  Widget _topTextField() {
    return Container(
      padding: EdgeInsets.only(
          left: BtcConstants.screenWidth / 16,
          right: BtcConstants.screenWidth / 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: _selectedValue,
        ),
        controller: _myController,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (value != "") {
            BtcConstants.changeCurrencyBloc.value = value;
          } else {
            BtcConstants.changeCurrencyBloc.setValue = "0.0";
          }
          BtcConstants.changeCurrencyBloc.exchangeSink.add(null);
        },
      ),
    );
  }

  Widget _bottomCurrency() {
    return StreamBuilder(
      stream: BtcConstants.changeCurrencyBloc.changeSecond,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return _listTile(
              Image.asset(snapshot.data.flagPath),
              Text(snapshot.data?.moneyType),
              Text(snapshot.data?.countryName),
              context,
              "bottom");
        }
      },
    );
  }

  Widget _bottomTextField() {
    return StreamBuilder(
        stream: BtcConstants.changeCurrencyBloc.change,
        builder: (context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.only(
                left: BtcConstants.screenWidth / 16,
                right: BtcConstants.screenWidth / 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: snapshot.data,
              ),
              enabled: false,
            ),
          );
        });
  }

  Widget _btcExchangeScreen() {
    return Container(
      //padding: EdgeInsets.all(20.0),
      child: Center(
        child: ListView(
          children: <Widget>[
            SizedBox(height: BtcConstants.screenHeight / 20),
            _topCurrency(),
            _topTextField(),
            SizedBox(height: BtcConstants.screenHeight / 10),
            _bottomCurrency(),
            _bottomTextField()
          ],
        ),
      ),
    );
  }

  Widget _btcAllCriptoList() {
    return Container(
      child: StreamBuilder(
        stream: BtcConstants.changeCurrencyBloc.list,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
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

  Widget _buildPageView() {
    return Stack(
      children: <Widget>[
        PageView(
          controller: _pageController,
          onPageChanged: (index) {
            _pageChanged(index);
            FocusScope.of(context).requestFocus(FocusNode());
          },
          children: <Widget>[
            _btcExchangeScreen(),
            _btcAllCriptoList(),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: _connectionStatusBar,
        ),
      ],
    );
  }

  void _bottomTapped(int index) {
    setState(() {
      _bottomSelectedIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  Widget _bottomBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.blue,
      items: <BottomNavigationBarItem>[
        bottomNavigationBarItem(_homeIcon, _home),
        bottomNavigationBarItem(_listIcon, _list),
      ],
      currentIndex: _bottomSelectedIndex,
      onTap: _bottomTapped,
    );
  }

  void initState() {
    _selectedValue = "0.0";
    _startTimer = 10;
    _connectionStatusBar = ConnectionStatusBar();
    WidgetsBinding.instance.addObserver(this);

    BtcConstants.changeCurrencyBloc.getRequests();
    _pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );
    _bottomSelectedIndex = 0;
    _homeIcon = Icon(
      Icons.home,
      color: Colors.white,
    );
    _listIcon = Icon(
      Icons.list,
      color: Colors.white,
    );
    _home = "Home";
    _list = "All list";

    super.initState();
  }

  _updateTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => () {
        if (_startTimer < 1) {
          if (BtcConstants.connectionStatus) {
            BtcConstants.changeCurrencyBloc.updateDb();
          }
          print("kanchvec");
          _updateTimer();
        } else {
          _startTimer = _startTimer - 1;
        }
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateTimer();
      print(_startTimer);
      print("########################");
    } else {
      print(_startTimer);
      print("*******************");
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _timer.cancel();
    _pageController.dispose();
    _myController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BtcConstants.screenHeight = MediaQuery.of(context).size.height;
    BtcConstants.screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            appBar: _appBar(),
            body: _buildPageView(),
            bottomNavigationBar: _bottomBar()));
  }
}
