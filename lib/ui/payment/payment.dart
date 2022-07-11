import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/data/repo/order_repository.dart';
import 'package:nike_shop/theme.dart';
import 'package:nike_shop/ui/payment/bloc/payment_bloc.dart';
import 'package:nike_shop/ui/widgets/error.dart';
import 'package:nike_shop/ui/widgets/loading.dart';

class PaymentScreen extends StatelessWidget {
  final int orderId;
  const PaymentScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('رسید پرداخت'),
      ),
      body: BlocProvider<PaymentBloc>(
        create: (context) {
          final bloc = PaymentBloc(orderRepository)
            ..add(PaymentStarted(orderId));
          return bloc;
        },
        child: BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, state) {
            if (state is PaymentLoading) {
              return const AppLoadingWidget();
            } else if (state is PaymentError) {
              return AppErrorWidget(
                  exception: state.appException,
                  onPressed: () {
                    BlocProvider.of<PaymentBloc>(context)
                        .add(PaymentStarted(orderId));
                  });
            } else if (state is PaymentSuccess) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color:
                                LightThemeColor.praimaryTextColor.withOpacity(
                              0.1,
                            ),
                            width: 1),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white.withOpacity(0.1),
                              blurRadius: 10)
                        ]),
                    child: Column(
                      children: [
                        Icon(
                          CupertinoIcons.checkmark_alt_circle,
                          size: 28,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                        state.paymentData.purchaseSuccess?  'پرداخت با موفقیت انجام شد':'پرداخت نا موفق',
                          style: Theme.of(context).textTheme.headline6!.apply(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'وضعیت سفارش',
                              style: TextStyle(
                                  color: LightThemeColor.secendaryTextColor),
                            ),
                            Text(
                              state.paymentData.paymentStatus,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ],
                        ),
                        const Divider(
                          height: 32,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'مبلغ',
                              style: TextStyle(
                                  color: LightThemeColor.secendaryTextColor),
                            ),
                            RichText(
                              text: TextSpan(
                                  text:
                                      state.paymentData.payablePrice.toString(),
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                  children: [
                                    TextSpan(
                                        text: ' تومان ',
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .copyWith(
                                                fontWeight: FontWeight.normal))
                                  ]),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: const Text('بازگشت به صفحه اصلی'))
                ],
              );
            } else {
              return const Text('error');
            }
          },
        ),
      ),
    );
  }
}
