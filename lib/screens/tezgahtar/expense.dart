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

class Expense extends StatefulWidget {
  Expense({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ExpenseState createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  bool headerShouldHide = false;
  List<ExpensesModel> expensesList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    NotesDatabaseService.db.init();
    setExpensesFromDB();
  }

  setExpensesFromDB() async {
    print("Entered setExpenses");
    var fetchedExpenses = await NotesDatabaseService.db.getExpensesFromDB();
    setState(() {
      expensesList = fetchedExpenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gider Gir",
          style: TextStyle(fontFamily: "Poppins"),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          gotoEditExpense();
        },
        label: Text('Gider Ekle'.toUpperCase()),
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
              Container(height: 32),
              ...buildExpenseComponentsList(),
            ],
          ),
          margin: EdgeInsets.only(top: 2),
          padding: EdgeInsets.only(left: 15, right: 15),
        ),
      ),
    );
  }

  List<Widget> buildExpenseComponentsList() {
    List<Widget> expenseComponentsList = [];
    expensesList.sort((a, b) {
      return b.date.compareTo(a.date);
    });
    expensesList.forEach((note) {
      expenseComponentsList.add(ExpenseCardComponent(
        expenseData: note,
        onTapAction: openExpenseToRead,
      ));
    });
    return expenseComponentsList;
  }

  void gotoEditExpense() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                EditExpensePage(triggerRefetch: refetchExpensesFromDB)));
  }

  void refetchExpensesFromDB() async {
    await setExpensesFromDB();
    print("Refetched notes");
  }

  openExpenseToRead(ExpensesModel expenseData) async {
    setState(() {
      headerShouldHide = true;
    });
    await Future.delayed(Duration(milliseconds: 230), () {});
    Navigator.push(
        context,
        FadeRoute(
            page: ViewExpensePage(
                triggerRefetch: refetchExpensesFromDB,
                currentExpense: expenseData)));
    await Future.delayed(Duration(milliseconds: 300), () {});

    setState(() {
      headerShouldHide = false;
    });
  }
}
