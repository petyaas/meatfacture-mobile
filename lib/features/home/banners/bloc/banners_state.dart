import 'package:smart/features/home/models/banners_list_model.dart';

abstract class BannersState {}

class BannersInitial extends BannersState {}

class BannersLoading extends BannersState {}

class BannersLoaded extends BannersState {
  final BannersListModel banners;
  BannersLoaded(this.banners);
}

class BannersError extends BannersState {
  final String message;
  BannersError(this.message);
}
