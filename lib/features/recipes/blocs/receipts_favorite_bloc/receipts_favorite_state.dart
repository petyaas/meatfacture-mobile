part of 'receipts_favorite_bloc.dart';

@immutable
abstract class ReceiptsFavoriteState {}

class ReceiptsFavoriteInitial extends ReceiptsFavoriteState {}

class ReceiptsFavoriteLoadingState extends ReceiptsFavoriteState {}

class ReceiptsFavoriteLoadedState extends ReceiptsFavoriteState {
  ReceiptsFavoriteLoadedState(this.singleRecipe);

  final SingleRecipeDataModel singleRecipe;
}

class ReceiptsFavoriteErrorState extends ReceiptsFavoriteState {}
