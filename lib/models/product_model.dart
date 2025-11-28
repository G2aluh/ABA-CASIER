class ProductModel {
  final int? id; // produkid (bigint)
  final String name;
  final int price;
  final String? imageUrl;
  final String? category; // Using String instead of enum
  final DateTime? deletedAt;
  final DateTime? recoveryAt;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.category,
    this.deletedAt,
    this.recoveryAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    String? category;
    final catValue = json['kategori_produk'];

    // Handle category as string directly
    if (catValue != null) {
      if (catValue is String) {
        category = catValue;
      } else if (catValue is int) {
        // Convert integer to string representation
        category = catValue.toString();
      }
    }

    return ProductModel(
      id: json['produkid'] as int?,
      name: json['namaproduk']?.toString() ?? '',
      price: int.tryParse(json['harga'].toString()) ?? 0,
      imageUrl: json['gambar_url']?.toString(),
      category: category,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      recoveryAt: json['recovery_at'] != null
          ? DateTime.tryParse(json['recovery_at'])
          : null,
    );
  }

  Map<String, dynamic> toJsonForInsert() {
    return {
      'namaproduk': name,
      'harga': price,
      'gambar_url': imageUrl,
      'kategori_produk': category, // Send string directly
    };
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {
      'namaproduk': name,
      'harga': price,
      'gambar_url': imageUrl,
      'kategori_produk': category, // Send string directly
    };
  }

  ProductModel copyWith({
    int? id,
    String? name,
    int? price,
    String? imageUrl,
    String? category,
    DateTime? deletedAt,
    DateTime? recoveryAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      deletedAt: deletedAt ?? this.deletedAt,
      recoveryAt: recoveryAt ?? this.recoveryAt,
    );
  }
}
