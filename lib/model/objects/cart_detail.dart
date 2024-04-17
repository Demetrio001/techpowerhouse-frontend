import 'cards.dart';

class CartDetail {
  final int id;
  final Cards card;
  final double price;
  int quantity;
  double subTotal;

  CartDetail({
    required this.id,
    required this.card,
    required this.price,
    required this.quantity,
    required this.subTotal,
  });

  factory CartDetail.fromJson(Map<String, dynamic> json) {
    return CartDetail(
      id: json['id'],
      card: Cards.fromJson(json['card']),
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      subTotal: json['subTotal'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card': card.toJson(),
      'price': price,
      'quantity': quantity,
      'subTotal': subTotal,
    };
  }

  @override
  String toString() {
    return 'CartDetail{id: $id, card: $card, price: $price, quantity: $quantity, subTotal: $subTotal}';
  }

}
