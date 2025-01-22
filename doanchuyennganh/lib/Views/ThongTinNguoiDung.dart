import 'dart:convert';
import 'package:doanchuyennganh/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doanchuyennganh/Controller/UserController.dart';

class ManHinhThongTinNguoiDung extends StatefulWidget {
  @override
  _ManHinhThongTinNguoiDungState createState() =>
      _ManHinhThongTinNguoiDungState();
}

class _ManHinhThongTinNguoiDungState extends State<ManHinhThongTinNguoiDung> {
  late Future<User?> user;
  Usercontroller _usercontroller = Usercontroller();
  bool isEditing = false; // Trạng thái cập nhật

  // Controllers để quản lý dữ liệu từ các TextField
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phone = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = fetchUserData();
  }

  Future<User?> fetchUserData() async {
    int? id = 0;
    String? userIdString = await _usercontroller.getNguoiDungId();
    if (userIdString != null) {
      id = int.tryParse(userIdString);
    }

    final response =
        await http.get(Uri.parse('${AppConfig.baseUrl}/nguoidung/$id'));
    print("response: ${response.statusCode}");

    if (response.statusCode == 200) {
      final userData = User.fromJson(jsonDecode(response.body));
      // Gán dữ liệu vào các TextEditingController
      nameController.text = userData.tenNguoiDung;
      emailController.text = userData.email;
      addressController.text = userData.diaChi;
      phone.text = userData.soDienThoai;
      return userData;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> saveUserData() async {
    // Kiểm tra dữ liệu đầu vào
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tên không được để trống")),
      );
      return;
    }

    if (emailController.text.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
            .hasMatch(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email không hợp lệ")),
      );
      return;
    }

    if (addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Địa chỉ không được để trống")),
      );
      return;
    }

    if (phone.text.isEmpty ||
        !RegExp(r'^(0[3|5|7|8|9])+([0-9]{8})$').hasMatch(phone.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Số điện thoại không hợp lệ")),
      );
      return;
    }

    // Kiểm tra ID người dùng
    int? id = 0;
    String? userIdString = await _usercontroller.getNguoiDungId();
    if (userIdString != null) {
      id = int.tryParse(userIdString);
    }

    if (id == null || id == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không tìm thấy người dùng")),
      );
      return;
    }

    final url = Uri.parse('${AppConfig.baseUrl}/nguoidung/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'TenNguoiDung': nameController.text,
        'Email': emailController.text,
        'DiaChi': addressController.text,
        'SoDienThoai': phone.text
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
      setState(() {
        isEditing = false;
      });
    } else {
      final errorData = jsonDecode(response.body);
      print(errorData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${errorData['message'] ?? 'Cập nhật thất bại'}'),
        ),
      );
    }
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
            Navigator.pushNamed(context, '/thanhVien');
          },
        ),
        title: const Text(
          'Thông Tin Người Dùng',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<User?>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              // Thêm khả năng cuộn
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    OThongTin(
                      label: "Tên",
                      controller: nameController,
                      isEditing: isEditing,
                    ),
                    OThongTin(
                      label: "Email",
                      controller: emailController,
                      isEditing: isEditing,
                    ),
                    OThongTin(
                      label: "Số điện thoại",
                      controller: phone,
                      isEditing: isEditing,
                    ),
                    OThongTin(
                      label: "Địa chỉ giao hàng",
                      controller: addressController,
                      isEditing: isEditing,
                    ),
                    OThongTin(
                      label: "Mật khẩu",
                      controller: TextEditingController(text: "************"),
                      isEditing: false,
                    ),
                    SizedBox(height: 5),
                    if (isEditing)
                      ElevatedButton.icon(
                        onPressed: saveUserData,
                        icon: Icon(Icons.save, color: Colors.white),
                        label:
                            Text("Lưu", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                        icon: Icon(Icons.edit, color: Colors.white),
                        label: Text("Cập nhật thông tin",
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                      ),
                    SizedBox(height: 5),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/thayDoiMatKhau');
                      },
                      icon: Icon(Icons.lock, color: Colors.white),
                      label: Text("Thay đổi mật khẩu",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

class OThongTin extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditing;

  const OThongTin({
    required this.label,
    required this.controller,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        controller: controller,
        readOnly: !isEditing,
      ),
    );
  }
}

class User {
  final int nguoiDungId;
  final String tenNguoiDung;
  final String email;
  final String soDienThoai;
  final String matKhau;
  final String diaChi;
  final String ngayTao;
  final int isAdmin;

  User({
    required this.nguoiDungId,
    required this.tenNguoiDung,
    required this.email,
    required this.soDienThoai,
    required this.matKhau,
    required this.diaChi,
    required this.ngayTao,
    required this.isAdmin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nguoiDungId: json['NguoiDungId'] ?? 0,
      tenNguoiDung: json['TenNguoiDung'] ?? '',
      email: json['Email'] ?? '',
      soDienThoai: json['SoDienThoai'] ?? '',
      matKhau: json['MatKhau'] ?? '',
      diaChi: json['DiaChi'] ?? '',
      ngayTao: json['NgayTao'] ?? '',
      isAdmin: json['IsAdmin'] ?? 0,
    );
  }
}
