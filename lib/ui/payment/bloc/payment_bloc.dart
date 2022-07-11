import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_shop/common/exception.dart';
import 'package:nike_shop/data/payment.dart';
import 'package:nike_shop/data/repo/order_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final IOrderRepository orderRepository;
  PaymentBloc(this.orderRepository) : super(PaymentLoading()) {
    on<PaymentEvent>((event, emit) async {
      if (event is PaymentStarted) {
        try {
          emit(PaymentLoading());
          final response = await orderRepository.getPayment(event.orderId);
          emit(PaymentSuccess(response));
        } catch (e) {
          if (e is DioError) {
            emit(PaymentError(
                AppException(message: e.error)));
          }
        }
      }
    });
  }
}
