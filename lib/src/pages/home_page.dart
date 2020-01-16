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
      leading: Container(
          padding: EdgeInsets.all(10.0),
          child: Image.asset("assets/Logo.png", color: Colors.white)),
      title: Text("Bitcoin converter"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          color: Colors.white,
          onPressed: () {
            if (BtcConstants.connectionStatus) {
              BtcConstants.changeCurrencyBloc.updateDb();
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
          color: Colors.grey[900],
          border: Border.all(color: Colors.grey[900]),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      child: Divider(
        color: Colors.white,
        height: BtcConstants.screenHeight / 284,
        indent: BtcConstants.screenWidth / 2.37,
        endIndent: BtcConstants.screenWidth / 2.37,
      ),
    );
  }

  Widget _searchField() {
    return Container(
      color: Colors.grey[900],
      height: BtcConstants.screenHeight / 9,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        style: TextStyle(fontSize: 16, color: Colors.white),
        controller: _searchController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          suffixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          border: InputBorder.none,
          hintText: "Search country...",
          hintStyle: TextStyle(color: Colors.white),
          contentPadding: const EdgeInsets.only(
            left: 16,
            right: 20,
            top: 14,
            bottom: 14,
          ),
        ),
        onChanged: (input) {
          if (input == "") {
            BtcConstants.changeCurrencyBloc.setSearchText = "";
          } else {
            BtcConstants.changeCurrencyBloc.setSearchText =
                input[0].toUpperCase() + _searchController.text.substring(1);
          }
          BtcConstants.changeCurrencyBloc.allListForSelectSink.add(null);
        },
      ),
    );
  }

  Widget _listForSelect(String position) {
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: Colors.white,
      height: BtcConstants.screenHeight - BtcConstants.screenHeight / 3.8,
      child: StreamBuilder(
        stream: BtcConstants.changeCurrencyBloc.listSelect,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFed6f0e),
                    )),
              ),
            );
          } else if (snapshot.data.isEmpty) {
            return Container(
              color: Colors.grey[900],
              width: BtcConstants.screenWidth,
              alignment: Alignment.topCenter,
              child: Text(
                "No item found",
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            return Container(
              color: Colors.grey[900],
              padding: EdgeInsets.only(bottom: bottom),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      leading: Image.asset(snapshot.data[index].flagPath),
                      title: Text(snapshot.data[index].moneyType,
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text(snapshot.data[index].countryName,
                          style: TextStyle(color: Colors.grey)),
                      onTap: () async {
                        if (position == "top") {
                          BtcConstants.changeCurrencyBloc.updateSelectedValue({
                            "firstSelected": snapshot.data[index].moneyType
                          });
                          BtcConstants.firstValue = snapshot.data[index].value;
                        } else {
                          BtcConstants.changeCurrencyBloc.updateSelectedValue({
                            "secondSelected": snapshot.data[index].moneyType
                          });
                          BtcConstants.secondValue = snapshot.data[index].value;
                        }
                        BtcConstants.changeCurrencyBloc.addSink(position);
                        BtcConstants.changeCurrencyBloc.exchangeSink.add(null);
                        Navigator.pop(context);
                      });
                },
              ),
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
              child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFed6f0e),
                  )),
            ),
          );
        } else {
          return _listTile(
              Image.asset(snapshot.data.flagPath),
              Text(snapshot.data.moneyType,
                  style: TextStyle(color: Colors.white)),
              Text(snapshot.data.countryName,
                  style: TextStyle(color: Colors.grey)),
              context,
              "top");
        }
      },
    );
  }

  Widget _topTextField() {
    return StreamBuilder(
        stream: BtcConstants.changeCurrencyBloc.change,
        builder: (context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.only(
                left: BtcConstants.screenWidth / 16,
                right: BtcConstants.screenWidth / 16),
            child: TextField(
              style: TextStyle(color: Colors.white),
              maxLength: 9,
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  counter: Offstage(),
                  hintText: _selectedValue,
                  hintStyle: TextStyle(color: Colors.white),
                  helperText: snapshot.data == "-1.0"
                      ? "Please input correct number"
                      : "",
                  helperStyle: TextStyle(color: Colors.red)),
              controller: _myController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value != "") {
                  BtcConstants.changeCurrencyBloc.setValue = value;
                } else {
                  BtcConstants.changeCurrencyBloc.setValue = "0.0";
                }
                BtcConstants.changeCurrencyBloc.exchangeSink.add(null);
              },
            ),
          );
        });
  }

  Widget _bottomCurrency() {
    return StreamBuilder(
      stream: BtcConstants.changeCurrencyBloc.changeSecond,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFed6f0e),
                  )),
            ),
          );
        } else {
          return _listTile(
              Image.asset(snapshot.data.flagPath),
              Text(snapshot.data?.moneyType,
                  style: TextStyle(color: Colors.white)),
              Text(snapshot.data?.countryName,
                  style: TextStyle(color: Colors.grey)),
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
                disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: snapshot.data == "-1.0" ? "0.0" : snapshot.data,
                hintStyle: TextStyle(color: Colors.white),
              ),
              enabled: false,
            ),
          );
        });
  }

  _replaceCurrency()  {
    return Container(
      alignment: Alignment.bottomRight,
      margin: EdgeInsets.only(right: BtcConstants.screenWidth / 16),
      height: BtcConstants.screenHeight / 15,
      child: IconButton(
        icon: Icon(
          Icons.import_export,
          color: Colors.grey,
          size: BtcConstants.screenHeight / 20,
        ),
        onPressed: () async{
          await BtcConstants.changeCurrencyBloc.replaceCurrency();
        },
      ),
    );
  }

  Widget _btcExchangeScreen() {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: ListView(
          children: <Widget>[
            SizedBox(height: BtcConstants.screenHeight / 20),
            _topCurrency(),
            _topTextField(),
            _replaceCurrency(),
            _bottomCurrency(),
            _bottomTextField()
          ],
        ),
      ),
    );
  }

  Widget _btcAllCriptoList() {
    return Container(
      color: Colors.grey[900],
      child: StreamBuilder(
        stream: BtcConstants.changeCurrencyBloc.list,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFed6f0e),
                    )),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Image.asset(snapshot.data[index].flagPath),
                  title: Text(
                    snapshot.data[index].moneyType,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(snapshot.data[index].countryName,
                      style: TextStyle(color: Colors.grey)),
                  trailing: Text(snapshot.data[index].value.toString(),
                      style: TextStyle(color: Colors.white)),
                  onTap: () async {
                    BtcConstants.changeCurrencyBloc.updateSelectedValue(
                        {"firstSelected": snapshot.data[index].moneyType});
                    BtcConstants.firstValue = snapshot.data[index].value;

                    BtcConstants.changeCurrencyBloc.firstSink.add(null);
                    BtcConstants.changeCurrencyBloc.exchangeSink.add(null);
                    _pageController.jumpTo(0);
                  },
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
      backgroundColor: Color(0xFFed6f0e),
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (BtcConstants.connectionStatus) {
        BtcConstants.changeCurrencyBloc.updateDb();
      }
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
