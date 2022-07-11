import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_shop/common/exception.dart';
import 'package:nike_shop/data/comment.dart';
import 'package:nike_shop/data/repo/comment_repository.dart';

part 'commentslistbloc_event.dart';
part 'commentslistbloc_state.dart';

class CommentsListBloc extends Bloc<CommentsListEvent, CommentsListState> {
  final ICommnetRepository commnetRepository;
  final int productId;
  CommentsListBloc({required this.commnetRepository, required this.productId})
      : super(CommentsListLoading()) {
    on<CommentsListEvent>((event, emit) async {
      try {
        if (event is CommnetsListStarted) {
          emit(CommentsListLoading());
          final comments = await commentRepository.getAll(productId);
          emit(CommentsListSuccess(comments: comments));
        }
      } catch (e) {
        emit(CommentsListError(
            exception: e is AppException ? e : AppException()));
      }
    });
  }
}
