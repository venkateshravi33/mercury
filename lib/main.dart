import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int curIndex = 0;
  List bottomNavigationBarPages = [
    ///Home Page.
    const HomePage(),

    ///Place holder for Cart page.
    Container(
      color: Colors.red,
      child: const Center(
        child: Text('Index 1: Cart'),
      ),
    ),

    ///Place holder for Account page.
    Container(
      color: Colors.blue,
      child: const Center(
        child: Text('Index 2: Account'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: myBottomNavigationBar(),
        body: bottomNavigationBarPages.elementAt(curIndex),
      ),
    );
  }

  Widget myBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      currentIndex: curIndex,
      onTap: (index) {
        setState(() {
          curIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Account',
        ),
      ],
    );
  }
}
