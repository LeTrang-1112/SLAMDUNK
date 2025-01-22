class DonHang {
  int donHangId;
  int nguoiDungId;
  double tongTien;
  String phuongThucThanhToan;
  String trangThai;
  String diaChiGiaoHang;
  String ghiChu;
  String ngayDatHang;
  String soDienThoai;

  // Constructor
  DonHang({
    required this.donHangId,
    required this.nguoiDungId,
    required this.tongTien,
    required this.phuongThucThanhToan,
    required this.trangThai,
    required this.diaChiGiaoHang,
    required this.ghiChu,
    required this.ngayDatHang,
    required this.soDienThoai,
  });

  // Convert from JSON
  factory DonHang.fromJson(Map<String, dynamic> json) {
    return DonHang(
      donHangId: json['DonHangId'],
      nguoiDungId: json['NguoiDungId'],
      tongTien: json['TongTien'].toDouble(),
      phuongThucThanhToan: json['PhuongThucThanhToan'],
      trangThai: json['TrangThai'],
      diaChiGiaoHang: json['DiaChiGiaoHang'],
      ghiChu: json['GhiChu'],
      ngayDatHang: json['NgayDatHang'],
      soDienThoai: json['SoDienThoai'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'DonHangId': donHangId,
      'NguoiDungId': nguoiDungId,
      'TongTien': tongTien,
      'PhuongThucThanhToan': phuongThucThanhToan,
      'TrangThai': trangThai,
      'DiaChiGiaoHang': diaChiGiaoHang,
      'GhiChu': ghiChu,
      'NgayDatHang': ngayDatHang,
      'SoDienThoai': soDienThoai,
    };
  }
}

class OrderRequestModel {
  final int nguoiDungId;
  final List<OrderItem> sanPhamList;

  OrderRequestModel({required this.nguoiDungId, required this.sanPhamList});

  Map<String, dynamic> toJson() {
    return {
      'NguoiDungId': nguoiDungId,
      'sanPhamList': sanPhamList.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final int sanPhamId;
  final int soLuong;

  OrderItem({required this.sanPhamId, required this.soLuong});

  Map<String, dynamic> toJson() {
    return {
      'SanPhamId': sanPhamId,
      'SoLuong': soLuong,
    };
  }
}

class OrderResponseModel {
  final User user;
  final Order order;

  OrderResponseModel({required this.user, required this.order});

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      user: User.fromJson(json['user']),
      order: Order.fromJson(json['order']),
    );
  }

  get orderItems => null;
}

class User {
  final String name;
  final String? address;
  final String? phone;

  User({required this.name, required this.address, required this.phone});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
    );
  }
}

class Order {
  final double totalPrice;
  final List<OrderItemDetails> items;

  Order({required this.totalPrice, required this.items});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      totalPrice: double.parse(json['total_price'].toString()),
      items: (json['items'] as List)
          .map((item) => OrderItemDetails.fromJson(item))
          .toList(),
    );
  }
}

class OrderItemDetails {
  final int productId;
  final String name;
  final String price;
  int quantity;
  final double totalPrice;
  final String? description;
  final String? image;

  OrderItemDetails({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    required this.description,
    this.image,
  });

  factory OrderItemDetails.fromJson(Map<String, dynamic> json) {
    return OrderItemDetails(
      productId: json['product_id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      totalPrice: double.parse(json['total_price'].toString()),
      description: json['description'],
      image: json['image'],
    );
  }
}

class Order_Item {
  final int sanPhamId;
  final int soLuong;

  Order_Item({required this.sanPhamId, required this.soLuong});

  Map<String, dynamic> toJson() {
    return {
      'SanPhamId': sanPhamId,
      'SoLuong': soLuong,
    };
  }
}

class Order_RequestModel {
  final int? nguoiDungId;
  final List<OrderItem> sanPhamList;
  final String phuongThucThanhToan;
  final String diaChiGiaoHang;
  final String ghiChu;
  final String soDienThoai;
  final String nguoiNhan;

  Order_RequestModel({
    required this.nguoiDungId,
    required this.sanPhamList,
    required this.phuongThucThanhToan,
    required this.diaChiGiaoHang,
    required this.ghiChu,
    required this.soDienThoai,
    required this.nguoiNhan,
  });

  Map<String, dynamic> toJson() {
    return {
      'NguoiDungId': nguoiDungId,
      'sanPhamList': sanPhamList.map((item) => item.toJson()).toList(),
      'PhuongThucThanhToan': phuongThucThanhToan,
      'DiaChiGiaoHang': diaChiGiaoHang,
      'GhiChu': ghiChu,
      'SoDienThoai': soDienThoai,
      'NguoiNhan': nguoiNhan,
    };
  }
}

class Order_ResponseModel {
  final String message;
  final Order order;

  Order_ResponseModel({required this.message, required this.order});

  factory Order_ResponseModel.fromJson(Map<String, dynamic> json) {
    return Order_ResponseModel(
      message: json['message'],
      order: Order.fromJson(json['order']),
    );
  }
}

class DatHang {
  final int orderId;
  final double totalPrice;
  final List<OrderItemDetails> items;

  DatHang(
      {required this.orderId, required this.totalPrice, required this.items});

  factory DatHang.fromJson(Map<String, dynamic> json) {
    return DatHang(
      orderId: json['order_id'],
      totalPrice: double.parse(json['total_price'].toString()),
      items: (json['items'] as List)
          .map((item) => OrderItemDetails.fromJson(item))
          .toList(),
    );
  }
}

class Order_ItemDetails {
  final int sanPhamId;
  final int soLuong;
  final String gia;
  final double totalPrice;

  Order_ItemDetails({
    required this.sanPhamId,
    required this.soLuong,
    required this.gia,
    required this.totalPrice,
  });

  factory Order_ItemDetails.fromJson(Map<String, dynamic> json) {
    return Order_ItemDetails(
      sanPhamId: json['SanPhamId'],
      soLuong: json['SoLuong'],
      gia: json['Gia'],
      totalPrice: double.parse(json['TotalPrice'].toString()),
    );
  }
}
