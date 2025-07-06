part of 'receipts_bloc.dart';

@immutable
abstract class ReceiptsState {}

class ReceiptsInitial extends ReceiptsState {}

class ReceiptsLoadingState extends ReceiptsState {}

class ReceiptsLoadedState extends ReceiptsState {
  final ReceiptsListModel receiptsList;
  final UniqueReceipts sectionsList;

  ReceiptsLoadedState(this.receiptsList, this.sectionsList);
}

class ReceiptsEmptyState extends ReceiptsState {}

class ReceiptsErrorState extends ReceiptsState {}
