import 'package:flutter/material.dart';

class PopupMenuWidget extends StatelessWidget {
  final Function(String) onMenuItemSelected;

  const PopupMenuWidget({required this.onMenuItemSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onMenuItemSelected,
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'home',
            child: ListTile(
              leading: Icon(Icons.home_filled),
              title: Text('Home'),
            ),
          ),
          const PopupMenuItem<String>(

            value: 'login',
            child: ListTile(
              leading: Icon(Icons.login),
              title: Text('Login'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'register',
            child: ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Registrazione'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'cart',
            child: ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Carrello'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'search',
            child: ListTile(
              leading: Icon(Icons.search),
              title: Text('Ricerca Avanzata'),
            ),
          ),
        ];
      },
      icon: const Icon(
        Icons.computer,
        color: Colors.green,
      ), // Icona della casetta
    );
  }
}
