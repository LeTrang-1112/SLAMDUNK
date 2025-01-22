import 'dart:convert';

import 'package:doanchuyennganh/Views/CustomAppBar.dart';
import 'package:doanchuyennganh/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:doanchuyennganh/Model/DonHangModel.dart'; // Đảm bảo bạn import đúng file model
import 'package:doanchuyennganh/Controller/ThanhToanController.dart';
import 'package:doanchuyennganh/Controller/UserController.dart';
import 'package:http/http.dart' as http;

class ManHinhThanhToan extends StatefulWidget {
  final OrderResponseModel orderResponse;

  ManHinhThanhToan({required this.orderResponse});

  @override
  _ManHinhThanhToanState createState() => _ManHinhThanhToanState();
}

class _ManHinhThanhToanState extends State<ManHinhThanhToan> {
  final _formKey = GlobalKey<FormState>();
  int phuongThucThanhToan = 0; // 0: Thanh toán khi nhận hàng, 1: Ví MoMo
  final TextEditingController tenController = TextEditingController();
  final TextEditingController sdtController = TextEditingController();
  final TextEditingController diaChiController = TextEditingController();
  final TextEditingController ghiChuController = TextEditingController();

  Usercontroller _usercontroller = Usercontroller();
  final _orderService = OrderController();
  bool _loading = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    final orderResponse = widget.orderResponse;

    // Gán các giá trị mặc định từ response vào các controller
    tenController.text = orderResponse.user.name;
    sdtController.text = orderResponse.user.phone ?? '';
    diaChiController.text = orderResponse.user.address ?? '';
  }

  void chonPhuongThucThanhToan(int index) {
    setState(() {
      phuongThucThanhToan = index;
    });
  }

  void placeOrder() async {
    setState(() {
      _loading = true;
    });

    // Check if necessary fields are filled
    if (diaChiController.text.isEmpty ||
        sdtController.text.isEmpty ||
        tenController.text.isEmpty) {
      _showMessage("Vui lòng điền đầy đủ thông tin người nhận.");
      setState(() {
        _loading = false;
      });
      return;
    }

    // Validate phone number format
    String phone = sdtController.text.trim();
    if (!_isValidPhoneNumber(phone)) {
      _showMessage("Số điện thoại không hợp lệ. Vui lòng nhập lại.");
      setState(() {
        _loading = false;
      });
      return;
    }
    String? userIdString = await _usercontroller.getNguoiDungId();
    if (userIdString != null) {
      int? userId = int.tryParse(userIdString);
      if (userId != null) {
        print("NguoiDungId: $userId");
        print("PhuongThucThanhToan:$phuongThucThanhToan");
        print("DiaChi: ${diaChiController.text}");
        print("sodienthoai: ${sdtController.text}");
        print("NguoiNhan: ${tenController.text}");

        // Prepare request body
        final requestBody = jsonEncode({
          "NguoiDungId": userId,
          "sanPhamList": widget.orderResponse.order.items.map((item) {
            int productId = item.productId ?? 0; // Default value if null
            int quantity = item.quantity ?? 0; // Default value if null
            print('Masp: $productId');
            print('SoLuong: $quantity');
            return OrderItem(
              sanPhamId: productId,
              soLuong: quantity,
            );
          }).toList(),
          "PhuongThucThanhToan": (phuongThucThanhToan ?? 0) == 0
              ? 'Thanh Toán Khi Nhận Hàng'
              : 'MoMo',
          "DiaChiGiaoHang": diaChiController.text,
          "GhiChu": ghiChuController.text,
          "SoDienThoai": sdtController.text,
          "NguoiNhan": tenController.text
        });

        print("JSON gửi đi: $requestBody");

        try {
          final response = await http.post(
            Uri.parse("${AppConfig.baseUrl}/oder"),
            body: requestBody,
            headers: {"Content-Type": "application/json"},
          );

          print("Response: ${response.statusCode}");
          if (response.statusCode == 200) {
            // Handle successful response
            print("Thành Công");
            _showMessage("Đặt hàng thành công. Vui lòng kiểm tra đơn hàng.");

            Navigator.pushReplacementNamed(context, '/trangChu');
          } else {
            // Handle failure response
            final errorMessage = await _getErrorMessage(response);
            _showMessage(errorMessage);
          }
        } catch (e) {
          // Handle network errors or other unexpected exceptions
          _showMessage("Đặt hàng thất bại. Vui lòng kiểm tra kết nối mạng.");
          print("Error: $e");
        } finally {
          setState(() {
            _loading = false;
          });
        }
      }
    }
  }

  bool _isValidPhoneNumber(String phone) {
    // This regex validates a Vietnamese phone number (starts with 0, followed by 9 digits)
    final phoneRegex = RegExp(r"^0[0-9]{9}$");
    return phoneRegex.hasMatch(phone);
  }

// Function to extract error message from response body
  Future<String> _getErrorMessage(http.Response response) async {
    try {
      final responseData = json.decode(response.body);
      if (responseData.containsKey('message')) {
        return responseData['message'];
      }
    } catch (e) {
      print('Error parsing error message: $e');
    }
    return 'Có lỗi xảy ra, vui lòng thử lại.';
  }

// Show message function for displaying user-friendly messages
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        // Thêm SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thông tin giao hàng',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: tenController,
                  decoration: InputDecoration(
                    labelText: 'Tên người nhận',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên người nhận';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: sdtController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    if (value.length != 10) {
                      return 'Số điện thoại phải có 10 chữ số';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: diaChiController,
                  decoration: InputDecoration(
                    labelText: 'Địa chỉ giao hàng',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập địa chỉ';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 6),
                TextFormField(
                  controller: ghiChuController,
                  decoration: InputDecoration(
                    labelText: 'Ghi chú',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Tóm tắt đơn hàng',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                ...widget.orderResponse.order.items.map((item) => DongTomTat(
                      label: item.name,
                      soTien: '\$${item.totalPrice}',
                    )),
                Divider(),
                DongTomTat(
                  label: 'Tổng cộng:',
                  soTien: '\$${widget.orderResponse.order.totalPrice}',
                  dam: true,
                ),
                SizedBox(height: 16),
                Text(
                  'Phương thức thanh toán',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () => chonPhuongThucThanhToan(0),
                  child: ThePhuongThucThanhToan(
                    icon: Icons.delivery_dining,
                    loaiThe: 'Thanh toán khi nhận hàng',
                    duocChon: phuongThucThanhToan == 0,
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () => chonPhuongThucThanhToan(1),
                  child: ThePhuongThucThanhToan(
                    icon: Icons.phone_android,
                    loaiThe: 'Ví MoMo',
                    duocChon: phuongThucThanhToan == 1,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng giá: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.orderResponse.order.totalPrice} VNĐ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: placeOrder,
                  child: Text(
                    'Đặt hàng',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DongTomTat extends StatelessWidget {
  final String label;
  final String soTien;
  final bool dam;
  final List<String> _products = [];
  DongTomTat({required this.label, required this.soTien, this.dam = false});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          child: constraints.maxWidth < 400
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TextStyle(fontSize: 14)),
                    Text(
                      soTien,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: dam ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: TextStyle(fontSize: 16)),
                    Text(
                      soTien,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: dam ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class ThePhuongThucThanhToan extends StatelessWidget {
  final IconData icon;
  final String loaiThe;
  final bool duocChon;

  ThePhuongThucThanhToan({
    required this.icon,
    required this.loaiThe,
    required this.duocChon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: duocChon ? Colors.blue : Colors.grey,
        ),
        borderRadius: BorderRadius.circular(8),
        color: duocChon ? Colors.blue.withOpacity(0.1) : Colors.transparent,
      ),
      child: Row(
        children: [
          Icon(icon, color: duocChon ? Colors.blue : Colors.black),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              loaiThe,
              style: TextStyle(
                fontSize: screenWidth < 400 ? 14 : 16,
                fontWeight: duocChon ? FontWeight.bold : FontWeight.normal,
                color: duocChon ? Colors.blue : Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
