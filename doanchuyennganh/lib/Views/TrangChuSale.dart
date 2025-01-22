import 'package:doanchuyennganh/Model/SanPhamModel.dart';
import 'package:doanchuyennganh/Views/TrangChu.dart';
import 'package:flutter/material.dart';

class DiscountedProductsScreen extends StatelessWidget {
  final List<SanPham> products;

  const DiscountedProductsScreen({Key? key, required this.products})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    double screenWidth = MediaQuery.of(context).size.width;

    // Xác định số cột dựa vào kích thước màn hình
    int crossAxisCount = screenWidth > 600
        ? 3
        : 2; // Nếu màn hình rộng hơn 600px, hiển thị 3 cột, nếu không thì 2 cột

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sản Phẩm Khuyến Mãi'),
      ),
      body: products.isEmpty
          ? const Center(child: Text('Không có sản phẩm giảm giá'))
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount, // Số cột
                crossAxisSpacing: 8, // Khoảng cách giữa các cột
                mainAxisSpacing: 8, // Khoảng cách giữa các hàng
                childAspectRatio:
                    0.75, // Tỷ lệ kích thước của từng sản phẩm (tùy chỉnh)
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  imageUrl: product.hinhAnh.toString(),
                  title: product.tenSanPham,
                  price: product.gia.toString(),
                  discount: product.giaTriGiam?.toDouble(),
                  id: product.sanPhamId,
                );
              },
            ),
    );
  }
}
