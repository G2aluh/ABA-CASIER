enum ProductCategory {
  game(1, 'Game'),
  musik(2, 'Musik'),
  produktif(3, 'Produktif');

  final int value;
  final String displayName;
  const ProductCategory(this.value, this.displayName);
}

class ProductModel {
  final int? id; // produkid (bigint)
  final String name;
  final int price;
  final String? imageUrl;
  final ProductCategory? category; // ← GANTI JADI ENUM
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
    ProductCategory? cat;
    final catValue = json['kategori_produk'];

    if (catValue != null) {
      // Handle both integer and string representations of the enum
      if (catValue is int) {
        try {
          cat = ProductCategory.values.firstWhere((e) => e.value == catValue);
        } catch (e) {
          // If category value doesn't match any enum, leave cat as null
          cat = null;
        }
      } else if (catValue is String) {
        // Handle string representation
        try {
          cat = ProductCategory.values.firstWhere((e) => e.name == catValue);
        } catch (e) {
          // Try to match by displayName
          try {
            cat = ProductCategory.values.firstWhere(
              (e) => e.displayName == catValue,
            );
          } catch (e) {
            // If category value doesn't match any enum, leave cat as null
            cat = null;
          }
        }
      }
    }

    return ProductModel(
      id: json['produkid'] as int?,
      name: json['namaproduk']?.toString() ?? '',
      price: int.tryParse(json['harga'].toString()) ?? 0,
      imageUrl: json['gambar_url']?.toString(),
      category: cat,
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
      'kategori_produk': category != null
          ? category!.value
          : null, // ← KIRIM ANGKA!
    };
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {
      'namaproduk': name,
      'harga': price,
      'gambar_url': imageUrl,
      'kategori_produk': category != null
          ? category!.value
          : null, // ← ANGKA LAGI
    };
  }

  ProductModel copyWith({
    int? id,
    String? name,
    int? price,
    String? imageUrl,
    ProductCategory? category,
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
