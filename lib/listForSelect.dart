import 'package:flutter/material.dart';
import 'selectedType.dart';
import 'controller.dart';
import 'createWidgets.dart';
import 'currensy.dart';
import 'mainScreen.dart';

class ListForSelect extends StatefulWidget {
  String possition;
  ListForSelect(String possition) {
    this.possition = possition;
  }

  @override
  _ListForSelectState createState() => _ListForSelectState();
}

class _ListForSelectState extends State<ListForSelect> {
  CreateWidgets create = CreateWidgets();
  Controller cntrl = Controller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select currency"),
      ),
      body: Container(
        child: FutureBuilder(
          future: create.getCripto(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Cripto>> snapshot) {
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
                  return create.createListTile(
                      leading: Image.asset(snapshot.data[index].flagPath),
                      title: Text(snapshot.data[index].moneyType),
                      subtitle: Text(snapshot.data[index].countryName),
                      onTap: () async {
                        if (widget.possition == "top") {
                          String secondSelected =
                              (await cntrl.getSelectedValueInfo())
                                  .secondSelected;
                          await cntrl.updateSelectedValue(SelectedType(
                              firstSelected: snapshot.data[index].moneyType,
                              secondSelected: secondSelected));
                        } else {
                          String firstSelected =
                              (await cntrl.getSelectedValueInfo())
                                  .firstSelected;
                          await cntrl.updateSelectedValue(SelectedType(
                              firstSelected: firstSelected,
                              secondSelected: snapshot.data[index].moneyType));
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (
                            context,
                          ) =>
                                  ConvertScreen()),
                        );
                      });
                },
              );
            }
          },
        ),
      ),
    );
  }
}
