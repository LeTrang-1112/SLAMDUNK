import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'package:doanchuyennganh/Model/DonHangModel.dart';

class OrderController {
  Future<OrderResponseModel> createOrder(OrderRequestModel orderRequest) async {
    final url = Uri.parse('${AppConfig.baseUrl}/showPayment');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderRequest.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return OrderResponseModel.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
            "Lỗi từ server: ${errorData['message'] ?? 'Không rõ nguyên nhân'}");
      }
    } catch (e) {
      throw Exception("Lỗi kết nối: $e");
    }
  }

  Future<Order_ResponseModel> placeOrder(
      Order_RequestModel orderRequest) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/oder'), // Endpoint của API
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderRequest.toJson()),
    );

    if (response.statusCode == 200) {
      return Order_ResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Không thể đặt hàng');
    }
  }
}
