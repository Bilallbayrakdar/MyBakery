import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_my_bakery/shared/faderoute.dart';
import 'package:flutter_my_bakery/models/models.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/edit.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/view.dart';
import 'package:flutter_my_bakery/services/database.dart';
import 'package:flutter_my_bakery/shared/cards.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_my_bakery/shared/constants.dart';

class Veresiye extends StatefulWidget {
  Veresiye({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _VeresiyeState createState() => _VeresiyeState();
}

class _VeresiyeState extends State<Veresiye> {
  bool headerShouldHide = false;
  List<VeresiyeModel> veresiyeList = [];
  TextEditingController searchController = TextEditingController();
  bool isSearchEmpty = true;

  @override
  void initState() {
    super.initState();
    NotesDatabaseService.db.init();
    setVeresiyeFromDB();
  }

  setVeresiyeFromDB() async {
    print("Entered setVeresiye");
    var fetchedVeresiye = await NotesDatabaseService.db.getVeresiyeFromDB();
    setState(() {
      veresiyeList = fetchedVeresiye;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Veresiyeler",
          style: TextStyle(fontFamily: "Poppins"),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          gotoEditVeresiye();
        },
        label: Text('Veresiye Ekle'.toUpperCase()),
        icon: Icon(Icons.add),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              buildButtonRow(),
              Container(height: 32),
              ...buildveresiyeComponentsList(),
            ],
          ),
          margin: EdgeInsets.only(top: 2),
          padding: EdgeInsets.only(left: 15, right: 15),
        ),
      ),
    );
  }

  Widget buildButtonRow() {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.only(left: 16),
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            maxLines: 1,
                            onChanged: (value) {
                              handleSearch(value);
                            },
                            autofocus: false,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Ara',
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade300,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                              isSearchEmpty ? Icons.search : Icons.cancel,
                              color: Colors.grey.shade300),
                          onPressed: cancelSearch,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }

  veresiyePopup(BuildContext dialogContext, VeresiyeModel veresiye,
      TextEditingController controller) {
    final contextW = MediaQuery.of(context).size.width;
    final sizeW = contextW / 20;

    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(
          fontFamily: "Poppins", fontWeight: FontWeight.bold, fontSize: sizeW),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: veresiye.title,
        content: Column(
          children: [
            SizedBox(
              height: sizeW,
            ),
            SizedBox(
              height: sizeW,
            ),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: textStyle1,
              decoration: textInputDecoration.copyWith(
                labelText: veresiye.content,
              ),
              validator: (val) => val.isEmpty ? "Enter an email" : null,

              // onChanged: (val) {
              //   setState(() {
              //     piece.add(int.parse(controller.value.text));
              //   });
              // },
            ),
          ],
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Çıkar",
              style: TextStyle(color: Colors.white, fontSize: sizeW),
            ),
            onPressed: () {
              setState(() {
                if (int.parse(controller.value.text) > 0) {
                  veresiye.content = ((int.parse(veresiye.content)) -
                          (int.parse(controller.value.text)))
                      .toString();
                }
              });
              Navigator.pop(context);
            },
            color: Colors.red,
          ),
          DialogButton(
            child: Text(
              "Ekle",
              style: TextStyle(color: Colors.white, fontSize: sizeW),
            ),
            onPressed: () {
              print("inside ekle");
              setState(() {
                if (int.parse(controller.value.text) > 0) {
                  veresiye.content = ((int.parse(veresiye.content)) +
                          (int.parse(controller.value.text)))
                      .toString();
                }
              });
              Navigator.pop(context);
            },
            color: Colors.blue,
          )
        ]).show();
  }

  List<Widget> buildveresiyeComponentsList() {
    List<Widget> veresiyeComponentsList = [];
    veresiyeList.sort((a, b) {
      return b.date.compareTo(a.date);
    });
    if (searchController.text.isNotEmpty) {
      veresiyeList.forEach((note) {
        if (note.title
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            note.content
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
          veresiyeComponentsList.add(VeresiyeCardComponent(
            veresiyeData: note,
            onTapAction: veresiyePopup,
          ));
      });
      return veresiyeComponentsList;
    } else {
      veresiyeList.forEach((note) {
        veresiyeComponentsList.add(VeresiyeCardComponent(
          veresiyeData: note,
          onTapAction: veresiyePopup,
        ));
      });
    }
    return veresiyeComponentsList;
  }

  void handleSearch(String value) {
    if (value.isNotEmpty) {
      setState(() {
        isSearchEmpty = false;
      });
    } else {
      setState(() {
        isSearchEmpty = true;
      });
    }
  }

  void gotoEditVeresiye() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                EditVeresiyePage(triggerRefetch: refetchVeresiyeFromDB)));
  }

  void refetchVeresiyeFromDB() async {
    await setVeresiyeFromDB();
    print("Refetched veresiye");
  }

  openVeresiyeToRead(VeresiyeModel veresiyeData) async {
    setState(() {
      headerShouldHide = true;
    });
    await Future.delayed(Duration(milliseconds: 230), () {});
    Navigator.push(
        context,
        FadeRoute(
            page: ViewVeresiyePage(
                triggerRefetch: refetchVeresiyeFromDB,
                currentVeresiye: veresiyeData)));
    await Future.delayed(Duration(milliseconds: 300), () {});

    setState(() {
      headerShouldHide = false;
    });
  }

  void cancelSearch() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      searchController.clear();
      isSearchEmpty = true;
    });
  }
}
