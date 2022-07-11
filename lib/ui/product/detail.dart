import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';
import 'package:nike_shop/theme.dart';
import 'package:nike_shop/ui/product/bloc/product_bloc.dart';
import 'package:nike_shop/ui/product/comments/comments_list.dart';
import 'package:nike_shop/ui/widgets/image.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductEntity product;
  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  StreamSubscription<ProductState>? streamSubscription;
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScaffoldMessenger(
        key: _globalKey,
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: SizedBox(
            width: MediaQuery.of(context).size.width - 48,
            child: BlocProvider<ProductBloc>(
              create: (context) {
                final bloc = ProductBloc(cartRepository);
                streamSubscription = bloc.stream.listen((state) {
                  if (state is ProductAddToCartSuccess) {
                    _globalKey.currentState?.showSnackBar(const SnackBar(
                        content: Text('با موفقیت به سبد اضافه شد')));
                  } else if (state is ProductAddToCartError) {
                    _globalKey.currentState?.showSnackBar(
                        SnackBar(content: Text(state.exception.message)));
                  }
                });
                return bloc;
              },
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) => FloatingActionButton.extended(
                    onPressed: () {
                      BlocProvider.of<ProductBloc>(context)
                          .add(AddToCartButton(widget.product.id));
                    },
                    label: state is ProductAddToCartLoading
                        ? const CupertinoActivityIndicator(
                            color: Colors.white,
                          )
                        : const Text('افزودن به سبد خرید')),
              ),
            ),
          ),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: MediaQuery.of(context).size.width * 0.8,
                flexibleSpace: FlexibleSpaceBar(
                  background:
                      ImageLoadinServise(imageUrl: widget.product.imageUrl),
                ),
                foregroundColor: LightThemeColor.praimaryTextColor,
                backgroundColor: Colors.white,
                actions: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(CupertinoIcons.heart))
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            widget.product.title,
                            style: Theme.of(context).textTheme.headline6,
                          )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.product.previousPrice.toString() +
                                    " تومان",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .apply(
                                        decoration: TextDecoration.lineThrough),
                              ),
                              Text(widget.product.price.toString() + ' تومان')
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text(
                          'این کتونی شدیدا برای دویدن و راه رفتن مناسب است و تقریبا هیچ فشار مخربی را به پا و زانوی شما انتقال نمیدهد.'),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'نظرات کابران',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          TextButton(
                              onPressed: () {}, child: const Text('ثبت نظر'))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              CommentsList(product: widget.product),
              const SliverToBoxAdapter(
                child: SizedBox(height: 75),
              )
            ],
          ),
        ),
      ),
    );
  }
}
