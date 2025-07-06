import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/models/single_recipe_data_model.dart';
import 'package:smart/services/services.dart';

part 'receipts_favorite_event.dart';
part 'receipts_favorite_state.dart';

class ReceiptsFavoriteBloc extends Bloc<ReceiptsFavoriteEvent, ReceiptsFavoriteState> {
  ReceiptsFavoriteBloc() : super(ReceiptsFavoriteInitial());

  @override
  Stream<ReceiptsFavoriteState> mapEventToState(ReceiptsFavoriteEvent event) async* {
    if (event is ReactReceiptsEvent) {
      yield ReceiptsFavoriteLoadingState();
      try {
        final isComplete = await ReceiptsListProvider().toggleLikeStory(event.Uuid, event.isFavorite);
        final singleRecipe = await ReceiptsListProvider().getSingleReceipt(event.Uuid);
        if (isComplete == true) {
          yield ReceiptsFavoriteLoadedState(singleRecipe);
        } else {
          yield ReceiptsFavoriteErrorState();
        }
      } catch (e) {
        print(e);
        yield ReceiptsFavoriteErrorState();
      }
    }
  }
}
