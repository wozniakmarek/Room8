import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:room8/screens/chat_screen.dart';
import 'package:room8/screens/profil_screen.dart';
import 'package:room8/screens/respons_screen.dart';
import 'package:room8/screens/shop_screen.dart';

import 'calendar_screen.dart';
import 'expenses_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 3;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    _pages = [
      {
        'page': ResponsScreen(),
        'title': 'Respons',
      },
      {
        'page': CalendarScreen(),
        'title': 'Calendar',
      },
      {
        'page': ChatScreen(),
        'title': 'Chat',
      },
      {
        'page': ShopScreen(),
        'title': 'Shop',
      },
      {
        'page': ExpensesScreen(),
        'title': 'Count',
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ProfilScreen(),
      appBar: AppBar(title: Text('Room8'), actions: [
        Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: Icon(Icons.person),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip),
        ),
      ]),
      body: _pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).focusColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.cleaning_services),
            label: 'Cleaning',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.add_shopping_cart),
            label: 'Shopping',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.attach_money),
            label: 'Expenses',
          ),
        ],
      ),
    );
  }
}
