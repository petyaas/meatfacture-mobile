//events
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/check_details_model.dart';
import 'package:smart/models/check_details_products_model.dart';
import 'package:smart/repositories/history_check_details_products_repository.dart';
import 'package:smart/repositories/history_check_details_repository.dart';

abstract class HistoryCheckDetailsEvent {}

class HistoryCheckDetailsLoadEvent extends HistoryCheckDetailsEvent {
  final String receiptUuid;
  HistoryCheckDetailsLoadEvent({this.receiptUuid});
}

//states

abstract class HistoryCheckDetailsState {}

class HistoryCheckDetailsEmptyState extends HistoryCheckDetailsState {}

class HistoryCheckDetailsLoadingState extends HistoryCheckDetailsState {}

class HistoryCheckDetailsErrorState extends HistoryCheckDetailsState {}

class HistoryCheckDetailsLoadedState extends HistoryCheckDetailsState {
  final CheckDetailsModel checkDetailsModel;
  final CheckDetailsProductsModel checkDetailsProductsModel;
  HistoryCheckDetailsLoadedState(
      {@required this.checkDetailsProductsModel,
      @required this.checkDetailsModel});
}

class HistoryCheckDetailsBloc
    extends Bloc<HistoryCheckDetailsEvent, HistoryCheckDetailsState> {
  HistoryCheckDetailsBloc() : super(HistoryCheckDetailsEmptyState());

  @override
  Stream<HistoryCheckDetailsState> mapEventToState(
      HistoryCheckDetailsEvent event) async* {
    if (event is HistoryCheckDetailsLoadEvent) {
      yield HistoryCheckDetailsLoadingState();
      try {
        final CheckDetailsModel _checkDetailsModel =
            await HistoryCheckDeatilsRepository()
                .getHistoryCheckDeatilsFromRepository(
                    receiptUuid: event.receiptUuid);
        final CheckDetailsProductsModel _checkDetailsProductsModel =
            await HistoryCheckDetailsProductRepository()
                .getHistoryCheckDeatilsFromRepository(
                    receiptUuid: event.receiptUuid);
        yield HistoryCheckDetailsLoadedState(
            checkDetailsModel: _checkDetailsModel,
            checkDetailsProductsModel: _checkDetailsProductsModel);
      } catch (e) {
        yield HistoryCheckDetailsErrorState();
      }
    }
  }
}
