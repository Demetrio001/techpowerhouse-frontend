class Cards {
  final int id;
  final String name;
  final String creator;
  final String publisher;
  final String category;
  final double price;
  final int quantity;
  final String urlImmagine;

  Cards({
    required this.id,
    required this.name,
    required this.creator,
    required this.publisher,
    required this.category,
    required this.price,
    required this.quantity,
    required this.urlImmagine,
  });

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
      id: json['id'],
      name: json['name'],
      creator: json['creator'],
      publisher: json['publisher'],
      category: json['category'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      urlImmagine: json['urlImmagine'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'creator': creator,
      'publisher': publisher,
      'category': category,
      'price': price,
      'quantity': quantity,
      'urlImmagine': urlImmagine,
    };
  }
}

