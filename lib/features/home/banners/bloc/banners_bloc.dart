import 'dart:async';

import 'banners_event.dart';
import 'banners_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/features/home/models/banners_list_model.dart';
import 'package:smart/services/services.dart';

class BannersBloc extends Bloc<BannersEvent, BannersState> {
  BannersListModel _cachedBanners;

  BannersBloc() : super(BannersInitial());

  @override
  Stream<BannersState> mapEventToState(BannersEvent event) async* {
    if (event is LoadBannersEvent) {
      // Если баннеры уже загружены, возвращаем их из кэша
      if (_cachedBanners != null) {
        yield BannersLoaded(_cachedBanners);
        return;
      }

      // Иначе загружаем их из API
      yield BannersLoading();
      try {
        final banners = await BannersProvider().bannersResponse();
        _cachedBanners = banners; // Кэшируем баннеры
        yield BannersLoaded(banners);
      } catch (error) {
        yield BannersError("Ошибка загрузки баннеров: $error");
      }
    }
  }
}
