import 'package:flutter/material.dart';
import 'package:techpowerhouse/model/model.dart';
import 'package:techpowerhouse/model/objects/order.dart';

class OrdiniUtente extends StatefulWidget {
  const OrdiniUtente({super.key});

  @override
  _OrdiniUtenteState createState() => _OrdiniUtenteState();
}

class _OrdiniUtenteState extends State<OrdiniUtente> {
  List<Order> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserOrders();
  }

  Future<void> fetchUserOrders() async {
    try {
      final retrievedOrders = await Model.sharedInstance.getUserOrders();
      setState(() {
        orders = retrievedOrders;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'I miei ordini',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade800,
      ),
      body:
    Container(
    decoration: const BoxDecoration(
    image: DecorationImage(
    image: AssetImage('assets/images/carrello.jpg'),
    fit: BoxFit.cover,
    opacity: 0.9,
    ),
    ),
    child:isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? const Center(child: Text('Nessun ordine trovato',style: TextStyle(color:Colors.white, fontSize: 30 )))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            color: Colors.grey.shade800,
            margin: const EdgeInsets.all(4.0),
            child: ListTile(
              title: Text('ID Ordine: ${order.id}',style: TextStyle(color:Colors.black, fontSize: 20, fontWeight: FontWeight.bold) ),
              subtitle: Text(
                  'Creato il: ${order.createTime.day}/${order.createTime.month}/${order.createTime.year}', style: TextStyle(color:Colors.black, fontSize: 15 )),
              trailing: Text('Totale: ${order.total.toStringAsFixed(2)}€',
                style: const TextStyle(
                    fontSize: 18,
                    color:Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          );
        },
      ),
    ),);
  }
}