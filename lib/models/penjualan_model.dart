class PenjualanModel {
  final int? penjualanId;
  final DateTime tanggalPenjualan;
  final int? totalHarga;
  final int? pelangganId;
  final String? pembayaran;
  final String? kodeUnik;

  PenjualanModel({
    this.penjualanId,
    required this.tanggalPenjualan,
    this.totalHarga,
    this.pelangganId,
    this.pembayaran,
    this.kodeUnik,
  });

  factory PenjualanModel.fromJson(Map<String, dynamic> json) {
    return PenjualanModel(
      penjualanId: json['penjualanid'] as int?,
      tanggalPenjualan: DateTime.parse(json['tanggalpenjualan'] as String),
      totalHarga: json['totalharga'] as int?,
      pelangganId: json['pelangganid'] as int?,
      pembayaran: json['pembayaran'] as String?,
      kodeUnik: json['kode_unik'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'penjualanid': penjualanId,
      'tanggalpenjualan': tanggalPenjualan.toIso8601String(),
      'totalharga': totalHarga,
      'pelangganid': pelangganId,
      'pembayaran': pembayaran,
      'kode_unik': kodeUnik,
    };
  }
}
