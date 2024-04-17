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

  Future<void> register(RegistrationRequest registrationRequest) async {
    const String url = "${Constants.addressStoreServer}/register";
    final Map<String, dynamic> requestBody = registrationRequest.toJson();
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode != 201) {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<LoginResult> login(String email, String password) async {
    final Map<String, String> body = {
      'grant_type': 'password',
      'client_id': Constants.clientId,
      'username': email,
      'password': password,

    };
    final response = await http.post(
      Uri.parse(Constants.addressAuthenticationServer+Constants.requestLogin),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      _authenticationData = AuthenticationData.fromJson(data);
      _token = _authenticationData!.accessToken;
      Timer.periodic(
          Duration(seconds: (_authenticationData!.expiresIn - 60)), (
          Timer t) {
        _refreshToken();
      });
      return LoginResult.logged;
    }
    else if (response.statusCode == 401){
      return LoginResult.wrongCredentials;
    }
    else {
      return LoginResult.unknownError;
    }
  }

  bool isLogged() {
    return _token != null;
  }

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

  Future<bool> logOut() async {
    try{
      Map<String, String> params = {};
      _token = null;
      params["client_id"] = Constants.clientId;
      params["refresh_token"] = _authenticationData!.refreshToken;
      final response = await http.post(
        Uri.parse(Constants.addressAuthenticationServer+Constants.requestLogout),
        headers: {'Content-Type': 'application/x-www-form-urlencoded',},
        body: params
      );
      return (response.statusCode == 204);
    }
    catch (e) {
      return false;
    }
  }

  Future<List<Cards>> getCards({int pageNumber = 0, int pageSize = 10, String sortBy = 'id',}) async {
    final Uri uri = Uri.parse('${Constants
        .addressStoreServer}/cards?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sortBy');
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

  Future<List<Cards>> getCardsByTitle(String title, {int pageNumber = 0, int pageSize = 10, String sortBy = 'id'}) async {
    final Uri uri = Uri.parse('${Constants.addressStoreServer}/cards/title?title=$title&pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sortBy');
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
        final jsonData = json.decode(response.body);
        final user = User.fromJson(jsonData);
        return user;
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Order>> getUserOrders() async {
    final url = Uri.parse('${Constants.addressStoreServer}/profile/orders');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Order> orders = jsonData.map((data) =>
            Order.fromJson(data))
            .toList();
        return orders;
      } else if (response.statusCode == 404) {
        throw Exception('No orders found');
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Cards>> advancedSearch({
    String name = "", String creator = "",
    String publisher = "", String category = "",
    int pageNumber = 0, int pageSize = 10, String sortBy = 'id',
  }) async {
    final Map<String, String> queryParams = {
      'name': name,
      'creator': creator,
      'publisher': publisher,
      'category': category,
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
      'sortBy': sortBy,
    };
    final Uri uri = Uri.parse(
        '${Constants.addressStoreServer}/cards/advancedSearch').replace(
        queryParameters: queryParams);
    try {
      final response = await http.get(uri);
      print(response);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Cards> cards = data.map((item) => Cards.fromJson(item)).toList();
        return cards;
      } else if (response.statusCode == 404) {
        return [];
      }
      else {
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      throw Exception(e);
    }
  }


  Future<List<CartDetail>> getCartDetails() async {
    final url = Uri.parse('${Constants.addressStoreServer}/profile/cart');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<CartDetail> cartDetails = jsonData.map((data) =>
            CartDetail.fromJson(data)).toList();
        return cartDetails;
      }
      else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

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