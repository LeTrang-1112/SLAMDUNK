import 'dart:convert';
import 'package:doanchuyennganh/Model/ChiTietDonHangAdmin.dart';
import 'package:http/http.dart' as http;
import 'package:doanchuyennganh/config.dart';
import 'UserController.dart';

class Admincontroller {
  Usercontroller _usercontroller = Usercontroller();
  Future<Map<String, dynamic>> hienThiDanhSachDonHang() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/donhang'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Không thể tải tổng số lượng sản phẩm đã bán');
    }
  }

  Future<Map<String, dynamic>> getOrders(int id) async {
    final response =
        await http.get(Uri.parse('${AppConfig.baseUrl}/donhang/{id}'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Không thể tải danh sách đơn hàng');
    }
  }

  // Hàm lấy đánh giá cho sản phẩm
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
    } else {
      return {'hasReview': false};
    }
  }

  Future<bool> checkIfAdmin() async {
    int? id = 0;
    String? userIdString = await _usercontroller.getNguoiDungId();
    if (userIdString != null) {
      id = int.tryParse(userIdString);
      print(id);
    }
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/nguoidung/$id'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data['IsAdmin'] == 1;
    } else {
      throw Exception('Không thể lấy dữ liệu người dùng');
    }
  }

  Future<ChiTietDonHang> fetchChiTietDonHang(int id) async {
    final response =
        await http.get(Uri.parse('${AppConfig.baseUrl}/donhang/$id'));

    if (response.statusCode == 200) {
      return ChiTietDonHang.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to load order details');
    }
  }
}
