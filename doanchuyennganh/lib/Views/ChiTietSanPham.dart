import 'dart:convert';

import 'package:doanchuyennganh/Model/DonHangModel.dart';
import 'package:doanchuyennganh/Model/SanPhamModel.dart';
import 'package:doanchuyennganh/Views/ReviewPage.dart';
import 'package:doanchuyennganh/config.dart';
import 'package:flutter/material.dart';
import 'package:doanchuyennganh/Model/ChiTietSanPhamModel.dart';
import 'package:doanchuyennganh/Controller/ProductController.dart';
import 'package:doanchuyennganh/Controller/CartController.dart';
import 'package:doanchuyennganh/Model/ChiTietGioHangModel.dart';
import 'package:doanchuyennganh/Controller/UserController.dart';
import 'package:doanchuyennganh/Controller/ThanhToanController.dart';
import 'package:http/http.dart' as http;
import 'package:doanchuyennganh/Model/ReviewDanhGia.dart';

class ManHinhChiTietSanPham extends StatefulWidget {
  final int productId;

  const ManHinhChiTietSanPham({super.key, required this.productId});

  @override
  State<ManHinhChiTietSanPham> createState() => _ManHinhChiTietSanPhamState();
}

class _ManHinhChiTietSanPhamState extends State<ManHinhChiTietSanPham> {
  final SanPhamController _sanPhamController = SanPhamController();
  final Usercontroller _usercontroller = Usercontroller();
  final OrderController orderController = OrderController();
  ChiTietSanPham? chiTietSanPham;
  bool isLoading = true;
  int selectedImageIndex = 0;
  int productQuantity = 1;
  int quantity = 1;

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    setState(() {
      if (quantity > 1) quantity--;
    });
  }

  Future<void> fetchProductData() async {
    try {
      final product =
          await _sanPhamController.fetchSanPhamById(widget.productId);
      setState(() {
        chiTietSanPham = product;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi khi tải dữ liệu sản phẩm')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF5E3023),
        title: Text('Chi tiết sản phẩm',
            style: TextStyle(
              color: Colors.white,
            )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/trangChu');
          },
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : chiTietSanPham == null
              ? const Center(child: Text('Không thể tải dữ liệu sản phẩm'))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    chiTietSanPham!
                                        .hinhAnhs[selectedImageIndex].path,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                    chiTietSanPham!.hinhAnhs.length,
                                    (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedImageIndex = index;
                                          });
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color:
                                                    selectedImageIndex == index
                                                        ? Colors.blue
                                                        : Colors.transparent,
                                                width: 2,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                chiTietSanPham!
                                                    .hinhAnhs[index].path,
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chiTietSanPham!.moTa,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Kích thước: ${chiTietSanPham!.kichThuoc}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Chất liệu: ${chiTietSanPham!.chatLieu}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Đánh giá sản phẩm:',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReviewPage(
                                              sanPhamId: chiTietSanPham!.id),
                                        ),
                                      );
                                    },
                                    child: const Text('Xem tất cả đánh giá'),
                                  ),
                                ],
                              ),
                              const Text(
                                'Sản phẩm tương tự:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const SanPhamTuongTu(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove,
                                      color: Colors.black),
                                  onPressed: () {
                                    decreaseQuantity();
                                  },
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      quantity.toString(),
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add,
                                      color: Colors.black),
                                  onPressed: () {
                                    increaseQuantity();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      try {
                                        String? userIdString =
                                            await _usercontroller
                                                .getNguoiDungId();
                                        if (userIdString != null) {
                                          int? userId =
                                              int.tryParse(userIdString);

                                          if (userId != null) {
                                            final orderRequest =
                                                OrderRequestModel(
                                              nguoiDungId: userId,
                                              sanPhamList: [
                                                OrderItem(
                                                    sanPhamId:
                                                        chiTietSanPham!.id,
                                                    soLuong: quantity),
                                              ],
                                            );

                                            final orderResponse =
                                                await orderController
                                                    .createOrder(orderRequest);

                                            Navigator.pushReplacementNamed(
                                                context, '/thanhToan',
                                                arguments: {
                                                  'orderResponse': orderResponse
                                                });
                                            print(
                                                'Người dùng: ${orderResponse.user.name}');
                                            print(
                                                'Tổng giá: ${orderResponse.order.totalPrice}');
                                            for (var item
                                                in orderResponse.order.items) {
                                              print(
                                                  'Sản phẩm: ${item.name}, Giá: ${item.price}, Tổng: ${item.totalPrice}');
                                            }
                                          }
                                        }
                                      } catch (e) {
                                        print('Lỗi: $e');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                    ),
                                    icon: const Icon(Icons.flash_on,
                                        color: Colors.white),
                                    label: const Text(
                                      'Mua ngay',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      try {
                                        String? userIdString =
                                            await _usercontroller
                                                .getNguoiDungId();

                                        print('User ID String: $userIdString');
                                        print(
                                            'SanPhamId: ${chiTietSanPham!.id}');

                                        print('SoLuong: $quantity');
                                        if (userIdString != null) {
                                          int? userId =
                                              int.tryParse(userIdString);

                                          if (userId != null) {
                                            print('User ID: $userId');

                                            final cartRequest = CartRequest(
                                              sanPhamId: chiTietSanPham!.id,
                                              soLuong: quantity,
                                              nguoiDungId: userId,
                                            );

                                            final cartController =
                                                CartController();
                                            final cartResponse =
                                                await cartController
                                                    .addToCart(cartRequest);

                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text('Thông Báo'),
                                                  content: Text(
                                                      cartResponse.message),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            print(
                                                'User ID is not a valid number');
                                          }
                                        } else {
                                          print('User ID is null');
                                        }
                                      } catch (e) {
                                        print('Error: $e');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                    ),
                                    icon: const Icon(Icons.add_shopping_cart,
                                        color: Colors.white),
                                    label: const Text(
                                      'Giỏ hàng',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
    );
  }
}

class SanPhamTuongTu extends StatelessWidget {
  const SanPhamTuongTu({Key? key}) : super(key: key);
  Future<List<SanPham>> fetchSanPham() async {
    const apiUrl = '${AppConfig.baseUrl}/products';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SanPham.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sản phẩm');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SanPham>>(
      future: fetchSanPham(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có sản phẩm tương tự.'));
        }

        final products = snapshot.data!;

        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  print('Sản phẩm được chọn: ${product.tenSanPham}');
                  Navigator.pushReplacementNamed(context, '/chiTietSanPham',
                      arguments: {'productId': product.sanPhamId});
                },
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.hinhAnh.toString(),
                          width: 150,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.tenSanPham,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Giá: ${product.gia}đ',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                            if (product.giaTriGiam != null)
                              Text(
                                'Giảm: ${product.giaTriGiam!.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
