import 'package:flutter/cupertino.dart';

class GetTokenbyPhoneModel {
  String _token;
  GetTokenbyPhoneModel({@required String token}) {
    this._token = token;
  }

  String get getToken => _token;

  factory GetTokenbyPhoneModel.fromJson(Map<String, dynamic> json) {
    return GetTokenbyPhoneModel(token: json['token'].toString());
  }
}
