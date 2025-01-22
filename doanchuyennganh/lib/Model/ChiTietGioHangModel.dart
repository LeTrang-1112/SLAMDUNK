class ChiTietGioHang {
  int ctGhId;
  int gioHangId;
  int sanPhamId;
  int soLuong;
  double gia;

  // Constructor
  ChiTietGioHang({
    required this.ctGhId,
    required this.gioHangId,
    required this.sanPhamId,
    required this.soLuong,
    required this.gia,
  });

  // Convert from JSON
  factory ChiTietGioHang.fromJson(Map<String, dynamic> json) {
    return ChiTietGioHang(
      ctGhId: json['CTGHId'],
      gioHangId: json['GioHangId'],
      sanPhamId: json['SanPhamId'],
      soLuong: json['SoLuong'],
      gia: json['Gia'].toDouble(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'CTGHId': ctGhId,
      'GioHangId': gioHangId,
      'SanPhamId': sanPhamId,
      'SoLuong': soLuong,
      'Gia': gia,
    };
  }
}

class CartRequest {
  final int sanPhamId;
  final int soLuong;
  final int nguoiDungId;

  CartRequest({
    required this.sanPhamId,
    required this.soLuong,
    required this.nguoiDungId,
  });

  Map<String, dynamic> toJson() {
    return {
      'SanPhamId': sanPhamId,
      'SoLuong': soLuong,
      'NguoiDungId': nguoiDungId,
    };
  }
}

class CartResponse {
  final String message;
  final Cart cart;

  CartResponse({
    required this.message,
    required this.cart,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      message: json['message'],
      cart: Cart.fromJson(json['cart']),
    );
  }
}

class Cart {
  final int gioHangId;
  final int nguoiDungId;
  final String tongTien;
  final String ngayTao;

  Cart({
    required this.gioHangId,
    required this.nguoiDungId,
    required this.tongTien,
    required this.ngayTao,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      gioHangId: json['GioHangId'],
      nguoiDungId: json['NguoiDungId'],
      tongTien: json['TongTien'],
      ngayTao: json['NgayTao'],
    );
  }
}
