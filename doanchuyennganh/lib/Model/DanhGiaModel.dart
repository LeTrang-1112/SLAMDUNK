class DanhGia {
  final String soDienThoai;
  final String ngayDanhGia;
  final int sao;
  final String noiDung;
  final String? chiTietDonHang;

  DanhGia({
    required this.soDienThoai,
    required this.ngayDanhGia,
    required this.sao,
    required this.noiDung,
    this.chiTietDonHang,
  });

  factory DanhGia.fromJson(Map<String, dynamic> json) {
    return DanhGia(
      soDienThoai: json['donHang']?['soDienThoai'] ?? '',
      ngayDanhGia: json['ngayDanhGia'] ?? '',
      sao: json['sao'] ?? 0,
      noiDung: json['noiDung'] ?? '',
      chiTietDonHang: json['chiTietDonHang']?['sanPham']?['imageUrl'],
    );
  }
}
