class PelangganModel {
  final int? pelangganId;
  final String namaPelanggan;
  final String? alamat;
  final String? noTelp;
  final int? totalPembelian;

  PelangganModel({
    this.pelangganId,
    required this.namaPelanggan,
    this.alamat,
    this.noTelp,
    this.totalPembelian,
  });

  factory PelangganModel.fromJson(Map<String, dynamic> json) {
    return PelangganModel(
      pelangganId: json['pelangganid'] as int?,
      namaPelanggan: json['namapelanggan'] as String,
      alamat: json['alamat'] as String?,
      noTelp: json['notelp'] as String?,
      totalPembelian: json['total_pembelian'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pelangganid': pelangganId,
      'namapelanggan': namaPelanggan,
      'alamat': alamat,
      'notelp': noTelp,
      'total_pembelian': totalPembelian,
    };
  }
}
