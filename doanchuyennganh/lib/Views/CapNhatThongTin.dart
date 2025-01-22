// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:doanchuyennganh/config.dart';
// import 'package:doanchuyennganh/Controller/UserController.dart';

// class ManHinhCapNhatThongTin extends StatefulWidget {
//   const ManHinhCapNhatThongTin({super.key});

//   @override
//   State<ManHinhCapNhatThongTin> createState() => ManHinhCapNhatThongTinState();
// }

// class ManHinhCapNhatThongTinState extends State<ManHinhCapNhatThongTin> {
//   Usercontroller _usercontroller = Usercontroller();
//   TextEditingController _tenNguoiDungController = TextEditingController();
//   TextEditingController _soDienThoaiController = TextEditingController();
//   TextEditingController _diaChiController = TextEditingController();
//   TextEditingController _matKhauController = TextEditingController();

//   Future<void> _updateUserInfo() async {
//     // Lấy id người dùng từ UserController
//     int? id = 0;
//     String? userIdString = await _usercontroller.getNguoiDungId();
//     if (userIdString != null) {
//       id = int.tryParse(userIdString);
//       print(id);
//     }

//     if (id == null) {
//       _showMessage("Lỗi lấy thông tin người dùng.");
//       return;
//     }

//     // Gửi dữ liệu cập nhật người dùng
//     final response = await http.put(
//       Uri.parse('${AppConfig.baseUrl}/update-user/$id'),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
//       },
//       body: jsonEncode({
//         'TenNguoiDung': _tenNguoiDungController.text,
//         'SoDienThoai': _soDienThoaiController.text,
//         'DiaChi': _diaChiController.text,
//         'MatKhau': _matKhauController.text,
//       }),
//     );

//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       // Cập nhật thông tin thành công
//       final responseData = json.decode(response.body);
//       _showMessage(responseData['message']);
//     } else {
//       // Lỗi, xử lý thông báo từ server
//       final responseData = json.decode(response.body);
//       _showMessage(responseData['message']);
//     }
//   }

//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//           children: [
//             Container(
//               height: 160,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF5E3023),
//                 borderRadius: BorderRadius.vertical(
//                   bottom: Radius.circular(30),
//                 ),
//               ),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Text(
//                       '3TL SLAMDUNK',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 24,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'Cập nhật thông tin người dùng',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Tên người dùng:',
//                     style: TextStyle(color: Colors.black, fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _tenNguoiDungController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 12),
//                       hintText: 'Nhập tên người dùng',
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Số điện thoại:',
//                     style: TextStyle(color: Colors.black, fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _soDienThoaiController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 12),
//                       hintText: 'Nhập số điện thoại',
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Địa chỉ:',
//                     style: TextStyle(color: Colors.black, fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _diaChiController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 12),
//                       hintText: 'Nhập địa chỉ',
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Mật khẩu mới:',
//                     style: TextStyle(color: Colors.black, fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _matKhauController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 12),
//                       hintText: 'Nhập mật khẩu mới',
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _updateUserInfo,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF5E3023),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         minimumSize: const Size(0, 50),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Cập nhật',
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
