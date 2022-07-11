import 'package:nike_shop/data/common/http_client.dart';
import 'package:nike_shop/data/order.dart';
import 'package:nike_shop/data/payment.dart';
import 'package:nike_shop/data/source/order_data_source.dart';

abstract class IOrderRepository {
  Future<CreateOrderResult> create(CreateOrderParams params);
  Future<PaymentData> getPayment(int orderId);
}

final orderRepository = OrderRepository(OrderRemoteDataSource(httClient));

class OrderRepository implements IOrderRepository {
  final IOrderDataSource dataSource;

  OrderRepository(this.dataSource);
  @override
  Future<CreateOrderResult> create(CreateOrderParams params) {
    return dataSource.create(params);
  }

  @override
  Future<PaymentData> getPayment(int orderId) {
    return dataSource.getPayment(orderId);
  }
}
