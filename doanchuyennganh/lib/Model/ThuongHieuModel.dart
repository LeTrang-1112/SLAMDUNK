import 'SanPhamModel.dart';

class ThuongHieu {
  int thuongHieuId;
  String tenThuongHieu;
  String moTa;
  String quocGia;
  String ngayTao;

  // Constructor
  ThuongHieu({
    required this.thuongHieuId,
    required this.tenThuongHieu,
    required this.moTa,
    required this.quocGia,
    required this.ngayTao,
  });

  // Convert from JSON
  factory ThuongHieu.fromJson(Map<String, dynamic> json) {
    return ThuongHieu(
      thuongHieuId: json['ThuongHieuId'],
      tenThuongHieu: json['TenThuongHieu'],
      moTa: json['MoTa'],
      quocGia: json['QuocGia'],
      ngayTao: json['NgayTao'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'ThuongHieuId': thuongHieuId,
      'TenThuongHieu': tenThuongHieu,
      'MoTa': moTa,
      'QuocGia': quocGia,
      'NgayTao': ngayTao,
    };
  }

  // Quan hệ với bảng SanPham (Một thương hiệu có thể có nhiều sản phẩm)
  late List<SanPham> sanPhams;
}