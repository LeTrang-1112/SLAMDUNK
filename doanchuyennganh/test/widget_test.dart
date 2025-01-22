import 'package:doanchuyennganh/Views/DangNhap.dart';
import 'package:doanchuyennganh/Views/TrangChu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doanchuyennganh/main.dart';

void main() {
  testWidgets('Điều hướng đến màn hình đăng nhập khi chưa đăng nhập',
      (WidgetTester tester) async {
    // Khởi chạy ứng dụng với trạng thái chưa đăng nhập.
    await tester.pumpWidget(MainApp(isLoggedIn: false));

    // Kiểm tra xem có màn hình đăng nhập không.
    expect(find.byType(ManHinhDangNhap), findsOneWidget);
  });

  testWidgets('Điều hướng đến màn hình trang chủ khi đã đăng nhập',
      (WidgetTester tester) async {
    // Khởi chạy ứng dụng với trạng thái đã đăng nhập.
    await tester.pumpWidget(MainApp(isLoggedIn: true));

    // Kiểm tra xem có màn hình trang chủ không.
    expect(find.byType(TrangChu), findsOneWidget);
  });
}
