class DetailPenjualanModel {
  final int? detailId;
  final int penjualanId;
  final int? produkId;
  final int jumlahProduk;
  final int harga;
  final int diskon;
  final int subTotal;
  final String? produk;

  DetailPenjualanModel({
    this.detailId,
    required this.penjualanId,
    this.produkId,
    required this.jumlahProduk,
    required this.harga,
    required this.diskon,
    required this.subTotal,
    this.produk,
  });

  factory DetailPenjualanModel.fromJson(Map<String, dynamic> json) {
    return DetailPenjualanModel(
      detailId: json['detailid'] as int?,
      penjualanId: json['penjualanid'] as int,
      produkId: json['produkid'] as int?,
      jumlahProduk: json['jumlahproduk'] as int,
      harga: json['harga'] as int,
      diskon: json['diskon'] as int? ?? 0,
      subTotal: json['sub_total'] as int? ?? 0,
      produk: json['produk'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detailid': detailId,
      'penjualanid': penjualanId,
      'produkid': produkId,
      'jumlahproduk': jumlahProduk,
      'harga': harga,
      'diskon': diskon,
      'sub_total': subTotal,
      'produk': produk,
    };
  }
}
