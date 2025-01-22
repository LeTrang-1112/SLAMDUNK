class ChiTietDonHang {
  int ctDhId;
  int donHangId;
  int sanPhamId;
  int soLuong;
  double gia;

  // Constructor
  ChiTietDonHang({
    required this.ctDhId,
    required this.donHangId,
    required this.sanPhamId,
    required this.soLuong,
    required this.gia,
  });

  // Convert from JSON
  factory ChiTietDonHang.fromJson(Map<String, dynamic> json) {
    return ChiTietDonHang(
      ctDhId: json['CTDHId'],
      donHangId: json['DonHangId'],
      sanPhamId: json['SanPhamId'],
      soLuong: json['SoLuong'],
      gia: json['Gia'].toDouble(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'CTDHId': ctDhId,
      'DonHangId': donHangId,
      'SanPhamId': sanPhamId,
      'SoLuong': soLuong,
      'Gia': gia,
    };
  }
}