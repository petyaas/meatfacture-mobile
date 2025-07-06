//events
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OrderTypeEvent {}

class OrderTypeDeliveryEvent extends OrderTypeEvent {}

class OrderTypePickupEvent extends OrderTypeEvent {}

//states

abstract class OrderTypeState {}

class OrderTypeDeliveryState extends OrderTypeState {}

class OrderTypePickupState extends OrderTypeState {}

//BLoC class

class OrderTypeBloc extends Bloc<OrderTypeEvent, OrderTypeState> {
  OrderTypeBloc() : super(OrderTypeDeliveryState());

  @override
  Stream<OrderTypeState> mapEventToState(OrderTypeEvent event) async* {
    if (event is OrderTypeDeliveryEvent) {
      yield OrderTypeDeliveryState();
    }
    if (event is OrderTypePickupEvent) {
      yield OrderTypePickupState();
    }
  }
}
