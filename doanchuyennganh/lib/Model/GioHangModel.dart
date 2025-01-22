class GioHang {
  int gioHangId;
  int nguoiDungId;
  double tongTien;
  String ngayTao;

  // Constructor
  GioHang({
    required this.gioHangId,
    required this.nguoiDungId,
    required this.tongTien,
    required this.ngayTao,
  });

  // Convert from JSON
  factory GioHang.fromJson(Map<String, dynamic> json) {
    return GioHang(
      gioHangId: json['GioHangId'],
      nguoiDungId: json['NguoiDungId'],
      tongTien: json['TongTien'].toDouble(),
      ngayTao: json['NgayTao'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'GioHangId': gioHangId,
      'NguoiDungId': nguoiDungId,
      'TongTien': tongTien,
      'NgayTao': ngayTao,
    };
  }
}