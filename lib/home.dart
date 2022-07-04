import 'package:flutter/material.dart';
import 'package:tubes_app_7/homescrean.dart';
import 'package:tubes_app_7/profil.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final screens = [
    const HomeScreen(),
    const Center(
        child: Text(
      "Search",
      textDirection: TextDirection.ltr,
    )),
    const Center(
        child: Text(
      "News",
      textDirection: TextDirection.ltr,
    )),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Explore'),
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            actions: const [
              Icon(Icons.notifications),
              Padding(padding: EdgeInsets.only(right: 10))
            ],
          ),
          body: screens[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  backgroundColor: Colors.blue,
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  backgroundColor: Colors.red,
                  label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  backgroundColor: Colors.yellow,
                  label: 'Favorite'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  backgroundColor: Colors.green,
                  label: 'Profile'),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          )),
    );
  }
}
