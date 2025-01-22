import 'SanPhamModel.dart';

class SanPhamKhuyenMai {
  int sanPhamKMId;
  int sanPhamId;
  int khuyenMaiId;

  // Constructor
  SanPhamKhuyenMai({
    required this.sanPhamKMId,
    required this.sanPhamId,
    required this.khuyenMaiId,
  });

  // Convert from JSON
  factory SanPhamKhuyenMai.fromJson(Map<String, dynamic> json) {
    return SanPhamKhuyenMai(
      sanPhamKMId: json['SanPhamKMId'],
      sanPhamId: json['SanPhamId'],
      khuyenMaiId: json['KhuyenMaiId'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'SanPhamKMId': sanPhamKMId,
      'SanPhamId': sanPhamId,
      'KhuyenMaiId': khuyenMaiId,
    };
  }

  // Quan hệ với bảng SanPham (Một sản phẩm có thể có nhiều khuyến mãi)
  late SanPham sanPham;

  // Quan hệ với bảng KhuyenMai (Một khuyến mãi có thể áp dụng cho nhiều sản phẩm)
  late SanPhamKhuyenMai khuyenMai;
}