import 'package:doanchuyennganh/Model/NguoiDungModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doanchuyennganh/config.dart';
import 'package:doanchuyennganh/Model/LoginUserModel.dart';
import 'package:doanchuyennganh/Model/RegisterRequestModel.dart';

class Usercontroller {
  // Lưu trạng thái đăng nhập
// Lưu trạng thái đăng nhập
  Future<void> saveLoginStatus(String nguoiDungId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('NguoiDungId', nguoiDungId);
  }

// Lưu NguoiDungId
  Future<void> saveNguoiDungId(String nguoiDungId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('NguoiDungId', nguoiDungId);
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ??
        false; // Mặc định là false nếu không có giá trị
  }

  // Lưu NguoiDungId

  // Lấy NguoiDungId
  Future<String?> getNguoiDungId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('NguoiDungId'); // Nếu không có, trả về null
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    await prefs.remove('isLoggedIn');
    await prefs.remove('NguoiDungId');
  }

  // Đăng nhập
  Future<LoginResponseModel> login(String email, String matKhau) async {
    try {
      if (email.isEmpty || matKhau.isEmpty) {
        throw Exception("Email hoặc mật khẩu không được để trống");
      }

      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/nguoidung/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'Email': email,
          'MatKhau': matKhau,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Kiểm tra nếu dữ liệu trả về hợp lệ
        if (data['nguoiDung'] != null) {
          final nguoiDungId =
              data['nguoiDung']['NguoiDungId']?.toString() ?? "";
          createCart(data['nguoiDung']['NguoiDungId']);
          // Lưu trạng thái đăng nhập và NguoiDungId
          await saveNguoiDungId(nguoiDungId);
          await saveLoginStatus(nguoiDungId);

          return LoginResponseModel.fromJson(data); // Trả về mô hình đăng nhập
        } else {
          throw Exception("Không có dữ liệu người dùng");
        }
      } else {
        throw Exception("Email hoặc mật khẩu không đúng");
      }
    } catch (e) {
      throw Exception("Lỗi kết nối: $e");
    }
  }

  Future<NguoiDung> register(
      String tenNguoiDung, String matKhau, String email) async {
    try {
      if (tenNguoiDung.isEmpty || matKhau.isEmpty || email.isEmpty) {
        throw Exception("Thông tin đăng ký không được để trống");
      }

      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/nguoidung/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(RegisterRequestModel(
          tenNguoiDung: tenNguoiDung,
          matKhau: matKhau,
          email: email,
        ).toJson()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);

        if (data['message'] == "Đăng ký thành công") {
          // Lưu thông tin người dùng vào SharedPreferences sau khi đăng ký thành công
          String nguoiDungId = data['nguoiDung']['NguoiDungId'].toString();
          await saveNguoiDungId(nguoiDungId);

          return NguoiDung.fromJson(data);
        } else {
          final responseData = json.decode(response.body);
          throw Exception(
              "Lỗi từ server: ${responseData['message'] ?? 'Không rõ nguyên nhân'}");
        }
      } else {
        throw Exception("Có lỗi xảy ra khi đăng ký");
      }
    } catch (e) {
      throw Exception("Lỗi kết nối: $e");
    }
  }

  Future<String> quenMatKhau(String email, String soDienThoai,
      String matKhauMoi, String mkxacnhan) async {
    final url = Uri.parse('${AppConfig.baseUrl}/reset-password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "Email": email,
          "SoDienThoai": soDienThoai,
          "new_password": matKhauMoi, // Trường mật khẩu mới
          "new_password_confirmation":
              mkxacnhan, // Trường xác nhận mật khẩu mới
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['message']; // Trả về thông báo thành công
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        throw Exception(
            'Lỗi từ server: ${data['errors'] ?? 'Thông tin không hợp lệ'}');
      } else if (response.statusCode == 404) {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Không tìm thấy người dùng');
      } else {
        throw Exception('Lỗi không xác định');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Lỗi kết nối: $e');
    }
  }

  Future<void> createCart(int nguoiDungId) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/cart/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'NguoiDungId': nguoiDungId}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data['message']);
      } else {
        throw Exception("Không thể tạo giỏ hàng");
      }
    } catch (e) {
      throw Exception("Lỗi kết nối: $e");
    }
  }
}
