

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:techpowerhouse/UI/widgets/error_dialog.dart';
import 'package:techpowerhouse/model/model.dart';
import 'package:techpowerhouse/model/objects/registration_request.dart';
import 'package:techpowerhouse/model/supports/constants.dart';

class Registrazione extends StatelessWidget {
  Registrazione({super.key});
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool checkTextFields() {
    return (firstNameController.text!="" && lastNameController.text!=""
        && emailController.text!="" && addressController.text!=""
        && phoneController.text!="" && passwordController.text!="");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgroup.jpg'),
            fit: BoxFit.cover,
            opacity: 0.9,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlurryContainer(
              blur: 20,
              width: 450,
              elevation: 10,
              color: Colors.transparent,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(20)
            ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    Constants.appName,
                    style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Developed by: Demetrio Romeo",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 25)),
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
                          hintStyle: TextStyle(color: Colors.white)
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
                          hintStyle: TextStyle(color: Colors.white)
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
                          hintStyle: TextStyle(color: Colors.white)
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
                          hintStyle: TextStyle(color: Colors.white)
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
                          hintStyle: TextStyle(color: Colors.white)
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
                          hintStyle: TextStyle(color: Colors.white)
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
                      if(checkTextFields()) {
                        RegistrationRequest r = RegistrationRequest(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            email: emailController.text,
                            address: addressController.text,
                            phone: phoneController.text,
                            password: passwordController.text
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
    );
  }

}
