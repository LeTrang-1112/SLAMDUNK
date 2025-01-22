// import 'package:flutter/material.dart';

// class ChiTietDonHangScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> orders = [
//     {
//       'id': '#1',
//       'productName': 'Bóng rổ',
//       'quantity': 2,
//       'price': 500000,
//       'totalPrice': 1000000,
//       'image': 'assets/bongro_hong.png',
//     },
//     {
//       'id': '#2',
//       'productName': 'Bóng rổ',
//       'quantity': 1,
//       'price': 500000,
//       'sale': '50%',
//       'totalPrice': 250000,
//       'image': 'assets/bongro_xanh.png',
//     },
//   ];

//   ChiTietDonHangScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF5E3023),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context); // Quay lại màn hình trước
//           },
//         ),
//         title: const Text(
//           'Chi tiết đơn',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Thông tin đơn',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: orders.length,
//                 itemBuilder: (context, index) {
//                   final order = orders[index];
//                   return Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 3,
//                     margin: const EdgeInsets.only(bottom: 16),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Row(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.asset(
//                               'assets/download.png'
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Mã đơn hàng: ${order['id']}',
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Tên sản phẩm: ${order['productName']}',
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                                 Text(
//                                   'Số lượng: ${order['quantity']}',
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                                 Text(
//                                   'Giá: ${order['price'].toString()}',
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                                 if (order.containsKey('sale'))
//                                   Text(
//                                     'Sale: ${order['sale']}',
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Tổng tiền: ${order['totalPrice'].toString()}',
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.teal,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
