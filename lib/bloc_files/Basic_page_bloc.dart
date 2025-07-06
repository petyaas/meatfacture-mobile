import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/features/main/main_page.dart';
import 'package:smart/pages/reg_and_login_page.dart';

enum BasicPagesEvent {
  mainPageEvent,
  regPageEvent,
}

class BasicPageBloc extends Bloc<BasicPagesEvent, Widget> {
  Widget _currPage = MainPage();
  BasicPageBloc(Widget initialState) : super(initialState);

  @override
  Stream<Widget> mapEventToState(BasicPagesEvent event) async* {
    switch (event) {
      case BasicPagesEvent.mainPageEvent:
        {
          _currPage = MainPage();
        }
        break;
      case BasicPagesEvent.regPageEvent:
        {
          _currPage = RegAndLoginPAge();
        }
    }

    yield _currPage;
  }
}
