import 'package:flutter/material.dart';
import 'selectedType.dart';
import 'listForSelect.dart';

import 'controller.dart';
import 'currensy.dart';

class CreateWidgets {
  Controller ctrl = Controller();
  String _selectedValue;
  final _topController = TextEditingController();
  final _bottomController = TextEditingController();
  CreateWidgets() {
    _selectedValue = "0.0";
  }

  Widget createListTile(
      {Widget leading = const Text(""),
      Widget title = const Text(""),
      Widget subtitle = const Text(""),
      Widget trailing = const Text(""),
      Function() onTap}) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget topListTile(Widget leading, Widget title, Widget subtitle,
      Widget trailing, BuildContext context) {
    return createListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (
            context,
          ) =>
                  ListForSelect("top")),
        );
      },
    );
  }

  Widget bottomListTile(Widget leading, Widget title, Widget subtitle,
      Widget trailing, BuildContext context) {
    return createListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (
            context,
          ) =>
                  ListForSelect("bottom")),
        );
      },
    );
  }

  Future<List<Cripto>> getCripto() async {
    return await ctrl.getAllCriptoInfo();
  }

  Future<List<Cripto>> SelectedValues() async {
    List<Cripto> selectedValues = [];
    SelectedType selectedType = await ctrl.getSelectedValueInfo();
    selectedValues
        .add(await ctrl.getCriptoInfoViaMoneyType(selectedType.firstSelected));
    selectedValues
        .add(await ctrl.getCriptoInfoViaMoneyType(selectedType.secondSelected));
    return selectedValues;
  }

  Widget forCriptoConvert(context) {
    return Container(
      child: FutureBuilder(
        future: SelectedValues(),
        builder: (BuildContext context, AsyncSnapshot<List<Cripto>> snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text("Loading..."),
              ),
            );
          } else {
            return Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              color: Colors.lightBlue,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 70.0),
                  topListTile(
                      Image.asset(snapshot.data[0].flagPath),
                      Text(snapshot.data[0].moneyType),
                      Text(snapshot.data[0].countryName),
                      Container(
                        height: 0,
                        width: 0,
                      ),
                      context),
                  TextField(
                    decoration: InputDecoration(
                      hintText: _selectedValue,
                    ),
                    keyboardType: TextInputType.number,
                    controller: _topController,
                    onChanged: (value) {
                      double val;
                      if (value == "") {
                        val = 0.0;
                      } else {
                        val = double.parse(value);
                      }
                      _bottomController.text = (val *
                              snapshot.data[1].value.toDouble() /
                              snapshot.data[0].value.toDouble())
                          .toString();
                    },
                  ),
                  SizedBox(height: 30.0),
                  bottomListTile(
                      Image.asset(snapshot.data[1].flagPath),
                      Text(snapshot.data[1].moneyType),
                      Text(snapshot.data[1].countryName),
                      Container(
                        height: 0,
                        width: 0,
                      ),
                      context),
                  TextField(
                    controller: _bottomController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: _selectedValue,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget forAllList() {
    return Container(
      child: FutureBuilder(
        future: getCripto(),
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
