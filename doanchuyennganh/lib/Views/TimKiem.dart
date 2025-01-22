import 'dart:convert';
import 'package:doanchuyennganh/Views/TrangChu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doanchuyennganh/Model/SanPhamModel.dart';
import 'package:doanchuyennganh/Controller/ProductController.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  List<SanPham> _allProducts = []; // Danh sách tất cả sản phẩm
  List<SanPham> _searchResults = []; // Kết quả tìm kiếm
  SanPhamController _sanPhamController = SanPhamController();

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Gọi hàm tải sản phẩm từ API
  }

  // Hàm tải dữ liệu sản phẩm từ API
  Future<void> _fetchProducts() async {
    try {
      List<SanPham> products = await _sanPhamController.fetchSanPham();
      setState(() {
        _allProducts = products; // Lưu vào danh sách tất cả sản phẩm
        _searchResults = products; // Hiển thị tất cả sản phẩm ban đầu
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void _search(String query) {
    setState(() {
      _searchResults = _allProducts
          .where((product) =>
              product.tenSanPham.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5E3023),
        title: const Text('Tìm kiếm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    imageUrl: _searchResults[index].hinhAnh.toString(),
                    title: _searchResults[index].tenSanPham,
                    price: _searchResults[index].gia.toString(),
                    discount: _searchResults[index].giaTriGiam?.toDouble(),
                    id: _searchResults[index].sanPhamId,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
