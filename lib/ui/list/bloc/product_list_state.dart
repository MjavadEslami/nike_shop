part of 'product_list_bloc.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

class ProductListLoading extends ProductListState {}

class ProductListError extends ProductListState {
  final AppException appException;

  const ProductListError(this.appException);
  @override
  List<Object> get props => [appException];
}

class ProductListSuccess extends ProductListState {
  final List<ProductEntity> products;
  final int sort;
  final List<String> sortNames;

   const ProductListSuccess(this.products, this.sort, this.sortNames);
  @override
  List<Object> get props => [products, sort, sortNames];
}
