import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/order_process/order_process_list_model.dart';
import 'package:smart/services/services.dart';

abstract class OrderPLEvent {}

class OrderPLLoadEvent extends OrderPLEvent {}

class OrderPLRefreshEvent extends OrderPLEvent {}

abstract class OrderPLState {}

class OrderPLLoadingState extends OrderPLState {}

class OrderPLErrorState extends OrderPLState {}

class OrderPLInitState extends OrderPLState {}

class OrderPLLoadedState extends OrderPLState {
  final OrderProcessListModel orderProcessListModel;
  OrderPLLoadedState({this.orderProcessListModel});
}

class OrderProcessListBloc extends Bloc<OrderPLEvent, OrderPLState> {
  OrderProcessListBloc() : super(OrderPLInitState());

  @override
  Stream<OrderPLState> mapEventToState(OrderPLEvent event) async* {
    if (event is OrderPLLoadEvent || event is OrderPLRefreshEvent) {
      yield OrderPLLoadingState();
      try {
        OrderProcessListModel _orderProcessListModel = await OrderProcessProvider().orderProcessResponse();

        if (_orderProcessListModel.data.isEmpty) {
          yield OrderPLInitState();
        } else {
          yield OrderPLLoadedState(orderProcessListModel: _orderProcessListModel);
        }
      } catch (e) {
        yield OrderPLErrorState();
      }
    }
  }
}
