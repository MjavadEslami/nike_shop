import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_shop/common/exception.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ICartRepository repository;
  ProductBloc(this.repository) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is AddToCartButton) {
        try {
          emit(ProductAddToCartLoading());
          await repository.add(event.productId);
          await cartRepository.count();
          emit(ProductAddToCartSuccess());
        } catch (e) {
          if (e is DioError) {
            emit(ProductAddToCartError(
                AppException(message: e.response!.data['message'])));
          }
        }
      }
    });
  }
}
