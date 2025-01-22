class ChiTietDonHang {
  final int donHangId;
  final int nguoiDungId;
  final String tongTien;
  final String phuongThucThanhToan;
  final String trangThai;
  final String diaChiGiaoHang;
  final String ghiChu;
  final String ngayDatHang;
  final String soDienThoai;
  final String nguoiNhan;
  final List<ChiTietDonHangItem> chiTietDonHangs;

  ChiTietDonHang({
    required this.donHangId,
    required this.nguoiDungId,
    required this.tongTien,
    required this.phuongThucThanhToan,
    required this.trangThai,
    required this.diaChiGiaoHang,
    required this.ghiChu,
    required this.ngayDatHang,
    required this.soDienThoai,
    required this.nguoiNhan,
    required this.chiTietDonHangs,
  });

  factory ChiTietDonHang.fromJson(Map<String, dynamic> json) {
    var list = json['chi_tiet_don_hangs'] as List;
    List<ChiTietDonHangItem> chiTietList =
        list.map((i) => ChiTietDonHangItem.fromJson(i)).toList();

    return ChiTietDonHang(
      donHangId: json['DonHangId'],
      nguoiDungId: json['NguoiDungId'],
      tongTien: json['TongTien'],
      phuongThucThanhToan: json['PhuongThucThanhToan'],
      trangThai: json['TrangThai'],
      diaChiGiaoHang: json['DiaChiGiaoHang'],
      ghiChu: json['GhiChu'] ?? '',
      ngayDatHang: json['NgayDatHang'],
      soDienThoai: json['SoDienThoai'],
      nguoiNhan: json['NguoiNhan'],
      chiTietDonHangs: chiTietList,
    );
  }
}

class ChiTietDonHangItem {
  final int ctdhId;
  final int donHangId;
  final int sanPhamId;
  final int soLuong;
  final String gia;

  ChiTietDonHangItem({
    required this.ctdhId,
    required this.donHangId,
    required this.sanPhamId,
    required this.soLuong,
    required this.gia,
  });

  factory ChiTietDonHangItem.fromJson(Map<String, dynamic> json) {
    return ChiTietDonHangItem(
      ctdhId: json['CTDHId'],
      donHangId: json['DonHangId'],
      sanPhamId: json['SanPhamId'],
      soLuong: json['SoLuong'],
      gia: json['Gia'],
    );
  }
}
