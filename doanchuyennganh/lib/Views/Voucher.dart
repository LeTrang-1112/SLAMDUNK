import 'package:doanchuyennganh/Views/CustomAppBar.dart';
import 'package:flutter/material.dart';

class Voucher extends StatefulWidget {
  const Voucher({super.key});
  @override
  State<Voucher> createState() => VoucherState();
}

class VoucherState extends State<Voucher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: Colors.grey[200],
        body: Column(children: [
          // Header
          Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Dòng chữ SLAMDUNK và icon giỏ hàng
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    // child: Row(
                    //   children: [
                    //     const Text(
                    //       '3TL SLAMDUNK',
                    //       style: TextStyle(
                    //         fontSize: 24,
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),

                    //     const Spacer(),
                    //     IconButton(
                    //       onPressed: () {
                    //         // Thực hiện hành động khi nhấn vào icon giỏ hàng
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           const SnackBar(content: Text('Giỏ hàng')),
                    //         );
                    //       },
                    //       icon: const Icon(
                    //         Icons.shopping_cart,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Kho Voucher',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Tất cả",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
          // Voucher List
          Expanded(
              child: ListView(children: [
            // Voucher 1
            VoucherCard(
              icon: Icons.local_shipping,
              iconColor: Colors.green,
              title: "Giảm tối đa 50k",
              subtitle: "Đơn tối thiểu 200k\nHiệu lực: 1 Ngày",
            ),
            // Voucher 2
            VoucherCard(
              icon: Icons.local_shipping,
              iconColor: Colors.green,
              title: "Giảm tối đa 20k",
              subtitle: "Đơn tối thiểu 100k\nHiệu lực: 5 Ngày",
            ),
            // Voucher 3
            VoucherCard(
              icon: Icons.shopping_bag,
              iconColor: Colors.red,
              title: "Giảm tối đa 10k",
              subtitle: "Đơn tối thiểu 50k\nHiệu lực: 1 Ngày",
            ),
            // Voucher 4
            VoucherCard(
              icon: Icons.shopping_bag,
              iconColor: Colors.red,
              title: "Giảm tối đa 60k",
              subtitle: "Đơn tối thiểu 250k\nHiệu lực: 1 Ngày",
            ),
            VoucherCard(
              icon: Icons.shopping_bag,
              iconColor: Colors.red,
              title: "Giảm tối đa 50k",
              subtitle: "Đơn tối thiểu 1  50k\nHiệu lực: 1 Ngày",
            ),
          ]))
        ]));
  }
}

class VoucherCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const VoucherCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 36, color: iconColor),
            ),
            const SizedBox(width: 16),

            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Dùng"),
            ),
          ],
        ),
      ),
    );
  }
}
