class NguoiDung {
  int nguoiDungId;
  String tenNguoiDung;
  String email;
  String soDienThoai;
  String matKhau;
  String diaChi;
  String ngayTao;
  bool isAdmin;

  // Constructor
  NguoiDung({
    required this.nguoiDungId,
    required this.tenNguoiDung,
    required this.email,
    required this.soDienThoai,
    required this.matKhau,
    required this.diaChi,
    required this.ngayTao,
    required this.isAdmin,
  });

  // Convert from JSON
  factory NguoiDung.fromJson(Map<String, dynamic> json) {
    return NguoiDung(
      nguoiDungId: json['NguoiDungId'] ?? 0, // Gán giá trị mặc định nếu là null
      tenNguoiDung:
          json['TenNguoiDung'] ?? "", // Gán giá trị mặc định nếu là null
      email: json['Email'] ?? "", // Gán giá trị mặc định nếu là null
      soDienThoai:
          json['SoDienThoai'] ?? "", // Gán giá trị mặc định nếu là null
      matKhau: json['MatKhau'] ?? "", // Gán giá trị mặc định nếu là null
      diaChi: json['DiaChi'] ?? "", // Gán giá trị mặc định nếu là null
      ngayTao: json['NgayTao'] ?? "", // Gán giá trị mặc định nếu là null
      isAdmin: json['IsAdmin'] ==
          1, // Nếu IsAdmin là null hoặc không xác định, giả định là false
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'NguoiDungId': nguoiDungId,
      'TenNguoiDung': tenNguoiDung,
      'Email': email,
      'SoDienThoai': soDienThoai,
      'MatKhau': matKhau,
      'DiaChi': diaChi,
      'NgayTao': ngayTao,
      'IsAdmin': isAdmin ? 1 : 0, // Convert bool to 1 or 0
    };
  }
}
