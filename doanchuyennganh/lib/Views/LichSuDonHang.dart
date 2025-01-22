import 'dart:convert';
import 'package:doanchuyennganh/Views/CustomBottom.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doanchuyennganh/Controller/UserController.dart';
import 'package:doanchuyennganh/config.dart';

class ManHinhLichSuDonHang extends StatefulWidget {
  const ManHinhLichSuDonHang({Key? key}) : super(key: key);

  @override
  _ManHinhLichSuDonHangState createState() => _ManHinhLichSuDonHangState();
}

class _ManHinhLichSuDonHangState extends State<ManHinhLichSuDonHang> {
  late Future<List<Map<String, dynamic>>> _orders;
  late String _orderStatus;
  Usercontroller _usercontroller = Usercontroller();
  int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _orderStatus = arguments['orderStatus'];

    _orders = fetchOrders(_orderStatus);
  }

  Future<List<Map<String, dynamic>>> fetchOrders(String orderStatus) async {
    int? id = 0;
    String? userIdString = await _usercontroller.getNguoiDungId();
    if (userIdString != null) {
      id = int.tryParse(userIdString);
      print(id);
    }

    final response =
        await http.get(Uri.parse('${AppConfig.baseUrl}/orders/$id'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['orders'];

      // Kiểm tra nếu không có đơn hàng thì trả về danh sách trống
      if (data.isEmpty) {
        print("Không có đơn hàng");
        return [];
      }

      // Lọc các đơn hàng theo trạng thái
      List<Map<String, dynamic>> filteredOrders = data
          .where((order) => order['TrangThai'] == orderStatus)
          .map((order) => {
                'id': order['DonHangId'],
                'PhuongThucThanhToan': order['PhuongThucThanhToan'],
                'TrangThai': order['TrangThai'],
                'NgayDatHang': order['NgayDatHang'],
                'totalPrice': double.parse(order['TongTien']),
                'DiaChiGiaoHang': order['DiaChiGiaoHang'] ?? 'Không có địa chỉ',
              })
          .toList();
      print(filteredOrders);
      return filteredOrders;
    } else {
      // Nếu response không phải 200 thì chỉ thông báo và trả về danh sách trống
      print('Không thể tải danh sách đơn hàng');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Container(
            height: 150,
            decoration: const BoxDecoration(
              color: Color(0xFF5E3023),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(50),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Lịch Sử Đặt Hàng',
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Danh sách các đơn hàng gần đây',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _orders,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có đơn hàng nào.'));
                }

                final orders = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailPage(
                                id: order['id'], trangthai: order['TrangThai']),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Id Đơn hàng: #${order['id']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Phương thức thanh toán: #${order['PhuongThucThanhToan']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ngày đặt: #${order['NgayDatHang']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tổng tiền: ${order['totalPrice']} ₫',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Trạng thái: ${order['TrangThai']} ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() async {
            _currentIndex = index;
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/trangChu');
            } else if (index == 1) {
              String? userIdString = await _usercontroller.getNguoiDungId();
              if (userIdString != null) {
                int? userId = int.tryParse(userIdString);
                Navigator.pushReplacementNamed(
                  context,
                  '/gioHang',
                  arguments: {'userId': userId},
                );
              }
            } else if (index == 2) {
            } else if (index == 3) {
              Navigator.pushNamed(context, '/thanhVien');
            }
          });
        },
      ),
    );
  }
}

class OrderDetailPage extends StatefulWidget {
  final int id;
  final String trangthai;
  OrderDetailPage({Key? key, required this.id, required this.trangthai})
      : super(key: key);
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool isReviewed = false;

  Usercontroller _usercontroller = Usercontroller();

  @override
  void initState() {
    super.initState();
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
    } else if (response.statusCode == 404) {
      return {'hasReview': false};
    } else {
      print('Lỗi tải dữ liệu: ${response.statusCode}');
      return {'hasReview': false};
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrders(String orderStatus) async {
    int? idnd = 0;
    String? userIdString = await _usercontroller.getNguoiDungId();
    if (userIdString != null) {
      idnd = int.tryParse(userIdString);
    }

    final response =
        await http.get(Uri.parse('${AppConfig.baseUrl}/orders/$idnd'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['orders'];

      List<Map<String, dynamic>> filteredOrders = data
          .where((order) =>
              order['TrangThai'] == orderStatus &&
              order['chi_tiet_don_hangs']
                  .any((ctdh) => ctdh['DonHangId'] == order['DonHangId']))
          .map((order) {
            List<Map<String, dynamic>> productList = [];

            for (var ctdh in order['chi_tiet_don_hangs']) {
              if (ctdh['DonHangId'] == widget.id) {
                productList.add({
                  'ctdh': ctdh['CTDHId'],
                  'id': order['DonHangId'],
                  'PhuongThucThanhToan': order['PhuongThucThanhToan'],
                  'productName': ctdh['san_pham']['TenSanPham'],
                  'TrangThai': order['TrangThai'],
                  'NgayDatHang': order['NgayDatHang'],
                  'discountPrice': double.parse(ctdh['Gia'] ?? '0'),
                  'totalPrice': double.parse(order['TongTien']),
                  'DiaChiGiaoHang':
                      order['DiaChiGiaoHang'] ?? 'Không có địa chỉ',
                });
              }
            }

            if (productList.isEmpty) return null;

            return productList;
          })
          .where((order) => order != null)
          .expand((order) => order!)
          .toList()
          .cast<Map<String, dynamic>>();

      print('Filtered Orders: $filteredOrders');
      return filteredOrders;
    } else {
      throw Exception('Bạn chưa có đơn hàng nào');
    }
  }

  Future<void> submitReview(BuildContext context, int donhangid, int ctdhid,
      int starRating, String content) async {
    final url = Uri.parse('${AppConfig.baseUrl}/danhgia');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'DonHangId': donhangid,
        'CTDHId': ctdhid,
        'NoiDung': content,
        'Sao': starRating,
      }),
    );

    print(response.body);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(response.statusCode);
      print(responseData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
      isReviewed = true;
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đánh giá thất bại')),
      );
    }
  }

  Future<void> cancelProduct() async {
    final url = Uri.parse('${AppConfig.baseUrl}/orders/${widget.id}/cancel');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hủy sản phẩm thất bại')),
      );
    }
  }

  void showRatingDialog(int donhangid, int ctdhid) async {
    var reviewData = await layDanhGia(ctdhid);
    int selectedStar = reviewData['Sao'] ?? 0;

    TextEditingController contentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đánh giá sản phẩm',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    SizedBox(height: 16),
                    if (reviewData['hasReview']) ...[
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            color: index < reviewData['Sao']
                                ? Colors.orange
                                : Colors.grey,
                            size: 30,
                          );
                        }),
                      ),
                      SizedBox(height: 8),
                      Text(
                        reviewData['NoiDung'] ?? '',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 16),
                    ],
                    if (!reviewData['hasReview']) ...[
                      Text('Chọn số sao:', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              Icons.star,
                              color: index < selectedStar
                                  ? Colors.orange
                                  : Colors.grey,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedStar = index + 1;
                              });
                            },
                          );
                        }),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: contentController,
                        maxLines: 3,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'Nội dung đánh giá',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                    if (!reviewData['hasReview'])
                      ElevatedButton(
                        onPressed: () {
                          submitReview(
                            context,
                            donhangid,
                            ctdhid,
                            selectedStar,
                            contentController.text,
                          );
                        },
                        child: Text('Gửi Đánh Giá'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          backgroundColor: Colors.blue,
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Thông tin đơn hàng'),
        backgroundColor: const Color(0xFF5E3023),
      ),
      body: Column(
        children: [
          if (widget.trangthai == 'Chờ xác nhận')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Trạng thái: ${widget.trangthai}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    cancelProduct();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Hủy đơn hàng',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          FutureBuilder(
            future: fetchOrders(widget.trangthai),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else {
                final orders = snapshot.data as List<Map<String, dynamic>>;

                if (orders.isEmpty) {
                  return const Center(child: Text('Không có đơn hàng nào.'));
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${order['productName']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Giá: ${order['discountPrice']} ₫'),
                              const SizedBox(height: 8),
                              if (order['TrangThai'] == 'Đã giao' &&
                                  !isReviewed)
                                ElevatedButton(
                                  onPressed: () {
                                    showRatingDialog(
                                        order['id'], order['ctdh']);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                  ),
                                  child: const Text('Đánh giá'),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
