part of 'card_detail_bloc.dart';

class CardDetailState extends Equatable {
  final int currentPage;

  const CardDetailState(this.currentPage);

  @override
  List<Object?> get props => [currentPage];
}
