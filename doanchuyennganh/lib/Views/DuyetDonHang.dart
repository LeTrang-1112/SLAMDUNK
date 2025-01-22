import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:doanchuyennganh/config.dart';
import 'package:doanchuyennganh/Model/DonHangAdmin.dart';

class DonHangPage extends StatefulWidget {
  const DonHangPage({super.key});

  @override
  _DonHangPageState createState() => _DonHangPageState();
}

class _DonHangPageState extends State<DonHangPage> {
  late Future<List<DonHangAdmin>> _donHangs;
  String _selectedStatus = 'Chờ xác nhận';

  @override
  void initState() {
    super.initState();
    _donHangs = fetchDonHangs();
  }

  Future<List<DonHangAdmin>> fetchDonHangs() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/donhang'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      print("Status :${response.statusCode}");
      print(data);
      return data.map((json) => DonHangAdmin.fromJson(json)).toList();
    } else {
      throw Exception('Không thể tải danh sách đơn hàng');
    }
  }

  List<DonHangAdmin> filterDonHangs(
      List<DonHangAdmin> donHangs, String status) {
    return donHangs.where((donHang) => donHang.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/trangChu');
          },
          color: Colors.white,
        ),
        title: const Text(
          'Danh sách đơn hàng',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF5E3023),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: <String>[
                'Chờ xác nhận',
                'Đang giao',
                'Đã giao',
                'Đã hủy'
              ].map((String status) {
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 48) / 2,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedStatus = status;
                        _donHangs = fetchDonHangs();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _selectedStatus == status ? Colors.blue : Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      status,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<DonHangAdmin>>(
              future: _donHangs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có đơn hàng.'));
                }

                List<DonHangAdmin> donHangs = snapshot.data!;
                List<DonHangAdmin> filteredDonHangs =
                    filterDonHangs(donHangs, _selectedStatus);

                return ListView.builder(
                  itemCount: filteredDonHangs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      child: ListTile(
                        leading: Icon(
                          Icons.shopping_cart,
                          color: Colors.brown,
                        ),
                        title: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/chiTietDonHangAdmin',
                              arguments: {'id': filteredDonHangs[index].id},
                            );
                          },
                          child: Text(
                            'Đơn hàng #${filteredDonHangs[index].id}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Khách hàng: ${filteredDonHangs[index].customerName}',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Tổng tiền: ${filteredDonHangs[index].totalPrice}',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Địa chỉ giao hàng:\n ${filteredDonHangs[index].DiaChiGiaoHang}',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            const SizedBox(height: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (filteredDonHangs[index].status ==
                                    'Chờ xác nhận') ...[
                                  ElevatedButton(
                                    onPressed: () {
                                      _handleApprove(filteredDonHangs[index].id,
                                          "Đang giao");
                                    },
                                    child: Text('Duyệt đơn'),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.orange),
                                    ),
                                  ),
                                ],
                                if (filteredDonHangs[index].status ==
                                    'Đang giao') ...[
                                  ElevatedButton(
                                    onPressed: () {
                                      _handleApprove(filteredDonHangs[index].id,
                                          "Đã giao");
                                    },
                                    child: Text('Đã giao'),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.green),
                                    ),
                                  ),
                                ],
                                if (filteredDonHangs[index].status !=
                                        'Đã giao' &&
                                    filteredDonHangs[index].status !=
                                        'Đã hủy') ...[
                                  ElevatedButton(
                                    onPressed: () {
                                      _handleCancel(filteredDonHangs[index].id);
                                    },
                                    child: Text('Hủy đơn'),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                    ),
                                  ),
                                ],
                              ],
                            )
                          ],
                        ),
                        trailing: Chip(
                          label: Text(
                            filteredDonHangs[index].status,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          backgroundColor:
                              _getStatusColor(filteredDonHangs[index].status),
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
    );
  }

  void _handleApprove(int orderId, String status) async {
    try {
      final response = await http.put(
        Uri.parse('${AppConfig.baseUrl}/donhang/$orderId/status'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'TrangThai': status}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _donHangs = fetchDonHangs();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đơn hàng #$orderId đã được duyệt.')),
        );
      } else {
        throw Exception('Không thể duyệt đơn hàng.');
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi duyệt đơn hàng: $error')),
      );
    }
  }

  void _handleCancel(int orderId) async {
    try {
      final response = await http.put(
        Uri.parse('${AppConfig.baseUrl}/donhang/$orderId/status'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'TrangThai': 'Đã hủy'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _donHangs = fetchDonHangs();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đơn hàng #$orderId đã bị hủy.')),
        );
      } else {
        throw Exception('Không thể hủy đơn hàng.');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi hủy đơn hàng: $error')),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Chờ xác nhận':
        return Colors.orange;
      case 'Đang giao':
        return Colors.blue;
      case 'Đã giao':
        return Colors.green;
      case 'Đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
