//events

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/assortment_brands_list_model.dart';
import 'package:smart/services/services.dart';

abstract class BrandEvent {}

class BrandLoadEvent extends BrandEvent {}

//states

abstract class BrandState {}

class BrandLoadedState extends BrandState {}

class BrandInitState extends BrandState {}

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  BrandBloc() : super(BrandInitState());

  @override
  Stream<BrandState> mapEventToState(BrandEvent event) async* {
    yield BrandInitState();
    try {
      // ignore: unused_local_variable
      AssortmentBrandsListmodel _brandsList =
          await AssortmentBrandsProvider().getAssortmentBrandsResponse(
        page: 1,
      );
      yield BrandLoadedState();
    } catch (e) {}
  }
}
