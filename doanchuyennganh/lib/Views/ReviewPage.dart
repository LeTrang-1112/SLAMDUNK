import 'dart:convert';
import 'package:doanchuyennganh/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doanchuyennganh/Model/ReviewDanhGia.dart';

class ReviewPage extends StatelessWidget {
  final int sanPhamId;

  ReviewPage({required this.sanPhamId});

  Future<List<DanhGia>> getDanhGiaBySanPham(int sanPhamId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/danhgiasp/$sanPhamId'),
      );

      if (response.statusCode == 200) {
        List<DanhGia> parseDanhGias(List<dynamic> jsonList) {
          return jsonList.map((json) => DanhGia.fromJson(json)).toList();
        }

        return parseDanhGias(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load danh gia, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Có lỗi xảy ra khi tải dữ liệu');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá sản phẩm'),
      ),
      body: FutureBuilder<List<DanhGia>>(
        future: getDanhGiaBySanPham(sanPhamId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final danhGias = snapshot.data!;
            return ListView.builder(
              itemCount: danhGias.length,
              itemBuilder: (context, index) {
                final danhGia = danhGias[index];
                return Card(
                  elevation: 5, // Thêm đổ bóng cho card
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Bo góc
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            color: Colors.grey[300],
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < danhGia.sao
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 18,
                                  );
                                }),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'kHÁCH HÀNG #${index + 1}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),

                              // Nội dung đánh giá
                              Text(
                                danhGia.noiDung ?? 'Chưa có đánh giá',
                                style: TextStyle(color: Colors.grey[600]),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Không có đánh giá'));
          }
        },
      ),
    );
  }
}
