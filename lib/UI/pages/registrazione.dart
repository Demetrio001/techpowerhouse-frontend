import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:techpowerhouse/UI/widgets/error_dialog.dart';
import 'package:techpowerhouse/model/model.dart';
import 'package:techpowerhouse/model/objects/registration_request.dart';
import 'package:techpowerhouse/model/supports/constants.dart';

class Registrazione extends StatelessWidget {
  Registrazione({Key? key}) : super(key: key);

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool checkTextFields() {
    return (firstNameController.text != "" &&
        lastNameController.text != "" &&
        emailController.text != "" &&
        addressController.text != "" &&
        phoneController.text != "" &&
        passwordController.text != "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 450,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person_add,
                        size: 80,
                        color: Colors.green,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      const Text(
                        Constants.appName,
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Developed by: DemetrioRomeo",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 325,
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: firstNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nome',
                            hintText: 'Nome',
                            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      SizedBox(
                        width: 325,
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: lastNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Cognome',
                            hintText: 'Cognome',
                            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      SizedBox(
                        width: 325,
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: addressController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Indirizzo',
                            hintText: 'Indirizzo',
                            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      SizedBox(
                        width: 325,
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: phoneController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Telefono',
                            hintText: 'Telefono',
                            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      SizedBox(
                        width: 325,
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText: 'Email',
                            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      SizedBox(
                        width: 325,
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: passwordController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            hintText: 'Password',
                            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          obscureText: true,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () async {
                          if (checkTextFields()) {
                            RegistrationRequest r = RegistrationRequest(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              email: emailController.text,
                              address: addressController.text,
                              phone: phoneController.text,
                              password: passwordController.text,
                            );
                            try {
                              await Model.sharedInstance.register(r);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Registrazione effettuata con successo. Effettua il login.'),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                ),
                              );
                            }
                          } else {
                            showErrorDialog(context, "Inserisci i dati mancanti");
                          }
                        },
                        child: const Text(
                          "Registrati",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Image.asset(
              'images/logo.png',
              width: 125,
              height: 125,
            ),
          ),
        ],
      ),
    );
  }
}
