import 'package:dio/dio.dart';
import 'package:nike_shop/data/common/http_resoponse_validator.dart';
import 'package:nike_shop/data/order.dart';
import 'package:nike_shop/data/payment.dart';

abstract class IOrderDataSource {
  Future<CreateOrderResult> create(CreateOrderParams params);
  Future<PaymentData> getPayment(int orderId);
}

class OrderRemoteDataSource
    with HttpResponseValidtor
    implements IOrderDataSource {
  final Dio httpClient;

  OrderRemoteDataSource(this.httpClient);
  @override
  Future<CreateOrderResult> create(CreateOrderParams params) async {
    final response = await httpClient.post('order/submit', data: {
      'first_name': params.firstName,
      'last_name': params.lastName,
      'postal_code': params.postalCode,
      'mobile': params.phoneNumber,
      'address': params.address,
      'payment_method': params.paymentMethod == PaymentMethod.online
          ? 'online'
          : 'cash_on_delivery'
    });

    validateResponse(response);
    return CreateOrderResult.fromJson(response.data);
  }

  @override
  Future<PaymentData> getPayment(int orderId) async {
    final response = await httpClient.get('order/checkout?order_id=$orderId');
    return PaymentData.formJson(response.data);
  }
}
