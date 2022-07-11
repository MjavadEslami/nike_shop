part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class AddToCartButton extends ProductEvent {
  final int productId;
  const AddToCartButton(this.productId);
}
