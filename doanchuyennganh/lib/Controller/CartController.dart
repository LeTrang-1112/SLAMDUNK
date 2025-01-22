import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doanchuyennganh/Model/ChiTietGioHangModel.dart';
import 'package:doanchuyennganh/config.dart';

class CartController {
  static const String apiUrl =
      'http://192.168.1.140:8000/api/cart'; // Địa chỉ API của bạn

  Future<CartResponse> addToCart(CartRequest cartRequest) async {
    final response = await http.post(
      Uri.parse("${AppConfig.baseUrl}/cart"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cartRequest.toJson()),
    );

    if (response.statusCode == 200) {
      return CartResponse.fromJson(json.decode(response.body));
    } else {
      print('Error: ${response.body}');
      throw Exception('Failed to add product to cart');
    }
  }

  Future<Cart?> getCart(int userId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/showCart?NguoiDungId=$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Cart.fromJson(data);
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    return null;
  }
}
