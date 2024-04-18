import 'dart:ui';
import 'package:flutter/material.dart';
import '../../model/model.dart';
import '../../model/objects/cards.dart';
import 'error_dialog.dart';

class BoxCard extends StatelessWidget {
  final Cards c;

  const BoxCard({Key? key, required this.c}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipRRect(
        //borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.70),

            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  c.name,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: Center(
                    child: Image.asset(
                      c.urlImmagine,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Produttore: ${c.publisher}',
                        style: TextStyle(color: Colors.white70,fontSize: 15,fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Quantità: ${c.quantity}',
                        style: TextStyle(color: Colors.white70,fontSize: 15,fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Prezzo: ${c.price}€',
                        style: TextStyle(color: Colors.white70,fontSize: 15,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (Model.sharedInstance.isLogged()) {
                                try {
                                  await Model.sharedInstance.addToCart(c.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 1),
                                      content: Text("Articolo aggiunto al carrello"),
                                    ),
                                  );
                                } catch (e) {
                                  showErrorDialog(context, e.toString());
                                }
                              } else {
                                showErrorDialog(context,
                                    "Accedi o registrati per acquistare"
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor: Colors.green,
                            ),
                            child: const Text(
                              'Aggiungi al carrello',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}