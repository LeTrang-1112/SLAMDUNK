import 'package:doanchuyennganh/Views/TimKiem.dart';
import 'package:flutter/material.dart';
import 'package:doanchuyennganh/Controller/UserController.dart';
import 'package:doanchuyennganh/Controller/AdminController.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({Key? key}) : super(key: key);
  Admincontroller _admincontroller = Admincontroller();
  Usercontroller _usercontroller = Usercontroller();

  @override
  Size get preferredSize => const Size.fromHeight(110.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF5E3023),
        elevation: 0,
        toolbarHeight: 110,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        flexibleSpace: Container(
          padding: const EdgeInsets.only(top: 50),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 10,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '3TL SLAMDUNK',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Welcome to the Basketball store',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: FutureBuilder<bool>(
                  future: _admincontroller.checkIfAdmin(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(
                        'Lỗi',
                        style: TextStyle(color: Colors.red),
                      );
                    }

                    bool isAdmin = snapshot.data ?? false;
                    return PopupMenuButton<String>(
                      onSelected: (String value) {
                        if (value == 'nguoidung') {
                          Navigator.pushNamed(context, '/thanhVien');
                        } else if (value == 'dangxuat') {
                          _usercontroller.logout();
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/dangNhap', (route) => false);
                        } else if (value == 'duyetdonhang') {
                          Navigator.pushNamed(context, '/duyetDonHang');
                        }
                      },
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<String>(
                            value: 'nguoidung',
                            child: const Text('Thông tin người dùng'),
                          ),
                          PopupMenuItem<String>(
                            value: 'dangxuat',
                            child: const Text('Đăng xuất'),
                          ),
                          if (isAdmin)
                            PopupMenuItem<String>(
                              value: 'duyetdonhang',
                              child: const Text('Duyệt đơn hàng'),
                            ),
                        ];
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
