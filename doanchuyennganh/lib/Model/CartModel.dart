class CartItem {
  final int cartItemId;
  final int productId;
  final String name;
  final String image;
  final double price;
  int quantity;
  bool isSelected;

  CartItem({
    required this.cartItemId,
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    this.isSelected = false, // Thêm isSelected để theo dõi lựa chọn sản phẩm
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cart_item_id'],
      productId: json['product_id'],
      name: json['name'],
      image: json['image'],
      price: double.parse(json['price']),
      quantity: json['quantity'],
      isSelected: false, // Mặc định là không chọn
    );
  }
}

class Cart {
  final int cartId;
  final double totalPrice;
  final List<CartItem> items;

  Cart({
    required this.cartId,
    required this.totalPrice,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: json['cart_id'],
      totalPrice: double.parse(json['total_price']),
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }
}
