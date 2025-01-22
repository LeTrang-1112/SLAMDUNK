import 'package:doanchuyennganh/Model/ChiTietSanPhamModel.dart';
import 'package:doanchuyennganh/Model/SanPhamModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doanchuyennganh/config.dart';
import 'package:doanchuyennganh/Model/DanhGiaModel.dart';

class SanPhamController {
  Future<List<SanPham>> fetchSanPham() async {
    try {
      final response =
          await http.get(Uri.parse('${AppConfig.baseUrl}/products'));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => SanPham.fromJson(item)).toList();
      } else {
        print('Response body: ${response.body}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error: $e');
    }
  }

  Future<ChiTietSanPham?> fetchSanPhamById(int id) async {
    final response =
        await http.get(Uri.parse('${AppConfig.baseUrl}/product/$id'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ChiTietSanPham.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<List<DanhGia>> fetchDanhGias(int sanPhamId) async {
    final response =
        await http.get(Uri.parse('${AppConfig.baseUrl}/danhgia/$sanPhamId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => DanhGia.fromJson(item)).toList();
    } else {
      throw Exception('Không thể tải danh sách đánh giá');
    }
  }
}
