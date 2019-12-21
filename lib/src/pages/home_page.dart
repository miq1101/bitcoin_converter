import 'package:bitcoin_converter/src/bloc/change_currency_bloc.dart';
import 'package:bitcoin_converter/src/bloc/exchange_bloc.dart';
import 'package:bitcoin_converter/src/bloc/update_bloc.dart';
import 'package:bitcoin_converter/src/models/currency.dart';
import 'package:bitcoin_converter/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:search_widget/search_widget.dart';

class BtcHomePage extends StatefulWidget {
  @override
  _BtcHomePageState createState() => _BtcHomePageState();
}

class _BtcHomePageState extends State<BtcHomePage> {
  final _myController = TextEditingController();
  PageController _pageController;
  BtcChangeCurrencyBloc _changeCurrencyBloc;
  BtcAllListBloc _allListBloc;
  BtcExchangeBloc _btcExchangeBloc;
  Widget _allListForSelect;
  int _bottomSelectedIndex;
  Icon _homeIcon;
  Icon _listIcon;
  String _selectedValue;
  String _home;
  String _list;

  Widget _appBar() {
    return AppBar(
      leading: Icon(Icons.blur_on),
      title: Text("BITCOIN CONVERTER"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          color: Colors.white,
          onPressed: () async {},
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

  Widget _dividerField(){
    return Container(
      height: BtcConstants.screenHeight / 18.32,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
          Border.all(color: Colors.white),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight:
              Radius.circular(20.0))),
      child: Center(
        child: Divider(
          color: Colors.black,
          height: BtcConstants.screenHeight / 284,
          indent: BtcConstants.screenWidth / 2.37,
          endIndent: BtcConstants.screenWidth / 2.37,
        ),
      ),
    );
  }

  Widget _popupListItemWidget(BtcCripto cripto){
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        cripto.countryName,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _selectedItemWidget (BtcCripto cripto,String position){
      return ListTile(
        leading: Image.asset(cripto.flagPath),
        title: Text(cripto.moneyType),
        subtitle: Text(cripto.countryName),
        onTap: () async {
          if (position == "top") {
            _changeCurrencyBloc.updateSelectedValue(
                {"firstSelected": cripto.moneyType});
            BtcConstants.firstValue = cripto.value;
          } else {
            _changeCurrencyBloc.updateSelectedValue(
                {"secondSelected": cripto.moneyType});
            BtcConstants.secondValue = cripto.value;
          }
          _changeCurrencyBloc.addSink(position);
          _btcExchangeBloc.sink.add(null);
          Navigator.pop(context);
        });
  }

  Widget _noItemFound(){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.folder_open,
          size: 24,
          color: Colors.grey[900].withOpacity(0.7),
        ),
        const SizedBox(width: 10),
        Text(
          "No Items Found",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[900].withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _searchTextField (TextEditingController controller,FocusNode focusNode){
    return Container(
      padding:  EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
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
      ),
    );
  }

  Widget _searchField(AsyncSnapshot snapshot,String position){
    return SearchWidget<BtcCripto>(
      dataList: snapshot.data,
      hideSearchBoxWhenItemSelected: false,
      listContainerHeight: MediaQuery.of(context).size.height / 4,
      queryBuilder: (query, list) {
        return list
            .where((item) => item.countryName
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      },
      popupListItemBuilder: (item) {
        return _popupListItemWidget(item);
      },
      selectedItemBuilder: (selectedItem, deleteSelectedItem) {
        return _selectedItemWidget(selectedItem,position);
      },
      // widget customization
      noItemsFoundWidget: _noItemFound(),
      textFieldBuilder: (controller, focusNode) {
        return _searchTextField(controller, focusNode);
      },
//      onItemSelected: (item) {
//        setState(() {
//          _selectedItem = item;
//        });
//      },
    );
  }

  Widget _listForSelect(AsyncSnapshot snapshot,String position){
    return Container(
      height: BtcConstants.screenHeight -
          BtcConstants.screenHeight / 3.8,
      color: Colors.white,
      child: ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              leading: Image.asset(snapshot.data[index].flagPath),
              title: Text(snapshot.data[index].moneyType),
              subtitle: Text(snapshot.data[index].countryName),
              onTap: () async {
                if (position == "top") {
                  _changeCurrencyBloc.updateSelectedValue(
                      {"firstSelected": snapshot.data[index].moneyType});
                  BtcConstants.firstValue = snapshot.data[index].value;
                } else {
                  _changeCurrencyBloc.updateSelectedValue(
                      {"secondSelected": snapshot.data[index].moneyType});
                  BtcConstants.secondValue = snapshot.data[index].value;
                }
                _changeCurrencyBloc.addSink(position);
                _btcExchangeBloc.sink.add(null);
                Navigator.pop(context);
              });
        },
      ),
    );
  }

  Widget _bottomSheet(String position) {
    return Container(
      child: FutureBuilder(
        future: _changeCurrencyBloc.getAllCriptoInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Column(

              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _dividerField(),
                _searchField(snapshot,position),
                _listForSelect(snapshot,position),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _listTile(Widget leading, Widget title, Widget subtitle,
      BuildContext context, String position) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      onTap: () async {
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
      stream: _changeCurrencyBloc.changeFirst,
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

  Widget _topTextField(){
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
            _btcExchangeBloc.value = value;
          } else {
            _btcExchangeBloc.setValue = "0.0";
          }
          _btcExchangeBloc.sink.add(null);
        },
      ),
    );
  }

  Widget _bottomCurrency() {
    return StreamBuilder(
      stream: _changeCurrencyBloc.changeSecond,
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

  Widget _bottomTextField(){
    return StreamBuilder(
        stream: _btcExchangeBloc.change,
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
        child: Column(
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
        stream: _allListBloc.list,
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
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        _pageChanged(index);
        FocusScope.of(context).requestFocus(FocusNode());
      },
      children: <Widget>[
        _btcExchangeScreen(),
        _btcAllCriptoList(),
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
    _changeCurrencyBloc = BtcChangeCurrencyBloc();
    _changeCurrencyBloc.getRequests();
    _btcExchangeBloc = BtcExchangeBloc();
    _allListBloc = BtcAllListBloc();
    _allListBloc.sink.add(null);
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
  void dispose() {
    _pageController.dispose();
    _myController.dispose();
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