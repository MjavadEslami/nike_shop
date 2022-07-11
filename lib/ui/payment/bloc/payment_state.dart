part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final PaymentData paymentData;

  const PaymentSuccess(this.paymentData);
  @override
  List<Object> get props => [paymentData];
}

class PaymentError extends PaymentState {
  final AppException appException;

  const PaymentError(this.appException);
  @override
  List<Object> get props => [appException];
}
