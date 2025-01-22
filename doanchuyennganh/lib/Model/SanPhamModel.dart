class SanPham {
  final int sanPhamId;
  final String tenSanPham;
  final String gia;
  final String? hinhAnh;
  final int? giaTriGiam;
  final String ngayTao;

  SanPham({
    required this.sanPhamId,
    required this.tenSanPham,
    required this.gia,
    this.hinhAnh,
    this.giaTriGiam,
    required this.ngayTao,
  });
  factory SanPham.fromJson(Map<String, dynamic> json) {
    return SanPham(
      sanPhamId:
          json['SanPhamId'] ?? 0, // Nếu không có, trả về giá trị mặc định
      tenSanPham: json['TenSanPham'] ?? '', // Nếu không có, trả về chuỗi rỗng
      gia: json['Gia'] ?? '', // Nếu không có, trả về chuỗi rỗng
      hinhAnh: json['HinhAnh'] as String?, // Null-safety
      giaTriGiam: json['GiaTriGiam'] != null ? json['GiaTriGiam'] as int : null,
      ngayTao: json['NgayTao'] ?? '', // Nếu không có, trả về chuỗi rỗng
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SanPhamId': sanPhamId,
      'TenSanPham': tenSanPham,
      'Gia': gia,
      'HinhAnh': hinhAnh,
      'GiaTriGiam': giaTriGiam,
      'NgayTao': ngayTao,
    };
  }
}
