import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'card_detail_event.dart';

part 'card_detail_state.dart';

class CardDetailBloc extends Bloc<CardDetailEvent, CardDetailState> {
  CardDetailBloc(int initialPage) : super(CardDetailState(initialPage)) {
    on<PageChangedEvent>((event, emit) {
      emit(CardDetailState(event.newPage));
    });
  }
}
