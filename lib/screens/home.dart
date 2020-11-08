import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Administrator"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                myBox2(),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    myBox(),
                    SizedBox(width: 10),
                    myBox(),
                    SizedBox(width: 10),
                    myBox(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget myBox(){
  return Container(
    alignment: Alignment.topRight,
    decoration: BoxDecoration(color: Colors.lightBlue,borderRadius: BorderRadius.all(Radius.circular(15.0))),
    width: 120,
    height: 120,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cached_sharp,
            color: Colors.black,
            size: 50,
          ),
          Text("Deneme")
        ],
      ),
    ),
  );
}

Widget myBox2(){
  return Container(
    alignment: Alignment.topRight,
    decoration: BoxDecoration(color: Colors.lightBlue,borderRadius: BorderRadius.all(Radius.circular(30.0))),
    width: 380,
    height: 70,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cached_sharp,
            color: Colors.black,
            size: 30,
          ),
          Text("Deneme")
        ],
      ),
    ),
  );
}