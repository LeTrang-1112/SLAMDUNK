class ChiTietSanPham {
  final int id;
  final String moTa;
  final String kichThuoc;
  final String chatLieu;
  final String tenThuongHieu;
  final List<HinhAnh> hinhAnhs; // Đổi tên trường thành HinhAnhs

  ChiTietSanPham({
    required this.id,
    required this.moTa,
    required this.kichThuoc,
    required this.chatLieu,
    required this.tenThuongHieu,
    required this.hinhAnhs,
  });

  factory ChiTietSanPham.fromJson(Map<String, dynamic> json) {
    return ChiTietSanPham(
      id: json['SanPhamId'],
      moTa: json['MoTa'],
      kichThuoc: json['KichThuoc'],
      chatLieu: json['ChatLieu'],
      tenThuongHieu: json['TenThuongHieu'],
      hinhAnhs: (json['HinhAnhs'] as List)
          .map((item) => HinhAnh.fromJson(item))
          .toList(),
    );
  }
}

class HinhAnh {
  final String path;

  HinhAnh({required this.path});

  factory HinhAnh.fromJson(Map<String, dynamic> json) {
    return HinhAnh(
      path: json['path'],
    );
  }
}
