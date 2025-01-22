import 'package:flutter/material.dart';

class ManHinhTrangChuNew extends StatefulWidget {
  const ManHinhTrangChuNew({super.key});

  @override
  State<ManHinhTrangChuNew> createState() => ManHinhTrangChuNewState();
}

class ManHinhTrangChuNewState extends State<ManHinhTrangChuNew> {
  int _currentIndex = 0;
  int _selectedTab = 0;

  // Danh sách giá và tên của các sản phẩm
  final List<String> productNames = [
    "Quả Bóng Da Size 7 Li-Ning Badfive",
    "Quả Bóng Da Size 6 Li-Ning Badfive",
    "Quả Bóng Da Size 5 Li-Ning Badfive",
    "Quả Bóng Da Size 7 Li-Ning Badfive",
  ];

  final List<String> productPrices = [
    "1.500.000", // Giá sản phẩm 1
    "2.000.000", // Giá sản phẩm 2
    "2.500.000", // Giá sản phẩm 3
    "3.000.000", // Giá sản phẩm 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // Header
          Container(
            height: 160,
            decoration: const BoxDecoration(
              color: Color(0xFF5E3023),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(50),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        const Text(
                          '3TL SLAMDUNK',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Giỏ hàng')),
                            );
                          },
                          icon: const Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Welcome to the Basketball store',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterTab(
                  title: "All",
                  isSelected: _selectedTab == 0,
                  onTap: () {
                    setState(() {
                      _selectedTab = 0;
                    });
                  },
                ),
                FilterTab(
                  title: "New",
                  isSelected: _selectedTab == 1,
                  onTap: () {
                    setState(() {
                      _selectedTab = 1;
                    });
                  },
                ),
                FilterTab(
                  title: "Run",
                  isSelected: _selectedTab == 2,
                  onTap: () {
                    setState(() {
                      _selectedTab = 2;
                    });
                  },
                ),
                FilterTab(
                  title: "Sale",
                  isSelected: _selectedTab == 3,
                  onTap: () {
                    setState(() {
                      _selectedTab = 3;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Product grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return ProductCard(
                  imageUrl: 'assets/images/${index + 1}.jpg',
                  title: productNames[index], // Dùng tên sản phẩm khác nhau
                  price: productPrices[
                      index], // Sử dụng giá khác nhau cho mỗi sản phẩm
                  isNew:
                      true, // Thêm thuộc tính để kiểm tra xem có phải sản phẩm mới không
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(color: Colors.red),
        unselectedLabelStyle: const TextStyle(color: Colors.red),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

// Tab Button Component
class FilterTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterTab({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.red : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: Text(title),
    );
  }
}

// Product Card Component
class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final bool isNew;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.isNew = false,
    int? discount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Giá: $price", // Hiển thị giá gốc của sản phẩm
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          if (isNew)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  'New',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
