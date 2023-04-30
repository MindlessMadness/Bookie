import 'package:bookie/providers/auth.dart';
import 'package:bookie/screens/addABookScreen.dart';
import 'package:bookie/widgets/available.dart';
import 'package:bookie/widgets/your_books.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/reqs.dart';

class Start extends StatefulWidget {
  const Start({super.key});
  static String route = "start";

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  var _selected = 0;
  @override
  Widget build(BuildContext context) {
    var logout = Provider.of<Auth>(context, listen: false).logout;
    return Scaffold(
      floatingActionButton: _selected != 1
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddABook.route);
              },
              backgroundColor: Colors.brown.shade900,
              child: Icon(
                Icons.add,
                color: Theme.of(context).scaffoldBackgroundColor,
              )),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await logout();
                Navigator.of(context).pushReplacementNamed("/");
              },
              icon: Icon(
                Icons.logout,
                color: Colors.brown.shade900,
              ))
        ],
        title: Text(
          "Home",
          style: TextStyle(fontSize: 36, fontFamily: "Veteran"),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              _selected = value;
            });
          },
          currentIndex: _selected,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          selectedIconTheme: IconThemeData(size: 38, color: Colors.white),
          unselectedIconTheme: IconThemeData(size: 30),
          fixedColor: Colors.brown.shade900,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.check,
                  color: Colors.brown.shade600,
                ),
                activeIcon: Icon(
                  Icons.check,
                  color: Colors.brown.shade900,
                ),
                label: "available"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.book,
                  color: Colors.brown.shade600,
                ),
                activeIcon: Icon(
                  Icons.book,
                  color: Colors.brown.shade900,
                ),
                label: "your books"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.list,
                  color: Colors.brown.shade600,
                ),
                activeIcon: Icon(
                  Icons.list,
                  color: Colors.brown.shade900,
                ),
                label: "your requests"),
          ]),
      body: _selected == 0
          ? Available()
          : _selected == 1
              ? YourBooks()
              : Requests(),
    );
  }
}
