import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_shop/data/repo/auth_repository.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';
import 'package:nike_shop/theme.dart';
import 'package:nike_shop/ui/auth/auth.dart';
import 'package:nike_shop/ui/cart/bloc/cart_bloc.dart';
import 'package:nike_shop/ui/cart/price_info.dart';
import 'package:nike_shop/ui/shipping/shipping.dart';
import 'package:nike_shop/ui/widgets/empty_state.dart';
import 'package:nike_shop/ui/widgets/error.dart';
import 'package:nike_shop/ui/widgets/image.dart';
import 'package:nike_shop/ui/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final CartBloc cartBloc;
  StreamSubscription? _streamSubscription;
  final RefreshController _refreshController = RefreshController();

  bool stateIsSuccess = false;

  @override
  void initState() {
    super.initState();
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
  }

  void authChangeNotifierListener() {
    cartBloc.add(CartAuthInfoChanged(AuthRepository.authChangeNotifier.value));
  }

  @override
  void dispose() {
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    cartBloc.close();
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('سبد خرید'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: stateIsSuccess,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 96,
          child: FloatingActionButton.extended(
              onPressed: () {
                final state = cartBloc.state;
                if (state is CartSuccess) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ShippingScreen(
                        shippingPrice: state.response.shippingCost,
                        payablePrice: state.response.payablePrice,
                        totalPrice: state.response.totalPrice,
                      ),
                    ),
                  );
                }
              },
              label: const Text('پرداخت')),
        ),
      ),
      body: BlocProvider<CartBloc>(
        create: (context) {
          final bloc = CartBloc(cartRepository);
          _streamSubscription = bloc.stream.listen((state) {
            setState(() {
              stateIsSuccess = (state is CartSuccess);
            });
            if (_refreshController.isRefresh) {
              if (state is CartSuccess) {
                _refreshController.refreshCompleted();
              } else if (state is CartError) {
                _refreshController.refreshFailed();
              }
            }
          });
          cartBloc = bloc;
          bloc.add(CartStarted(AuthRepository.authChangeNotifier.value));
          return bloc;
        },
        child: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
          if (state is CartLoading) {
            return const AppLoadingWidget();
          } else if (state is CartError) {
            return AppErrorWidget(exception: state.exception, onPressed: () {});
          } else if (state is CartSuccess) {
            return SmartRefresher(
              onRefresh: () {
                cartBloc.add(CartStarted(
                    AuthRepository.authChangeNotifier.value,
                    isRefreshing: true));
              },
              controller: _refreshController,
              header: const ClassicHeader(
                completeText: 'با موفقیت انجام شد',
                refreshingText: 'درحال بارگذاری',
                idleText: 'پایین بکشید',
                releaseText: 'رها کنید',
                spacing: 2,
              ),
              child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 60),
                  itemCount: state.response.cartItems.length + 1,
                  itemBuilder: (context, index) {
                    if (index < state.response.cartItems.length) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1))
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: ImageLoadinServise(
                                      imageUrl: state.response.cartItems[index]
                                          .product.imageUrl,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        state.response.cartItems[index].product
                                            .title,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      const Text('تعداد'),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              cartBloc.add(
                                                  IncreaseCountButtonClicked(
                                                      state
                                                          .response
                                                          .cartItems[index]
                                                          .id));
                                            },
                                            icon: const Icon(
                                                CupertinoIcons.plus_rectangle),
                                          ),
                                          state.response.cartItems[index]
                                                  .changeCountLoading
                                              ? const CupertinoActivityIndicator()
                                              : Text(
                                                  state.response
                                                      .cartItems[index].count
                                                      .toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6,
                                                ),
                                          IconButton(
                                            onPressed: () {
                                              if (state.response
                                                      .cartItems[index].count >
                                                  1) {
                                                cartBloc.add(
                                                    DecreaseCountButtonClicked(
                                                        state
                                                            .response
                                                            .cartItems[index]
                                                            .id));
                                              }
                                            },
                                            icon: const Icon(
                                                CupertinoIcons.minus_rectangle),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        state.response.cartItems[index].product
                                                .previousPrice
                                                .toString() +
                                            ' تومان ',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: LightThemeColor
                                                .secendaryTextColor,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                      Text(state.response.cartItems[index]
                                              .product.price
                                              .toString() +
                                          ' تومان '),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Divider(
                              height: 2,
                            ),
                            state.response.cartItems[index].deleteButtonLoading
                                ? const SizedBox(
                                    height: 48,
                                    child: Center(
                                      child: CupertinoActivityIndicator(),
                                    ),
                                  )
                                : TextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: AlertDialog(
                                                title: const Text('حذف از سبد'),
                                                content: const Text(
                                                    'آیا مایل به حذف این محصول از سبد خرید خود هستید ؟'),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            cartBloc.add(
                                                                CartDeleteButtonClicked(state
                                                                    .response
                                                                    .cartItems[
                                                                        index]
                                                                    .id));
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              'بله')),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text('خیر'))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: const Text('حذف از سبد خرید'))
                          ],
                        ),
                      );
                    } else {
                      return PriceInfo(
                        payablePrice: state.response.payablePrice,
                        totalPrice: state.response.totalPrice,
                        shippingPrice: state.response.shippingCost,
                      );
                    }
                  }),
            );
          } else if (state is CartAuthRequired) {
            return EmptyView(
                message: "وارد حساب کاربری خود شود",
                callToAction: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AuthScreen()));
                    },
                    child: const Text('ورود')),
                image: SvgPicture.asset(
                  'assets/images/auth_required.svg',
                  width: 140,
                ));
          } else if (state is CartEmpty) {
            return SmartRefresher(
              onRefresh: () {
                cartBloc.add(CartStarted(
                    AuthRepository.authChangeNotifier.value,
                    isRefreshing: true));
              },
              controller: _refreshController,
              header: const ClassicHeader(
                completeText: 'با موفقیت انجام شد',
                refreshingText: 'درحال بارگذاری',
                idleText: 'پایین بکشید',
                releaseText: 'رها کنید',
                spacing: 2,
              ),
              child: EmptyView(
                  message: "سبد خرید شما خالی می باشد",
                  image: SvgPicture.asset(
                    'assets/images/empty_cart.svg',
                    width: 200,
                  )),
            );
          } else {
            return const Text('data');
          }
        }),
      ),
    );
  }
}
