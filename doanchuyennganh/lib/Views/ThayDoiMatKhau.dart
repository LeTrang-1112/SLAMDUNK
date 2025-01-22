import 'package:doanchuyennganh/Views/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:doanchuyennganh/config.dart';
import 'package:doanchuyennganh/Controller/UserController.dart';

class ManHinhThayDoiMatKhau extends StatefulWidget {
  const ManHinhThayDoiMatKhau({super.key});

  @override
  State<ManHinhThayDoiMatKhau> createState() => ManHinhThayDoiMatKhauState();
}

class ManHinhThayDoiMatKhauState extends State<ManHinhThayDoiMatKhau> {
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  Usercontroller _usercontroller = Usercontroller();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _changePassword() async {
    if (_oldPasswordController.text.isEmpty) {
      _showMessage("Mật khẩu cũ không được để trống.");
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showMessage("Mật khẩu mới không khớp.");
      return;
    }
    if (_newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showMessage("Mật khẩu mới và xác nhận không được để trống.");
      return;
    }

    // Lấy id người dùng từ UserController
    int? id = 0;
    String? userIdString = await _usercontroller.getNguoiDungId();
    if (userIdString != null) {
      id = int.tryParse(userIdString);
      print(id);
    }

    if (id == null) {
      _showMessage("Lỗi lấy thông tin người dùng.");
      return;
    }

    // Gửi dữ liệu thay đổi mật khẩu
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/change-password'), // Địa chỉ API của bạn
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // Nếu cần token xác thực
      },
      body: jsonEncode({
        'NguoiDungId': id,
        'matKhau': _oldPasswordController.text,
        'matKhauMoi': _newPasswordController.text,
        'matKhauMoi_confirmation': _confirmPasswordController.text,
      }),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      // Mật khẩu đã được thay đổi thành công
      final responseData = json.decode(response.body);
      _showMessage(responseData['message']);

      Navigator.pushNamed(context, '/thongTinNguoiDung');
    } else {
      // Lỗi, xử lý thông báo từ server
      final responseData = json.decode(response.body);
      _showMessage(responseData['message']);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5E3023),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/thongTinNguoiDung');
          },
        ),
        title: const Text(
          'Thay đổi mật khẩu',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
                // height: 160,
                // decoration: const BoxDecoration(
                //   color: Color(0xFF5E3023),
                //   borderRadius: BorderRadius.vertical(
                //     bottom: Radius.circular(30),
                //   ),
                // ),
                // child: Center(
                //   child:
                //   //  Column(
                //   //   mainAxisAlignment: MainAxisAlignment.center,
                //   //   children: const [
                //   //     Text(
                //   //       '3TL SLAMDUNK',
                //   //       textAlign: TextAlign.center,
                //   //       style: TextStyle(
                //   //         fontSize: 24,
                //   //         color: Colors.white,
                //   //         fontWeight: FontWeight.bold,
                //   //       ),
                //   //     ),
                //   //     SizedBox(height: 10),
                //   //     Text(
                //   //       'Thay đổi mật khẩu',
                //   //       style: TextStyle(
                //   //         fontSize: 18,
                //   //         color: Colors.white,
                //   //         fontWeight: FontWeight.w400,
                //   //       ),
                //   //     ),
                //   //   ],
                //   // ),
                // ),
                ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mật khẩu cũ:',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _oldPasswordController,
                    obscureText: _obscureOldPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      hintText: 'Nhập mật khẩu cũ',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureOldPassword = !_obscureOldPassword;
                          });
                        },
                        child: Icon(
                          _obscureOldPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Mật khẩu mới:',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      hintText: 'Nhập mật khẩu mới',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                        child: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nhập lại mật khẩu mới:',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      hintText: 'Nhập lại mật khẩu mới',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        child: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5E3023),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Thay đổi',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
