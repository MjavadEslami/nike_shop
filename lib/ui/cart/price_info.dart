import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nike_shop/theme.dart';

class PriceInfo extends StatelessWidget {
  final int payablePrice;
  final int shippingPrice;
  final int totalPrice;

  const PriceInfo(
      {Key? key,
      required this.payablePrice,
      required this.shippingPrice,
      required this.totalPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.decimalPattern();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 8, 0),
          child: Text(
            'جزئیات خرید',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(8, 8, 8, 32),
          decoration: BoxDecoration(
              color: LightThemeColor.surfaceColor,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
              ]),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('مبلغ کل خرید'),
                    RichText(
                      text: TextSpan(
                          text: numberFormat.format(totalPrice),
                          style: DefaultTextStyle.of(context).style.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          children: [
                            TextSpan(
                                text: ' تومان ',
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(fontWeight: FontWeight.normal))
                          ]),
                    )
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('هزینه ارسال'),
                    RichText(
                        text: TextSpan(
                            text: numberFormat.format(shippingPrice + 100),
                            style: DefaultTextStyle.of(context).style.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 18),
                            children: [
                          TextSpan(
                              text: ' تومان ',
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(fontWeight: FontWeight.normal))
                        ]))
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('مبلغ قابل پرداخت'),
                    RichText(
                        text: TextSpan(
                            text: numberFormat.format(payablePrice),
                            style: DefaultTextStyle.of(context).style.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 18),
                            children: [
                          TextSpan(
                              text: ' تومان ',
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(fontWeight: FontWeight.normal))
                        ]))
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
