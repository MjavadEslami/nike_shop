import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:nike_shop/common/exception.dart';
import 'package:nike_shop/data/auth_info.dart';
import 'package:nike_shop/data/cart_response.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository repository;
  CartBloc(this.repository) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          await loadCartItems(emit, event.isRefreshing);
        }
      } else if (event is CartDeleteButtonClicked) {
        try {
          if (state is CartSuccess) {
            final successSatet = (state as CartSuccess);
            final cartItem = successSatet.response.cartItems
                .firstWhere((element) => element.id == event.cartItemId);
            cartItem.deleteButtonLoading = true;
            await cartRepository.count();

            emit(CartSuccess(successSatet.response));
          }
          await Future.delayed(const Duration(milliseconds: 200));
          await cartRepository.delete(event.cartItemId);
          if (state is CartSuccess) {
            final successSatet = (state as CartSuccess);
            successSatet.response.cartItems
                .removeWhere((element) => element.id == event.cartItemId);
            await cartRepository.count();

            if (successSatet.response.cartItems.isEmpty) {
              emit(CartEmpty());
            } else {
              emit(calculatePriceInfo(successSatet.response));
            }
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      } else if (event is CartAuthInfoChanged) {
        if (event.authInfo == null || event.authInfo!.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          if (state is CartAuthRequired) {
            await loadCartItems(emit, false);
          }
        }
      } else if (event is IncreaseCountButtonClicked ||
          event is DecreaseCountButtonClicked) {
        int cartItemId = 0;
        if (event is IncreaseCountButtonClicked) {
          cartItemId = event.cartItemId;
        } else if (event is DecreaseCountButtonClicked) {
          cartItemId = event.cartItemId;
        }
        try {
          if (state is CartSuccess) {
            final successSatet = (state as CartSuccess);
            final cartItem = successSatet.response.cartItems
                .firstWhere((element) => element.id == cartItemId);
            cartItem.changeCountLoading = true;
            emit(CartSuccess(successSatet.response));
            await Future.delayed(const Duration(milliseconds: 200));

            final newCount = event is IncreaseCountButtonClicked
                ? ++successSatet.response.cartItems
                    .firstWhere((element) => element.id == cartItemId)
                    .count
                : --successSatet.response.cartItems
                    .firstWhere((element) => element.id == cartItemId)
                    .count;

            await cartRepository.changeCunt(cartItemId, newCount);

            successSatet.response.cartItems
                .firstWhere((element) => element.id == cartItemId)
              ..count = newCount
              ..changeCountLoading = false;
            await cartRepository.count();

            emit(calculatePriceInfo(successSatet.response));
          }
        } catch (e) {
          if (e is DioError) {
            emit(CartError(AppException(message: e.response!.data['message'])));
          }
        }
      }
    });
  }

  Future<void> loadCartItems(Emitter<CartState> emit, bool isRefreshing) async {
    try {
      if (!isRefreshing) {
        emit(CartLoading());
      }
      final response = await repository.getAll();
      if (response.cartItems.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartSuccess(response));
      }
    } catch (e) {
      if (e is DioError) {
        emit(CartError(AppException(message: e.response!.data['message'])));
      }
    }
  }

  CartSuccess calculatePriceInfo(CartResponse cartResponse) {
    int totalPrice = 0;
    int payablePrice = 0;
    int shippingCost = 0;

    for (var cartItem in cartResponse.cartItems) {
      totalPrice += cartItem.product.previousPrice * cartItem.count;
      payablePrice += cartItem.product.price * cartItem.count;
    }

    shippingCost = payablePrice >= 250000 ? 0 : 30000;
    cartResponse.totalPrice = totalPrice;
    cartResponse.payablePrice = payablePrice;
    cartResponse.shippingCost = shippingCost;

    return CartSuccess(cartResponse);
  }
}
