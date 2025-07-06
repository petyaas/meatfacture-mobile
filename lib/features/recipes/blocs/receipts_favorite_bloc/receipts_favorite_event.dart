part of 'receipts_favorite_bloc.dart';

@immutable
abstract class ReceiptsFavoriteEvent {}

class ReactReceiptsEvent extends ReceiptsFavoriteEvent {
  final String Uuid;
  final bool isFavorite;

  ReactReceiptsEvent(this.Uuid, this.isFavorite);
}
