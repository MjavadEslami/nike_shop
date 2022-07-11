import 'package:flutter/foundation.dart';
import 'package:nike_shop/data/cart_response.dart';
import 'package:nike_shop/data/common/http_client.dart';
import 'package:nike_shop/data/add_to_cart_response.dart';
import 'package:nike_shop/data/repo/auth_repository.dart';
import 'package:nike_shop/data/source/cart_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ICartRepository {
  Future<AddToCartResponse> add(int productId);
  Future<AddToCartResponse> changeCunt(int cartItemId, int count);
  Future<void> delete(int cartItemId);
  Future<int> count();
  Future<CartResponse> getAll();
}

final cartRepository = CartRepository(CartRemoteDataSource(httClient));

class CartRepository implements ICartRepository {
  final ICartDataSource dataSource;

  static ValueNotifier<int> cartItemCountNotifier = ValueNotifier(0);

  CartRepository(this.dataSource);
  @override
  Future<AddToCartResponse> add(int productId) {
    return dataSource.add(productId);
  }

  @override
  Future<AddToCartResponse> changeCunt(int cartItemId, int count) {
    return dataSource.changeCunt(cartItemId, count);
  }

  @override
  Future<int> count() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final String accessToken =
        sharedPreferences.getString('access_token') ?? '';
        
    if (accessToken.isNotEmpty) {
      final count = await dataSource.count();
      cartItemCountNotifier.value = count;
      return count;
    }
    return 0;
  }

  @override
  Future<void> delete(int cartItemId) {
    return dataSource.delete(cartItemId);
  }

  @override
  Future<CartResponse> getAll() {
    return dataSource.getAll();
  }
}
