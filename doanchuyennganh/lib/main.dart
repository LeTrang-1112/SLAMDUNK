import 'package:doanchuyennganh/Views/QuenMatKhau.dart';
import 'package:doanchuyennganh/Views/TimKiem.dart';
import 'package:doanchuyennganh/Views/TrangChuSale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'Views/ChiTietDonHangAdmin.dart';
import 'Views/ChiTietSanPham.dart';
import 'Views/DuyetDonHang.dart';
import 'Views/ThanhToan.dart';
import 'Views/GioHang.dart';
import 'Views/Thanhvien.dart';
import 'Views/Thaydoimatkhau.dart';
import 'Views/ThongTinNguoiDung.dart';
import 'Views/DangNhap.dart';
import 'Views/DangKy.dart';
import 'Views/LichSuDonHang.dart';
import 'Views/ThongBao.dart';
import 'Views/TrangChu.dart';
import 'Views/TrangchuNew.dart';
import 'Views/Voucher.dart';
import 'Controller/UserController.dart';

void main() async {
  final Usercontroller user = Usercontroller();
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await user.checkLoginStatus();
  print("Login:$isLoggedIn");
  runApp(MainApp(isLoggedIn: isLoggedIn));
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  const MyCustomScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;

  const MainApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MyCustomScrollBehavior(),
      initialRoute: isLoggedIn ? '/trangChu' : '/dangNhap',
      onGenerateRoute: (settings) {
        if (settings.name == '/chiTietSanPham') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ManHinhChiTietSanPham(
              productId: args['productId'], // Truyền tham số
            ),
          );
        } else if (settings.name == '/thanhToan') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ManHinhThanhToan(
              orderResponse: args['orderResponse'], // Truyền tham số
            ),
          );
        } else if (settings.name == '/gioHang') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ManHinhGioHang(
              userId: args['userId'], // Truyền tham số
            ),
          );
        } else if (settings.name == '/chiTietDonHangAdmin') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ManHinhChiTietDonHangAdmin(
              id: args['id'], // Truyền tham số
            ),
          );
        }
        // Các route khác
        return null;
      },
      routes: {
        '/thongTinNguoiDung': (context) => ManHinhThongTinNguoiDung(),
        '/search': (context) => SearchPage(),
        '/dangKy': (context) => const ManHinhDangKy(),
        '/dangNhap': (context) => const ManHinhDangNhap(),
        '/lichSuDonHang': (context) => ManHinhLichSuDonHang(),
        '/trangChuSale': (context) => const DiscountedProductsScreen(
              products: [],
            ),
        '/trangChuNew': (context) => const ManHinhTrangChuNew(),
        '/thongBao': (context) => const ManHinhThongbao(),
        '/voucher': (context) => const Voucher(),
        '/trangChu': (context) => const TrangChu(),
        '/thayDoiMatKhau': (context) => const ManHinhThayDoiMatKhau(),
        '/thanhVien': (context) => const ManHinhThanhVien(),
        '/duyetDonHang': (context) => const DonHangPage(),
        '/quenmatkhau': (context) => ForgotPasswordScreen(),
      },
    );
  }
}
