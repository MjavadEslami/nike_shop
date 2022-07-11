import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/data/order.dart';
import 'package:nike_shop/data/repo/order_repository.dart';
import 'package:nike_shop/ui/cart/price_info.dart';
import 'package:nike_shop/ui/payment/payment.dart';
import 'package:nike_shop/ui/payment_gateway.dart';
import 'package:nike_shop/ui/shipping/bloc/shipping_bloc.dart';

class ShippingScreen extends StatefulWidget {
  final int payablePrice, shippingPrice, totalPrice;

  const ShippingScreen(
      {Key? key,
      required this.payablePrice,
      required this.shippingPrice,
      required this.totalPrice})
      : super(key: key);

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController postalCodeController = TextEditingController();

  StreamSubscription? subscription;

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحویل گیرنده'),
      ),
      body: BlocProvider(
        create: ((context) {
          final bloc = ShippingBloc(orderRepository);
          subscription = bloc.stream.listen((state) {
            if (state is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.appException.message)));
            } else if (state is ShippingSuccess) {
              if (state.result.bankGateWayUrl.isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PaymentGateWayScreen(
                        bankGateWayUrl: state.result.bankGateWayUrl),
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      orderId: state.result.orderId,
                    ),
                  ),
                );
              }
            }
          });
          return bloc;
        }),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  label: Text('نام'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  label: Text('نام خانوادگی'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: postalCodeController,
                decoration: const InputDecoration(
                  label: Text('کد پستی'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  label: Text('شماره تماس'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  label: Text('آدرس'),
                ),
              ),
              PriceInfo(
                payablePrice: widget.payablePrice,
                shippingPrice: widget.shippingPrice,
                totalPrice: widget.totalPrice,
              ),
              BlocBuilder<ShippingBloc, ShippingState>(
                builder: (context, state) {
                  return state is ShippingLoading
                      ? const CupertinoActivityIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                      ShippingCreateOrder(CreateOrderParams(
                                          firstNameController.text,
                                          lastNameController.text,
                                          postalCodeController.text,
                                          phoneNumberController.text,
                                          addressController.text,
                                          PaymentMethod.cashOnDelivery)));
                                },
                                child: const Text('پرداخت در محل'),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                      ShippingCreateOrder(CreateOrderParams(
                                          firstNameController.text,
                                          lastNameController.text,
                                          postalCodeController.text,
                                          phoneNumberController.text,
                                          addressController.text,
                                          PaymentMethod.online)));
                                },
                                child: const Text('پرداخت اینترنتی'),
                              )
                            ]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
