import 'package:flutter/material.dart';
import 'package:techpowerhouse/UI/pages/registrazione.dart';
import 'package:techpowerhouse/UI/pages/ricerca_avanzata.dart';
import 'package:techpowerhouse/model/supports/constants.dart';

import '../widgets/menu.dart';
import 'carrello.dart';
import 'home.dart';
import 'login.dart';

class Layout extends StatefulWidget {
  Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Home(),
    RicercaAvanzata(),
    Login(),
    Registrazione(),
    Carrello(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        leading: PopupMenuWidget(
          onMenuItemSelected: (String value) {
            _handlePopupMenuSelection(value);
          },
        ),
        title: Image.asset(
          'images/logo.png',
          width: 70,
          height: 70,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
    );
  }

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handlePopupMenuSelection(String value) {
    switch (value) {
      case 'home':
        _selectPage(0);
        break;
      case 'login':
        _selectPage(2);
        break;
      case 'register':
        _selectPage(3);
        break;
      case 'cart':
        _selectPage(4);
        break;
      case 'search':
        _selectPage(1);
        break;
    }
  }
}
