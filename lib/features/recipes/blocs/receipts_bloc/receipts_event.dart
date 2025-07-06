part of 'receipts_bloc.dart';

@immutable
abstract class ReceiptsEvent {}

class LoadReceiptsEvent extends ReceiptsEvent {
  final String page;

  LoadReceiptsEvent(this.page);
}
