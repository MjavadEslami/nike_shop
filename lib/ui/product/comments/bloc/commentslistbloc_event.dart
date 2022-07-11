part of 'commentslistbloc_bloc.dart';

abstract class CommentsListEvent extends Equatable {
  const CommentsListEvent();

  @override
  List<Object> get props => [];
}

class CommnetsListStarted extends CommentsListEvent{}