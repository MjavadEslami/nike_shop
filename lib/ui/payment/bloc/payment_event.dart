part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class PaymentStarted extends PaymentEvent {
  final int orderId;

  const PaymentStarted(this.orderId);
  @override
  List<Object> get props => [orderId];
}
