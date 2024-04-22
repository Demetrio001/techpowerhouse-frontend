import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:techpowerhouse/UI/pages/ordini_utente.dart';
import 'package:techpowerhouse/model/model.dart';
import 'package:techpowerhouse/model/objects/user.dart';
import 'package:techpowerhouse/model/supports/constants.dart';
import 'package:techpowerhouse/model/supports/login_result.dart';

import '../widgets/error_dialog.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLogged = false;
  User? user;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    if (isLogged) {
      fetchUser();
    }
  }

  Future<void> checkLoginStatus() async {
    try {
      bool loggedIn = Model.sharedInstance.isLogged();
      setState(() {
        isLogged = loggedIn;
      });
    } catch (e) {
      throw ('Error checking login status: $e');
    }
  }

  Future<void> handleLogin(void Function(LoginResult) resultCallback) async {
    try {
      final result = await Model.sharedInstance.login(
          emailController.text, passwordController.text);
      resultCallback(result);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Si è verificato un errore. Riprova più tardi.'),
        ),
      );
    }
  }

  Future<void> fetchUser() async {
    try {
      final retrievedUser = await Model.sharedInstance.fetchUserProfile();
      setState(() {
        user = retrievedUser;
      });
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isLogged) {
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
                  padding: const EdgeInsets.all(50.0),
                  child: Container(
                    width: 550,
                    height: 550,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.green,
                        ),
                        const Padding(padding: EdgeInsets.only(top: 15)),
                        const Text(
                          Constants.appName,
                          style: TextStyle(
                            fontSize: 60.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "Developed by: DemetrioRomeo",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 45)),
                        SizedBox(
                          width: 325,
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: emailController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: 'Email',
                              hintText: 'Email',
                              labelStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
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
                              border: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.white, width: 4.0)),
                              labelText: 'Password',
                              hintText: 'Password',
                              labelStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            obscureText: true,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 25)),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(color: Colors.white)),
                          onPressed: () {
                            handleLogin((LoginResult result) {
                              switch (result) {
                                case LoginResult.logged:
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Login effettuato con successo'),
                                    ),
                                  );
                                  fetchUser();
                                  setState(() {
                                    isLogged = true;
                                  });
                                  break;
                                case LoginResult.wrongCredentials:
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Credenziali errate. Riprova.'),
                                    ),
                                  );
                                  break;
                                case LoginResult.unknownError:
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Si è verificato un errore. Riprova più tardi.'),
                                    ),
                                  );
                                  break;
                              }
                            });
                          },
                          child: const Text(
                            "Accedi",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Image.asset(
                'images/logo.png',
                width: 125,
                height: 125,
              ),
            ),
          ],
        ),
      );
    } else {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${user?.firstName} ${user?.lastName}',
                      style: const TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15)),
                    Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person_pin, size: 40, color: Colors.white),
                            const Padding(padding: EdgeInsets.only(top: 8)),
                            Text('Email: ${user?.email}', style: TextStyle(color: Colors.white)),
                            Text('Indirizzo: ${user?.address}', style: TextStyle(color: Colors.white)),
                            Text('Telefono: ${user?.phone}', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const OrdiniUtente(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'I miei ordini',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 8)),
                    ElevatedButton(
                      onPressed: () async {
                        bool loggedOut = await Model.sharedInstance.logOut();
                        if (loggedOut) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Logout effettuato con successo'),
                            ),
                          );
                          setState(() {
                            isLogged = false;
                          });
                        } else {
                          showErrorDialog(context, "Impossibile effettuare il logout. Riprova.");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Esci',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
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

}
