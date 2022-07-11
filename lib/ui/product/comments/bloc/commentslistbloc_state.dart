part of 'commentslistbloc_bloc.dart';

abstract class CommentsListState extends Equatable {
  const CommentsListState();

  @override
  List<Object> get props => [];
}

class CommentsListLoading extends CommentsListState {}

class CommentsListSuccess extends CommentsListState {
  final List<CommentEntity> comments;

  const CommentsListSuccess({required this.comments});
  @override
  List<Object> get props => [comments];
}

class CommentsListError extends CommentsListState {
  final AppException exception;

  const CommentsListError({required this.exception});
  @override
  List<Object> get props => [exception];
}
