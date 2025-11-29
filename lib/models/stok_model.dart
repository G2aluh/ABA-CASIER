class StokModel {
  final int? id;
  final int? produkId;
  final int jumlahBarang;
  final DateTime? updatedAt;

  StokModel({
    this.id,
    this.produkId,
    required this.jumlahBarang,
    this.updatedAt,
  });

  factory StokModel.fromJson(Map<String, dynamic> json) {
    return StokModel(
      id: json['id'] as int?,
      produkId: json['produk_id'] as int?,
      jumlahBarang: json['jumlah_barang'] as int? ?? 0,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'produk_id': produkId,
      'jumlah_barang': jumlahBarang,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
