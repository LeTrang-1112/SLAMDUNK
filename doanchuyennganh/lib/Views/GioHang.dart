import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doanchuyennganh/config.dart';
import 'package:doanchuyennganh/Model/CartModel.dart';
import 'package:doanchuyennganh/Model/DonHangModel.dart';
import 'package:doanchuyennganh/Controller/ThanhToanController.dart';

class ManHinhGioHang extends StatefulWidget {
  final int userId;

  ManHinhGioHang({required this.userId});

  @override
  _TrangThaiManHinhGioHang createState() => _TrangThaiManHinhGioHang();
}

class _TrangThaiManHinhGioHang extends State<ManHinhGioHang> {
  OrderController orderController = OrderController();
  late Cart cart;
  bool isLoading = true;
  bool isAllSelected = false;
  Future<void> _updateCartQuantity(int productId, int quantity) async {
    final url = Uri.parse('${AppConfig.baseUrl}/cart/updatequantity');
    final body = jsonEncode({
      "NguoiDungId": widget.userId,
      "SanPhamId": productId,
      "SoLuong": quantity,
    });

    try {
      final response = await http
          .post(url, body: body, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        print('Cập nhật giỏ hàng thành công!');
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> _fetchCart() async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/showCart?NguoiDungId=${widget.userId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          cart = Cart.fromJson(data);
          isLoading = false;
        });
      } else {
        print("Error: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Exception: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _xoaSanPhamDaChon() async {
    final url = Uri.parse('${AppConfig.baseUrl}/listdeletecart');
    final ids = cart.items
        .where((item) => item.isSelected)
        .map((item) => item.cartItemId)
        .toList();

    final body = jsonEncode({
      "NguoiDungId": widget.userId,
      "CTGHIds": ids,
    });

    try {
      final response = await http.delete(url,
          body: body, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        setState(() {
          cart.items.removeWhere((item) => item.isSelected);
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Các sản phẩm đã được xóa khỏi giỏ hàng')));
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xóa sản phẩm đã chọn')));
    }
  }

  void _tangSoLuong(int index) {
    setState(() {
      cart.items[index].quantity++;
      _updateCartQuantity(
          cart.items[index].productId, cart.items[index].quantity);
    });
  }

  void _giamSoLuong(int index) {
    setState(() {
      if (cart.items[index].quantity > 1) {
        cart.items[index].quantity--;
        _updateCartQuantity(
            cart.items[index].productId, cart.items[index].quantity);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      isAllSelected = !isAllSelected;
      for (var item in cart.items) {
        item.isSelected = isAllSelected;
      }
    });
  }

  double tinhTong() {
    return cart.items.fold(0, (tong, item) {
      return item.isSelected ? tong + item.price * item.quantity : tong;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF5E3023),
        title: Text(
          'Giỏ Hàng',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/trangChu');
          },
          color: Colors.white,
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cart.items.isEmpty
              ? Center(
                  child: Text('Giỏ hàng trống!',
                      style: TextStyle(fontSize: 18, color: Colors.red)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isAllSelected,
                            onChanged: (value) => _toggleSelectAll(),
                          ),
                          Text(
                            "Chọn tất cả",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _xoaSanPhamDaChon(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          final sanPham = cart.items[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: sanPham.isSelected,
                                        onChanged: (value) => setState(() {
                                          sanPham.isSelected = value ?? false;
                                        }),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          sanPham.image,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              sanPham.name,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${sanPham.price} đ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => _xoaSanPhamDaChon(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove),
                                            onPressed: () =>
                                                _giamSoLuong(index),
                                          ),
                                          Text(
                                            '${sanPham.quantity}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: () =>
                                                _tangSoLuong(index),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${(sanPham.price * sanPham.quantity)} đ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tổng cộng:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${tinhTong()} đ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          final selectedItems = cart.items
                              .where((item) => item.isSelected)
                              .toList();

                          if (selectedItems.isNotEmpty) {
                            final orderItems = selectedItems.map((item) {
                              return OrderItem(
                                sanPhamId: item.productId,
                                soLuong: item.quantity,
                              );
                            }).toList();

                            final orderRequest = OrderRequestModel(
                              nguoiDungId: widget.userId,
                              sanPhamList: orderItems,
                            );

                            final orderResponse =
                                await orderController.createOrder(orderRequest);

                            Navigator.pushReplacementNamed(
                              context,
                              '/thanhToan',
                              arguments: {'orderResponse': orderResponse},
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Vui lòng chọn sản phẩm để thanh toán')),
                            );
                          }
                        } catch (e) {
                          print('Lỗi: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Sản phẩm không đủ số lượng')),
                          );
                        }
                      },
                      child: Text(
                        'Thanh toán',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  ],
                ),
    );
  }
}
