import 'NguoiDungModel.dart';

class LoginResponseModel {
  final String message;
  final NguoiDung? nguoiDung;
  final bool isAdmin; // Đổi thành bool

  LoginResponseModel({
    required this.message,
    this.nguoiDung,
    required this.isAdmin,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'],
      nguoiDung: json['nguoiDung'] != null
          ? NguoiDung.fromJson(json['nguoiDung'])
          : null,
      isAdmin:
          json['IsAdmin'] == 1, // Kiểm tra nếu giá trị là 1 thì isAdmin là true
    );
  }
}
