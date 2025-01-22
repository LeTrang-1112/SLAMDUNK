import 'package:doanchuyennganh/Model/SanPhamModel.dart';

class DanhGia {
  int danhGiaId;
  int donHangId;
  String? noiDung;
  int sao;
  String ngayDanhGia;
  int ctDhId;
  ChiTietDonHang chiTietDonHang;
  DonHang donHang;

  DanhGia({
    required this.danhGiaId,
    required this.donHangId,
    this.noiDung,
    required this.sao,
    required this.ngayDanhGia,
    required this.ctDhId,
    required this.chiTietDonHang,
    required this.donHang,
  });

  factory DanhGia.fromJson(Map<String, dynamic> json) {
    return DanhGia(
      danhGiaId: json['DanhGiaId'],
      donHangId: json['DonHangId'],
      noiDung: json['NoiDung'],
      sao: json['Sao'],
      ngayDanhGia: json['NgayDanhGia'],
      ctDhId: json['CTDHId'],
      chiTietDonHang: ChiTietDonHang.fromJson(json['chi_tiet_don_hang']),
      donHang: DonHang.fromJson(json['don_hang']),
    );
  }
}

class ChiTietDonHang {
  int ctDhId;
  int donHangId;
  int sanPhamId;
  int soLuong;
  String gia;
  SanPham sanPham;

  ChiTietDonHang({
    required this.ctDhId,
    required this.donHangId,
    required this.sanPhamId,
    required this.soLuong,
    required this.gia,
    required this.sanPham,
  });

  factory ChiTietDonHang.fromJson(Map<String, dynamic> json) {
    return ChiTietDonHang(
      ctDhId: json['CTDHId'],
      donHangId: json['DonHangId'],
      sanPhamId: json['SanPhamId'],
      soLuong: json['SoLuong'],
      gia: json['Gia'],
      sanPham: SanPham.fromJson(json['san_pham']),
    );
  }
}

class DonHang {
  int donHangId;
  int nguoiDungId;
  String tongTien;
  String phuongThucThanhToan;
  String trangThai;
  String diaChiGiaoHang;
  String? ghiChu;
  String ngayDatHang;
  String soDienThoai;
  String nguoiNhan;

  DonHang({
    required this.donHangId,
    required this.nguoiDungId,
    required this.tongTien,
    required this.phuongThucThanhToan,
    required this.trangThai,
    required this.diaChiGiaoHang,
    this.ghiChu,
    required this.ngayDatHang,
    required this.soDienThoai,
    required this.nguoiNhan,
  });

  factory DonHang.fromJson(Map<String, dynamic> json) {
    return DonHang(
      donHangId: json['DonHangId'],
      nguoiDungId: json['NguoiDungId'] ?? 0,
      tongTien: json['TongTien'] != null
          ? json['TongTien']
          : null, // Xử lý trường hợp null
      phuongThucThanhToan:
          json['PhuongThucThanhToan'] ?? '', // Default empty string nếu null
      trangThai: json['TrangThai'] ?? '', // Default empty string nếu null
      diaChiGiaoHang:
          json['DiaChiGiaoHang'] ?? '', // Default empty string nếu null
      ghiChu: json['GhiChu'], // Nullable, giữ nguyên
      ngayDatHang: json['NgayDatHang'] ?? '', // Default empty string nếu null
      soDienThoai: json['SoDienThoai'] ?? '', // Default empty string nếu null
      nguoiNhan: json['NguoiNhan'] ?? '', // Default empty string nếu null
    );
  }
}
