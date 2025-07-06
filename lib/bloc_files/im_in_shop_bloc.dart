//events
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/im_in_shop_model.dart';
import 'package:smart/services/services.dart';

abstract class ImInShopEvent {}

class ImInShopLoadEvent extends ImInShopEvent {}

//states

abstract class ImInShopState {}

class ImInShopInitState extends ImInShopState {}

class ImInShopNotStoreShooseState extends ImInShopState {}

class ImInShopLoadingState extends ImInShopState {}

class ImInShopErrorState extends ImInShopState {}

class ImInShopOldTokenState extends ImInShopState {}

class ImInShopLoadedState extends ImInShopState {
  final ImInShopModel imInShopModel;

  ImInShopLoadedState({@required this.imInShopModel});
}

//bloc class

class ImInShopBloc extends Bloc<ImInShopEvent, ImInShopState> {
  ImInShopBloc() : super(ImInShopInitState());

  @override
  Stream<ImInShopState> mapEventToState(ImInShopEvent event) async* {
    yield ImInShopLoadingState();
    try {
      String _imInShopResponse = await ImInShopProvider().turnOnImInShop();
      if (_imInShopResponse == "notStoreChoose") {
        yield ImInShopNotStoreShooseState();
      } else if (_imInShopResponse == "false") {
        yield ImInShopErrorState();
      } else if (_imInShopResponse == "old token") {
        yield ImInShopOldTokenState();
      } else {
        ImInShopModel _imInShopModel = await ImInShopProvider().getImInShopListResponse();
        yield ImInShopLoadedState(imInShopModel: _imInShopModel);
      }
    } catch (e) {
      if (e.toString().contains("401")) {
        yield ImInShopOldTokenState();
      } else {
        yield ImInShopErrorState();
      }
    }
  }
}
