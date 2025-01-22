import 'package:doanchuyennganh/Views/CustomAppBar.dart';
import 'package:doanchuyennganh/Views/CustomBottom.dart';
import 'package:flutter/material.dart';
import 'package:doanchuyennganh/Controller/UserController.dart';

class ManHinhThanhVien extends StatefulWidget {
  const ManHinhThanhVien({super.key});
  @override
  State<ManHinhThanhVien> createState() => ManHinhThanhVienState();
}

class ManHinhThanhVienState extends State<ManHinhThanhVien> {
  Usercontroller usercontroller = Usercontroller();
  int _currentIndex = 3;
  void launchZalo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thông báo"),
          content: Text(
              "Bạn có muốn mở Zalo để nhắn tin không?\nZalo me: 0924356735"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                // Mở Zalo hoặc thực hiện hành động khác
                Navigator.of(context).pop(); // Đóng hộp thoại sau khi hành động
                // Ví dụ: launchZaloUrl()
              },
              child: Text("Mở Zalo"),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // Phần header của giao diện

            // User Information
            // SizedBox(
            //   height: 20,
            // ),
            Stack(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Căn chỉnh khoảng cách
                  children: [
                    const SizedBox(width: 10), // Khoảng cách giữa nút và avatar

                    CircleAvatar(
                      radius: 50,
                      backgroundImage: const NetworkImage(
                        "https://cdn-media.sforum.vn/storage/app/media/THANHAN/avatar-trang-69.jpg",
                      ),
                      onBackgroundImageError: (exception, stackTrace) {
                        debugPrint('Image load error: $exception');
                      },
                      child: const Icon(Icons.person, size: 50), // Ảnh mặc định
                    ),
                    const SizedBox(width: 10), // Khoảng cách giữa nút và avatar

                    ElevatedButton(
                      onPressed: () {
                        // Hành động khi nhấn nút
                        Navigator.pushNamed(context, '/thongTinNguoiDung');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5E3023),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Xem thông tin người dùng',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(height: 24),

            // Order Section
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OrderButton(
                          icon: Icons.pending_actions,
                          label: 'Chờ xác nhận',
                          orderStatus: 'Chờ xác nhận',
                        ),
                        OrderButton(
                          icon: Icons.store,
                          label: 'Chờ lấy hàng',
                          orderStatus: 'Đang giao',
                        ),
                        OrderButton(
                          icon: Icons.local_shipping,
                          label: 'Đã giao',
                          orderStatus: 'Đã giao',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/thongBao');
                        print('Liên kết ví được nhấn!');
                      },
                      child: UtilityButton(
                        label: 'Thông báo',
                        icon: Icons.notifications,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/voucher');
                        // Xử lý sự kiện nhấn nút "Kho Voucher"
                        print('Kho Voucher được nhấn!');
                      },
                      child: UtilityButton(
                        label: 'Kho Voucher',
                        icon: Icons.card_giftcard,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.pushNamed(context, '/thongBao');
                        print('Trung tâm trợ giúp được nhấn!');
                      },
                      child: UtilityButton(
                        label: 'Trung tâm trợ giúp',
                        icon: Icons.help_center,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        launchZalo(context);
                        // Xử lý sự kiện nhấn nút "Kho Voucher"
                        print('Khung trò chuyện đã được nhấn!');
                      },
                      child: UtilityButton(
                        label: 'Trò chuyện cùng SlamDunk',
                        icon: Icons.chat,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Support Section
            // Card(
            //   color: Colors.white,
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Column(
            //       children: [
            //         SupportButton(
            //           label: 'Trung tâm trợ giúp',
            //           icon: Icons.help_center,
            //         ),
            //         Divider(),
            //         SupportButton(
            //           label: 'Trò chuyện cùng SlamDunk',
            //           icon: Icons.chat,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        // Sử dụng BottomNavigationBar chuẩn
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() async {
            _currentIndex = index;
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/trangChu');
            } else if (index == 1) {
              String? userIdString = await usercontroller.getNguoiDungId();
              if (userIdString != null) {
                // Chuyển String thành int?
                int? userId = int.tryParse(userIdString);
                print("UserId: $userId");
                Navigator.pushReplacementNamed(
                  context,
                  '/gioHang',
                  arguments: {'userId': userId},
                );
              }
            } else if (index == 2) {
              launchZalo(context);
            } else if (index == 3) {
              Navigator.pushNamed(context, '/thanhVien');
            }
          });
        },
      ),
    );
  }
}

class OrderButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String orderStatus; // Thêm tham số trạng thái đơn hàng

  OrderButton(
      {required this.icon, required this.label, required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Khi nhấn vào, gửi trạng thái đơn hàng đến trang lịch sử đơn hàng
            Navigator.pushNamed(
              context,
              '/lichSuDonHang',
              arguments: {
                'orderStatus': orderStatus
              }, // Truyền trạng thái vào lịch sử đơn hàng
            );
            print('Icon pressed');
          },
          child: Icon(icon, size: 32, color: Colors.redAccent),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }
}

class UtilityButton extends StatelessWidget {
  final IconData icon;
  final String label;

  UtilityButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.redAccent),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }
}

class SupportButton extends StatelessWidget {
  final IconData icon;
  final String label;

  SupportButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 32, color: Colors.redAccent),
        SizedBox(width: 16),
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    );
  }
}
