class ProductFields {
  static const List<String> values = [
    id,
    name,
    price,
    isAvailable,
    createdDate,
    eventDate,
    description,
  ];

  static const String tableName = 'products';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String realType = 'REAL NOT NULL';
  static const String intType = 'INTEGER NOT NULL';
  
  static const String id = '_id';
  static const String name = 'name';
  static const String price = 'price';
  static const String isAvailable = 'is_available';
  static const String createdDate = 'created_date';
  static const String eventDate = 'event_date';
  static const String description = 'description';
}

class Product {
  final int? id;
  final String name;
  final double price;
  final bool isAvailable;
  final DateTime createdDate;
  final DateTime eventDate;
  final String description;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.isAvailable,
    required this.createdDate,
    required this.eventDate,
    required this.description,
  });

  Map<String, Object?> toJson() => {
    ProductFields.id: id,
    ProductFields.name: name,
    ProductFields.price: price,
    ProductFields.isAvailable: isAvailable ? 1 : 0,
    ProductFields.createdDate: createdDate.toIso8601String(),
    ProductFields.eventDate: eventDate.toIso8601String(),
    ProductFields.description: description,
  };

  factory Product.fromJson(Map<String, Object?> json) => Product(
    id: json[ProductFields.id] as int?,
    name: json[ProductFields.name] as String,
    price: json[ProductFields.price] as double,
    isAvailable: json[ProductFields.isAvailable] == 1,
    createdDate: DateTime.parse(json[ProductFields.createdDate] as String),
    eventDate: DateTime.parse(json[ProductFields.eventDate] as String),
    description: json[ProductFields.description] as String,
  );

  Product copy({
    int? id,
    String? name,
    double? price,
    bool? isAvailable,
    DateTime? createdDate,
    DateTime? eventDate,
    String? description,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    price: price ?? this.price,
    isAvailable: isAvailable ?? this.isAvailable,
    createdDate: createdDate ?? this.createdDate,
    eventDate: eventDate ?? this.eventDate,
    description: description ?? this.description,
  );
}