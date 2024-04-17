import 'package:flutter/material.dart';
import 'package:techpowerhouse/UI/pages/risultati_ricerca.dart';
import 'package:blurrycontainer/blurrycontainer.dart';

class RicercaAvanzata extends StatefulWidget {
  const RicercaAvanzata({Key? key}) : super(key: key);

  @override
  State<RicercaAvanzata> createState() => _RicercaAvanzataState();
}

class _RicercaAvanzataState extends State<RicercaAvanzata> {
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController publisherController = TextEditingController();
  TextEditingController creatorController = TextEditingController();
  String orderBy = 'Titolo A-Z';
  bool search = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
      decoration: const BoxDecoration(
      image: DecorationImage(
      image: AssetImage('assets/images/background.jpg'),
      fit: BoxFit.cover,
      opacity: 0.9,
      ),
    ),
      child:Center(
        child: BlurryContainer(
          blur: 20,
          width: 450,
          elevation: 10,
          color: Colors.transparent,
          padding: const EdgeInsets.all(8),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Text(
                    "Inserisci uno o più filtri di ricerca!",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Titolo',
                        hintText: 'Titolo',
                        labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                        prefixIcon: IconButton(
                          onPressed: () {
                            titleController.clear();
                          },
                          icon: Icon(Icons.clear),
                          iconSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: creatorController,
                      decoration: InputDecoration(
                        labelText: 'Creatore',
                        hintText: 'Creatore',
                        labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                        prefixIcon: IconButton(
                          onPressed: () {
                            creatorController.clear();
                          },
                          icon: Icon(Icons.clear),
                          iconSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: publisherController,
                      decoration: InputDecoration(
                        labelText: 'Produttore',
                        hintText: 'Produttore',
                        border: OutlineInputBorder(),
                          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: IconButton(
                          onPressed: () {
                            publisherController.clear();
                          },
                          icon: Icon(Icons.clear),
                          iconSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Ordina per:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                DropdownButton<String>(
                  dropdownColor: Colors.transparent,
                  value: orderBy,
                  style: TextStyle(color: Colors.white),
                  onChanged: (String? newValue) {
                    setState(() {
                      orderBy = newValue!;
                    });
                  },
                  items: <String>[
                    'Titolo A-Z',
                    'Titolo Z-A',
                    'Prezzo crescente',
                    'Prezzo decrescente',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RisultatiRicerca(
                            titleController.text,
                            creatorController.text,
                            publisherController.text,
                            categoryController.text,
                            orderBy
                        )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      "Cerca",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
