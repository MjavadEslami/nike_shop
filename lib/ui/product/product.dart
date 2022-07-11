import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_shop/data/favorite_manager.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/ui/product/detail.dart';
import 'package:nike_shop/ui/widgets/image.dart';

class ProductItem extends StatefulWidget {
  const ProductItem(
      {Key? key, required this.product, required this.borderRadius})
      : super(key: key);

  final ProductEntity product;
  final BorderRadius borderRadius;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4),
        child: InkWell(
          borderRadius: widget.borderRadius,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                    product: widget.product,
                  ))),
          child: SizedBox(
            width: 176,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 0.93,
                      child: ImageLoadinServise(
                        imageUrl: widget.product.imageUrl,
                        borderRadius: widget.borderRadius,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: InkWell(
                        onTap: () {
                          if (!favoriteManger.isFavorite(widget.product)) {
                            favoriteManger.addFavorite(widget.product);
                          } else {
                            favoriteManger.delete(widget.product);
                          }
                          setState(() {});
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          width: 32,
                          height: 32,
                          child: Icon(
                            favoriteManger.isFavorite(widget.product)
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            size: 20,
                            color: favoriteManger.isFavorite(widget.product)
                                ? Colors.pink
                                : Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.product.title,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Text(
                    widget.product.previousPrice.toString() + ' تومان ',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(decoration: TextDecoration.lineThrough),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Text(widget.product.price.toString() + ' تومان '),
                )
              ],
            ),
          ),
        ));
  }
}
