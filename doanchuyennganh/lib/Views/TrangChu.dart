import 'package:doanchuyennganh/Views/CustomAppBar.dart';
import 'package:doanchuyennganh/Views/CustomBottom.dart';
import 'package:flutter/material.dart';
import 'package:doanchuyennganh/Controller/ProductController.dart';
import 'package:doanchuyennganh/Model/SanPhamModel.dart';
import 'package:doanchuyennganh/Controller/UserController.dart';

class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  State<TrangChu> createState() => TrangChuState();
}

class TrangChuState extends State<TrangChu> {
  final Usercontroller usercontroller = Usercontroller();
  int _currentIndex = 0;
  final SanPhamController _controller = SanPhamController();
  List<SanPham> _products = [];
  List<SanPham> _discountedProducts = [];
  List<SanPham> _topSellingProducts = [];
  List<SanPham> _productsBackup = [];
  bool _isLoading = true;
  String _errorMessage = '';
  TextEditingController _searchController = TextEditingController();
  bool _showAllDiscounted = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _searchController.addListener(_filterProducts);
  }

  void _filterProducts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _products = List.from(_productsBackup);
      } else {
        _products = _productsBackup
            .where(
                (product) => product.tenSanPham.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _fetchProducts() async {
    try {
      final products = await _controller.fetchSanPham();
      setState(() {
        _products = products;
        _productsBackup = List.from(products);
        _discountedProducts = products
            .where((product) =>
                product.giaTriGiam != null && product.giaTriGiam! > 0)
            .toList();
        _topSellingProducts = products;
        _isLoading = false;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load products: $e';
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_errorMessage)));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 1),
          const SizedBox(height: 8),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _errorMessage,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      if (_discountedProducts.isNotEmpty)
                        _buildDiscountedProductsSection(),
                      const Text(
                        'Bóng Rổ Chính Hãng',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildTopSellingProductsGrid(),
                    ],
                  ),
                ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavigationBarTapped,
      ),
    );
  }

  Widget _buildDiscountedProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sản Phẩm Khuyến Mãi',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: _showAllDiscounted ? 300 * 2 : 300,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemCount: _showAllDiscounted
                ? _discountedProducts.length
                : (_discountedProducts.length > 4
                    ? 4
                    : _discountedProducts.length),
            itemBuilder: (context, index) {
              final product = _discountedProducts[index];
              return ProductCard(
                imageUrl: product.hinhAnh.toString(),
                title: product.tenSanPham,
                price: product.gia.toString(),
                discount: product.giaTriGiam?.toDouble(),
                id: product.sanPhamId,
              );
            },
          ),
        ),
        // TextButton(
        //   onPressed: () {
        //     setState(() {
        //       _showAllDiscounted = !_showAllDiscounted;
        //     });
        //   },
        //   // child: Text(_showAllDiscounted ? 'Show Less' ),
        // ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTopSellingProductsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: _topSellingProducts.length,
      itemBuilder: (context, index) {
        final product = _topSellingProducts[index];
        return ProductCard(
          imageUrl: product.hinhAnh.toString(),
          title: product.tenSanPham,
          price: product.gia.toString(),
          discount: product.giaTriGiam?.toDouble(),
          id: product.sanPhamId,
        );
      },
    );
  }

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

  void _onBottomNavigationBarTapped(int index) async {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
      Navigator.pushNamed(context, '/trangChu');
    } else if (index == 1) {
      String? userIdString = await usercontroller.getNguoiDungId();
      if (userIdString != null) {
        int? userId = int.tryParse(userIdString);
        Navigator.pushNamed(
          context,
          '/gioHang',
          arguments: {'userId': userId},
        );
      }
    } else if (index == 3) {
      Navigator.pushNamed(context, '/thanhVien');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/search');
    }
  }
}

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final double? discount;
  final int id;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.discount,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(
          context,
          '/chiTietSanPham',
          arguments: {'productId': id},
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Hình ảnh sản phẩm
                Container(
                  width: double.infinity,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Hiển thị % giảm giá
                if (discount != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '-${discount!.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$$price',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
