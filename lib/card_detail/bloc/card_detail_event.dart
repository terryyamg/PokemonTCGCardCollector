part of 'card_detail_bloc.dart';

abstract class CardDetailEvent extends Equatable {
  const CardDetailEvent();
}

class PageChangedEvent extends CardDetailEvent {
  final int newPage;

  const PageChangedEvent(this.newPage);

  @override
  List<Object?> get props => [newPage];
}
