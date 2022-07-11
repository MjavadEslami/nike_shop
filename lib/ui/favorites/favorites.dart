import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_shop/data/favorite_manager.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/ui/product/detail.dart';
import 'package:nike_shop/ui/widgets/image.dart';

class FavoritesListScreen extends StatelessWidget {
  const FavoritesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست علاقه مندها'),
      ),
      body: ValueListenableBuilder<Box<ProductEntity>>(
          valueListenable: favoriteManger.listenable,
          builder: (context, box, child) {
            final products = box.values.toList();
            return ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 100),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(product: products[index])));
                    },
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: AlertDialog(
                                title: const Text('حذف محصول'),
                                content: const Text(
                                    'آیا مایل به حذف این محصول از لیست خود هستید ؟'),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            favoriteManger
                                                .delete(products[index]);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('بله')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('خیر')),
                                    ],
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 110,
                            height: 110,
                            child: ImageLoadinServise(
                              imageUrl: products[index].imageUrl,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(products[index].title),
                              const SizedBox(
                                height: 24,
                              ),
                              Text(
                                products[index].previousPrice.toString() +
                                    ' تومان ',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .apply(
                                        decoration: TextDecoration.lineThrough),
                              ),
                              Text(
                                products[index].price.toString() + ' تومان ',
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
