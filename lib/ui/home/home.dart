import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/data/repo/banner_repository.dart';
import 'package:nike_shop/data/repo/product_repository.dart';
import 'package:nike_shop/ui/home/bloc/home_bloc.dart';
import 'package:nike_shop/ui/list/list.dart';
import 'package:nike_shop/ui/product/product.dart';
import 'package:nike_shop/ui/widgets/error.dart';
import 'package:nike_shop/ui/widgets/slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeBlock = HomeBloc(
            bannerRepository: bannerRepository,
            productRepository: produtRepository);
        homeBlock.add(HomeStarted());
        return homeBlock;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SafeArea(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeSuccess) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (conext, index) {
                      switch (index) {
                        case 0:
                          return Container(
                            height: 56,
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/nike_logo.png',
                              height: 28,
                              fit: BoxFit.fitHeight,
                            ),
                          );
                        case 2:
                          return BannerSlider(
                            banners: state.banners,
                          );
                        case 3:
                          return _HorizantalProductList(
                            title: 'جدید ترین',
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (conext) => const ProductListScreen(
                                      sort: ProductSort.latest)));
                            },
                            products: state.latestProducts,
                          );
                        case 4:
                          return _HorizantalProductList(
                            title: 'پربازدید ترین',
                            onTap: () {
                               Navigator.of(context).push(MaterialPageRoute(
                                  builder: (conext) => const ProductListScreen(
                                      sort: ProductSort.pupolar)));
                            },
                            products: state.popularProducts,
                          );
                        default:
                          return Container();
                      }
                    },
                  );
                } else if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HomeError) {
                  return AppErrorWidget(
                    exception: state.exception,
                    onPressed: () {
                      BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                    },
                  );
                } else {
                  throw Exception('state is not supported !');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _HorizantalProductList extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final List<ProductEntity> products;
  const _HorizantalProductList(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.products})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12, left: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              TextButton(onPressed: onTap, child: const Text('مشاهده همه'))
            ],
          ),
        ),
        SizedBox(
          height: 290,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (conext, index) {
                  final product = products[index];
                  return ProductItem(
                    product: product,
                    borderRadius: BorderRadius.circular(12),
                  );
                }),
          ),
        )
      ],
    );
  }
}
