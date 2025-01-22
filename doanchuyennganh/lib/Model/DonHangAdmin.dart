class DonHangAdmin {
  final int id;
  final String customerName;
  final String totalPrice;
  final String status;
  final String PhuongThucThanhToan;
  final String DiaChiGiaoHang;
  DonHangAdmin({
    required this.id,
    required this.customerName,
    required this.totalPrice,
    required this.status,
    required this.PhuongThucThanhToan,
    required this.DiaChiGiaoHang,
  });

  factory DonHangAdmin.fromJson(Map<String, dynamic> json) {
    return DonHangAdmin(
        id: json['DonHangId'] ?? 0,
        customerName: json['nguoiDung']?['ten'] ?? 'KhachHang',
        totalPrice: json['TongTien'] ?? '0',
        status: json['TrangThai'] ?? 'Chưa xác định',
        PhuongThucThanhToan: json['PhuongThucThanhToan'] ?? '',
        DiaChiGiaoHang: json['DiaChiGiaoHang']);
  }
}
