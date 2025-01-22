class ForgotPasswordRequestModel {
  final String email;
  final String soDienThoai;
  final String matKhauMoi;

  ForgotPasswordRequestModel({
    required this.email,
    required this.soDienThoai,
    required this.matKhauMoi,
  });

  Map<String, dynamic> toJson() {
    return {
      "Email": email,
      "SoDienThoai": soDienThoai,
      "MatKhauMoi": matKhauMoi,
    };
  }
}
