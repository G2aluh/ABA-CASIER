class ProductModel {
  final String id;
  final String name;
  final int price;
  final String? imageUrl;
  final String? category;
  final DateTime? deletedAt;
  final DateTime? recoveryAt;
  final int? stock;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.category,
    this.deletedAt,
    this.recoveryAt,
    this.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['produkid']?.toString() ?? '',
      name: json['namaproduk'] ?? '',
      price: json['harga'] ?? 0,
      imageUrl: json['gambar_url'],
      category: json['kategori_produk'],
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      recoveryAt: json['recovery_at'] != null
          ? DateTime.parse(json['recovery_at'])
          : null,
      stock: json['stock'], // This will come from joined stok table
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produkid': id,
      'namaproduk': name,
      'harga': price,
      'gambar_url': imageUrl,
      'kategori_produk': category,
      'deleted_at': deletedAt?.toIso8601String(),
      'recovery_at': recoveryAt?.toIso8601String(),
    };
  }
}
