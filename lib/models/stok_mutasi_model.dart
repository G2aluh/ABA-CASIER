class StokMutasiModel {
  final int? id;
  final int? produkId;
  final int qty;
  final String? jenisMutasi;
  final String? keterangan;
  final DateTime? createdAt;

  StokMutasiModel({
    this.id,
    this.produkId,
    required this.qty,
    this.jenisMutasi,
    this.keterangan,
    this.createdAt,
  });

  factory StokMutasiModel.fromJson(Map<String, dynamic> json) {
    return StokMutasiModel(
      id: json['id'] as int?,
      produkId: json['produk_id'] as int?,
      qty: json['qty'] as int,
      jenisMutasi: json['jenis_mutasi'] as String?,
      keterangan: json['keterangan'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'produk_id': produkId,
      'qty': qty,
      'jenis_mutasi': jenisMutasi,
      'keterangan': keterangan,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
