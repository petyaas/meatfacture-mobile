// // import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:smart/bloc_files/credit_cards_bloc.dart';
// import 'package:smart/services/services.dart';

// class MyChromeSafariBrowser extends ChromeSafariBrowser {
//   final String orderId;
//   final BuildContext context;

//   MyChromeSafariBrowser({@required this.context, this.orderId});

//   @override
//   void onOpened() {
//     print("*******OPEN***********");
//   }

//   @override
//   void onCompletedInitialLoad() {
//     print("******************");
//   }

//   @override
//   void onClosed() async {
//     // ignore: close_sinks
//     CreditCardsListBloc _cardsListBloc =
//         BlocProvider.of<CreditCardsListBloc>(context);
//     if (await CreditCardsProvider()
//         .setSuccessStatusOfLinkingCardResponse(orderId: orderId)) {
//       _cardsListBloc.add(CreditCardsListLoadEvent());
//     }
//   }
// }
