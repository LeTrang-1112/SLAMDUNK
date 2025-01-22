class RegisterRequestModel {
  final String tenNguoiDung;
  final String matKhau;
  final String email;

  RegisterRequestModel({
    required this.tenNguoiDung,
    required this.matKhau,
    required this.email,
  });

  // Chuyển đổi đối tượng thành JSON để gửi lên server
  Map<String, dynamic> toJson() {
    return {
      'TenNguoiDung': tenNguoiDung,
      'MatKhau': matKhau,
      'Email': email,
    };
  }
}
