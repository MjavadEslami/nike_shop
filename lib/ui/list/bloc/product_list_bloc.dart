import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_shop/common/exception.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/data/repo/product_repository.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final IProductRepository productRepository;
  ProductListBloc(this.productRepository) : super(ProductListLoading()) {
    on<ProductListEvent>((event, emit) async{
      if (event is ProductListStarted) {
        emit(ProductListLoading());
        try {
            final products=await productRepository.getAll(event.sort);
            emit(ProductListSuccess(products, event.sort, ProductSort.names));
        } catch (e) {
          emit(ProductListError(AppException()));
        }
      }
    });
  }
}
