
import 'package:flutter/material.dart';
import 'package:techpowerhouse/UI/pages/registrazione.dart';
import 'package:techpowerhouse/UI/pages/ricerca_avanzata.dart';
import 'package:techpowerhouse/model/supports/constants.dart';

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
      backgroundColor: Colors.grey.shade600,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade600,
        title: const Text(
          Constants.appName,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 65,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                _selectPage(0);
                Navigator.pop(context); // Chiudi il Drawer dopo la selezione
              },
            ),
            ListTile(
              title: Text('Ricerca avanzata'),
              onTap: () {
                _selectPage(1);
                Navigator.pop(context); // Chiudi il Drawer dopo la selezione
              },
            ),
            ListTile(
              title: Text('Login'),
              onTap: () {
                _selectPage(2);
                Navigator.pop(context); // Chiudi il Drawer dopo la selezione
              },
            ),
            ListTile(
              title: Text('Registrati'),
              onTap: () {
                _selectPage(3);
                Navigator.pop(context); // Chiudi il Drawer dopo la selezione
              },
            ),
            ListTile(
              title: Text('Carrello'),
              onTap: () {
                _selectPage(4);
                Navigator.pop(context); // Chiudi il Drawer dopo la selezione
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

