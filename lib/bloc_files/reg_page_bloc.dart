import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/custom_widgets/get_code_widget.dart';
import 'package:smart/custom_widgets/login_widget.dart';
// import 'package:smart/custom_widgets/reg_and_login_widget.dart';
// enum AuthEvent { regOrLoginEvent, loginEvent, getCodeEvent }

//event classes
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {}

class GetCodeEvent extends AuthEvent {
  final String phone;

  GetCodeEvent({@required this.phone});
  String get getphone => phone;
}

class AuthPageBloc extends Bloc<AuthEvent, Widget> {
  AuthPageBloc() : super(LoginWidget());
  String phoneinbloc;
  @override
  Stream<Widget> mapEventToState(AuthEvent event) async* {
    if (event is LoginEvent) {
      yield LoginWidget();
    }
    if (event is GetCodeEvent) {
      yield GetCodeWidget(phone: event.phone);
    }
  }
}
