import 'package:nike_shop/data/product.dart';

class CartItemEntity {
  final ProductEntity product;
  final int id;
  int count;
  bool deleteButtonLoading = false;
  bool changeCountLoading = false;

  CartItemEntity(this.product, this.id, this.count);

  CartItemEntity.formJson(Map<String, dynamic> json)
      : product = ProductEntity.fromJson(json['product']),
        count = json['count'],
        id = json['cart_item_id'];

  static List<CartItemEntity> parseJsonArray(List<dynamic> jsonArray) {
    final List<CartItemEntity> cartItems = [];
    for (var element in jsonArray) {
      cartItems.add(CartItemEntity.formJson(element));
    }
    return cartItems;
  }
}
