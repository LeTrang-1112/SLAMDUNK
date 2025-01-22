class HinhAnhSanPham {
  int hinhAnhId;
  int sanPhamId;
  String duongDan;
  String moTa;
  String ngayTao;

  // Constructor
  HinhAnhSanPham({
    required this.hinhAnhId,
    required this.sanPhamId,
    required this.duongDan,
    required this.moTa,
    required this.ngayTao,
  });

  // Convert from JSON
  factory HinhAnhSanPham.fromJson(Map<String, dynamic> json) {
    return HinhAnhSanPham(
      hinhAnhId: json['HinhAnhId'],
      sanPhamId: json['SanPhamId'],
      duongDan: json['DuongDan'],
      moTa: json['MoTa'],
      ngayTao: json['NgayTao'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'HinhAnhId': hinhAnhId,
      'SanPhamId': sanPhamId,
      'DuongDan': duongDan,
      'MoTa': moTa,
      'NgayTao': ngayTao,
    };
  }
}