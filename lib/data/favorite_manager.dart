import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_shop/data/product.dart';

final favoriteManger = FavoriteManager();

class FavoriteManager {
  static const String _boxName = 'favorites';
  final _box = Hive.box<ProductEntity>(_boxName);

  ValueListenable<Box<ProductEntity>> get listenable =>
      Hive.box<ProductEntity>(_boxName).listenable();


  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductEntityAdapter());
    Hive.openBox<ProductEntity>(_boxName);
  }

  void addFavorite(ProductEntity product) {
    _box.put(product.id, product);
  }

  void delete(ProductEntity product) {
    _box.delete(product.id);
  }

  List<ProductEntity> get favoriets => _box.values.toList();

  bool isFavorite(ProductEntity product) {
    return _box.containsKey(product.id);
  }
}
