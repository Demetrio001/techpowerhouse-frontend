import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:techpowerhouse/model/objects/authentication_data.dart';
import 'package:techpowerhouse/model/supports/constants.dart';
import 'package:techpowerhouse/model/supports/login_result.dart';
import 'objects/cards.dart';
import 'objects/cart_detail.dart';
import 'objects/order.dart';
import 'objects/registration_request.dart';
import 'objects/user.dart';

class Model {
  static Model sharedInstance = Model();
  AuthenticationData? _authenticationData;
  String? _token;


  //Metodo per la registrazione
  Future<void> register(RegistrationRequest registrationRequest) async {
    // creazione string url e una request body attraverso una registration request e si formatta la richiesta in formato json
    const String url = "${Constants.addressStoreServer}/register";
    final Map<String, dynamic> requestBody = registrationRequest.toJson();
    // tipo di response (post) e costruizione dell'istanza
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      // controllo dello status della response, se diverso da 201=> created allora lancia l'eccezione
      if (response.statusCode != 201) {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  //Metodo per il login
  Future<LoginResult> login(String email, String password) async {
    // creazione body dell'istanza di response con i parametri del login, la password sará la chiave per l'autenticazione
    final Map<String, String> body = {
      'grant_type': 'password',
      'client_id': Constants.clientId,
      'username': email,
      'password': password,

    };
    // tipo di response (post) e costruizione dell'istanza
    final response = await http.post(
      Uri.parse(Constants.addressAuthenticationServer+Constants.requestLogin),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );
    print(response.statusCode);
    // controllo dello status della response, se è 200=>OK allora si salva il bearer token e l/ authentication data convertendolo dal formato json
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      _authenticationData = AuthenticationData.fromJson(data);
      _token = _authenticationData!.accessToken;
      // setta un timer per il refresh del token automatico
      Timer.periodic(
          Duration(seconds: (_authenticationData!.expiresIn - 60)), (
          Timer t) {
        _refreshToken();
      });
      return LoginResult.logged;
    }
    // se lo status è 401=> Bad Request allora lancia l'errore che sono sbagliate le credenziali, altrimenti errore sconosciuto
    else if (response.statusCode == 401){
      return LoginResult.wrongCredentials;
    }
    else {
      return LoginResult.unknownError;
    }
  }

  // controllo se l'utente è logato tramite l'esistenza del token
  bool isLogged() {
    return _token != null;
  }

  // Metodo di refresh del token dopo la scadenza del timer
  Future<bool> _refreshToken() async {
    try {
      Map<String, String> body = {
        'grant_type': 'refresh_token',
        'client_id': Constants.clientId,
        'refresh_token': _authenticationData!.refreshToken
      };
      final response = await http.post(
        Uri.parse(Constants.addressAuthenticationServer+Constants.requestLogin),
        headers: {'Content-Type': 'application/x-www-form-urlencoded',},
        body: body,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _authenticationData = AuthenticationData.fromJson(data);
        _token = _authenticationData!.accessToken;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  //Metodo di logOut
  Future<bool> logOut() async {
    try{
      // costruzione dell'istanza response
      Map<String, String> params = {};
      _token = null;
      params["client_id"] = Constants.clientId;
      params["refresh_token"] = _authenticationData!.refreshToken;
      final response = await http.post(
        Uri.parse(Constants.addressAuthenticationServer+Constants.requestLogout),
        headers: {'Content-Type': 'application/x-www-form-urlencoded',},
        body: params
      );
      // verifica che lo status code è 204=> No Content
      return (response.statusCode == 204);
    }
    catch (e) {
      return false;
    }
  }

  // Metodo per ottenere tutte le cards salvate nel db con impaginazione e ordinate in base all'id
  Future<List<Cards>> getCards({int pageNumber = 0, int pageSize = 10, String sortBy = 'id',}) async {
    // creazione uri per ottenere tutte le carte
    final Uri uri = Uri.parse('${Constants
        .addressStoreServer}/cards?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sortBy');
    // creazione della response e verifica dello status di questu'ultima
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        // creazione della lista delle cards
        List<dynamic> data = json.decode(response.body);
        List<Cards> cards = data.map((item) => Cards.fromJson(item)).toList();
        return cards;
        // cards assenti 404=> Not Found oppure non sono state trove o errore sconosciuto
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Metodo invocato quando si cerca una card dal titolo
  Future<List<Cards>> getCardsByTitle(String title, {int pageNumber = 0, int pageSize = 10, String sortBy = 'id'}) async {
    final Uri uri = Uri.parse('${Constants.addressStoreServer}/cards/name?name=$title&pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sortBy');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Cards> cards = data.map((item) => Cards.fromJson(item)).toList();
        return cards;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Metodo per recuperare un profilo
  Future<User> fetchUserProfile() async {
    final url = Uri.parse('${Constants.addressStoreServer}/profile');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );
      if (response.statusCode == 200) {
        // Se lo stato della risposta è 200, il profilo utente è stato recuperato con successo.
        final jsonData = json.decode(response.body);
        final user = User.fromJson(jsonData);
        return user;
      } else if (response.statusCode == 404) {
        // Se lo stato della risposta è 404, il profilo non è stato trovato.
        throw Exception('User not found');
      } else {
        // Se lo stato della risposta non è né 200 né 404, si è verificato un errore.
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Metodo per ottenere gli ordini di un utente
  Future<List<Order>> getUserOrders() async {
    // Definizione dell'URL per recuperare gli ordini dell'utente.
    final url = Uri.parse('${Constants.addressStoreServer}/profile/orders');
    try {
      // costruzione della richiesta HTTP GET per recuperare gli ordini dell'utente.
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token', // Includi il token di autenticazione nell'intestazione.
        },
      );
      // gestione della risposta in base allo stato HTTP.
      if (response.statusCode == 200) {
        // se lo stato della risposta è 200, gli ordini sono stati recuperati con successo.
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Order> orders = jsonData.map((data) =>
            Order.fromJson(data))
            .toList();
        return orders; // restituisce la lista degli ordini.
      } else if (response.statusCode == 404) {
        // se lo stato della risposta è 404, nessun ordine è stato trovato.
        throw Exception('No orders found');
      } else {
        // se lo stato della risposta non è né 200 né 404, si è verificato un errore.
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Metodo della ricerca avanzata con uno o più parametri
  Future<List<Cards>> advancedSearch({
    // definizione dei parametri della richiesta
    String name = "", String creator = "",
    String publisher = "", String category = "",
    int pageNumber = 0, int pageSize = 10, String sortBy = 'id',
  }) async {
    // costruzione delle query con i parametri
    final Map<String, String> queryParams = {
      'name': name,
      'creator': creator,
      'publisher': publisher,
      'category': category,
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
      'sortBy': sortBy,
    };
    // creazione della richiesta HTTP GET
    final Uri uri = Uri.parse(
        '${Constants.addressStoreServer}/cards/advancedSearch').replace(
        queryParameters: queryParams);
    try {
      final response = await http.get(uri);
      print(response);
      // se la richiesta è andata a buon fine allora resituisce una lista cards
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Cards> cards = data.map((item) => Cards.fromJson(item)).toList();
        return cards;
        // se la richiesta non ha trovato nessuna card allora restituisce un 404 Not Found con una lista vuota
      } else if (response.statusCode == 404) {
        return [];
      }
      else {
        // tutti gli altri errori mostreranno questo
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      throw Exception(e);
    }
  }


  // Metodo per prendere i cart details associati ad uno specifico utente
  Future<List<CartDetail>> getCartDetails() async {
    // definizione dell'URL per recuperare i dettagli del carrello dell'utente.
    final url = Uri.parse('${Constants.addressStoreServer}/profile/cart');
    try {
      // creazione della richiesta HTTP GET per recuperare i cart details dell'utente.
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token', // include il token di autenticazione nell'intestazione perché è un metodo che richiede l'autenticazione.
        },
      );
      // gestione della risposta in base allo stato HTTP.
      if (response.statusCode == 200) {
        // Se lo stato della risposta è 200, i dettagli del carrello sono stati recuperati con successo.
        final List<dynamic> jsonData = json.decode(response.body);
        final List<CartDetail> cartDetails = jsonData.map((data) =>
            CartDetail.fromJson(data)).toList();
        return cartDetails; // Restituisce la lista dei dettagli del carrello.
      } else {
        // Se lo stato della risposta non è 200, si è verificato un errore.
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  //Metodo che svuota il carrello dal contenuto
  Future<void> clearCart() async {
    final url = Uri.parse('${Constants.addressStoreServer}/profile/cart');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Metodo che rimuove un prodotto dal carrello tramite l'id del prodotto
  Future<void> removeItem(int itemId) async {
    final url = Uri.parse(
        '${Constants.addressStoreServer}/profile/cart/$itemId');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Metodo che aggiorna la quantitá di un prodotto nel carrello
  Future<void> updateItemQuantity(int itemId, int quantity) async {
    final url = Uri.parse(
        '${Constants.addressStoreServer}/profile/cart/$itemId');
    final Map<String, String> body = {
      'quantity': quantity.toString(),
    };
    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
        body: body
      );
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Metodo per l'aggiunta di un oggetto al carrello
  Future<void> addToCart(int cardId) async {
    final url = Uri.parse('${Constants.addressStoreServer}/profile/cart');
    final Map<String, String> body = {
      'cardId': cardId.toString(),
    };
    try {
      final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $_token',
          },
          body: body
      );
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Metodo di checkout per concludere l'ordine
  Future<void> checkout(List<CartDetail> cartDetails) async {
    final url = Uri.parse("${Constants.addressStoreServer}/profile/cart/checkout");

    try {
      final body = jsonEncode(cartDetails.map((detail) => detail.toJson()).toList());
      final response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode != 201) {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }


}