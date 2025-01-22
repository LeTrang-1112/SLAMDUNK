import 'dart:convert';

import 'package:doanchuyennganh/Controller/AdminController.dart';
import 'package:doanchuyennganh/Model/ChiTietDonHangAdmin.dart';
import 'package:doanchuyennganh/Model/ChiTietSanPhamModel.dart';
import 'package:flutter/material.dart';
import 'package:doanchuyennganh/Controller/UserController.dart';
import 'package:doanchuyennganh/config.dart';
import 'package:http/http.dart' as http;
import 'package:doanchuyennganh/Controller/ProductController.dart';

class ManHinhChiTietDonHangAdmin extends StatefulWidget {
  final int id; // DonHangId
  ManHinhChiTietDonHangAdmin({Key? key, required this.id}) : super(key: key);

  @override
  ManHinhChiTietDonHangAdminState createState() =>
      ManHinhChiTietDonHangAdminState();
}

class ManHinhChiTietDonHangAdminState
    extends State<ManHinhChiTietDonHangAdmin> {
  SanPhamController sanphamController = SanPhamController();
  Usercontroller _usercontroller = Usercontroller();
  Admincontroller _admincontroller = Admincontroller();
  ChiTietSanPham? chiTietSanPham;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchProductData(int id) async {
    try {
      final product = await sanphamController.fetchSanPhamById(id);
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

  Future<Map<String, dynamic>> layDanhGia(int ctdhId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/danhgiashow/$ctdhId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);

        if (data is List && data.isNotEmpty) {
          var review = data[0];
          return {
            'hasReview': true,
            'CTDHId': review['CTDHId'],
            'NoiDung': review['NoiDung'],
            'Sao': int.tryParse(review['Sao'].toString()) ?? 0,
          };
        } else {
          return {'hasReview': false};
        }
      } catch (e) {
        print('Lỗi khi phân tích JSON: $e');
        return {'hasReview': false};
      }
    } else {
      return {'hasReview': false};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết đơn hàng')),
      body: FutureBuilder<ChiTietDonHang>(
        future: _admincontroller.fetchChiTietDonHang(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Không có dữ liệu'));
          } else {
            final order = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mã Đơn Hàng: ${order.donHangId}',
                        style: TextStyle(fontSize: 18)),
                    Text('Người Nhận: ${order.nguoiNhan}',
                        style: TextStyle(fontSize: 16)),
                    Text('Số Điện Thoại: ${order.soDienThoai}',
                        style: TextStyle(fontSize: 16)),
                    Text('Địa Chỉ Giao Hàng: ${order.diaChiGiaoHang}',
                        style: TextStyle(fontSize: 16)),
                    Text('Ngày Đặt Hàng: ${order.ngayDatHang}',
                        style: TextStyle(fontSize: 16)),
                    Text('Phương Thức Thanh Toán: ${order.phuongThucThanhToan}',
                        style: TextStyle(fontSize: 16)),
                    Text('Trạng Thái: ${order.trangThai}',
                        style: TextStyle(fontSize: 16)),
                    Text('Ghi Chú: ${order.ghiChu}',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 20),
                    Text('Chi Tiết Sản Phẩm:', style: TextStyle(fontSize: 18)),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: order.chiTietDonHangs.length,
                      itemBuilder: (context, index) {
                        final item = order.chiTietDonHangs[index];
                        return FutureBuilder(
                          future: layDanhGia(item.ctdhId),
                          builder: (context, reviewSnapshot) {
                            if (reviewSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (reviewSnapshot.hasError) {
                              return Text('Lỗi: ${reviewSnapshot.error}');
                            } else {
                              final reviewData =
                                  reviewSnapshot.data as Map<String, dynamic>;
                              return Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                          'Sản phẩm ID: ${item.sanPhamId}'),
                                      subtitle: Text(
                                          'Số Lượng: ${item.soLuong} - Giá: ${item.gia}'),
                                    ),
                                    if (reviewData['hasReview']) ...[
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              "Đánh Giá: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children:
                                                  List.generate(5, (starIndex) {
                                                return Icon(
                                                  Icons.star,
                                                  color: starIndex <
                                                          reviewData['Sao']
                                                      ? Colors.orange
                                                      : Colors.grey,
                                                  size: 20,
                                                );
                                              }),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Nội dung: ${reviewData['NoiDung']}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ] else ...[
                                      Text(
                                        'Chưa có đánh giá',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
