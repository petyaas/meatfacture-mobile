// // ignore: implementation_imports
// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smart/bloc_files/shops_bloc.dart';
// import 'package:smart/pages/init_add_user_address_list_independent.dart';
// import 'package:smart/core/constants/source.dart';
// import 'package:smart/core/constants/text_styles.dart';

// class ChangeSelectedShopCheckBottomSheet extends StatelessWidget {
//   // const ChangeSelectedShopCheckBottomSheet({@required this.secondaryPageEvent});

//   // const ChageSelectedShopCheckBottomSheet({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // ignore: close_sinks
//     ShopsBloc _shopsBloc = BlocProvider.of<ShopsBloc>(context);

//     return Container(
//       padding: EdgeInsets.only(top: heightRatio(size: 30, context: context), left: widthRatio(size: 15, context: context), right: widthRatio(size: 15, context: context)),
//       // height: heightRatio(height: 350, context: context),
//       child: Column(
//         // crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             "Адрес магазина будет изменен",
//             textAlign: TextAlign.center,
//             style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context), color: newBlack),
//           ),
//           SizedBox(height: heightRatio(size: 15, context: context)),
//           Text(
//             "storeAddresswiilBeChangedTitleText".tr(),
//             textAlign: TextAlign.center,
//             style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack, height: 1.3),
//           ),
//           SizedBox(height: heightRatio(size: 30, context: context)),
//           InkWell(
//             onTap: () async {
//               _shopsBloc.add(ShopsAsMapPointsEvent());
//               // _bottomNavBloc.add(
//               //     ShopsOpenEvent(secondaryPageEvent: secondaryPageEvent));

//               // Navigator.push(context, MaterialPageRoute(builder: (context) => ShopsPage())).then(
//               //   (value) => {
//               //     Navigator.pop(context),
//               //   },
//               // );
//               final result = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => InitAddUserAddressListIndependent(hasBackBtn: true),
//                 ),
//               ) as Map<String, String>;
//               if (result != null) {
//                 Navigator.of(context).pop(result);
//               }
//             },
//             child: Container(
//               alignment: Alignment.center,
//               padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
//               child: Text(
//                 "ContinueText".tr(),
//                 style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
//               ),
//             ),
//           ),
//           SizedBox(height: heightRatio(size: 15, context: context)),
//           InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Container(
//               alignment: Alignment.center,
//               padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newBlack),
//               child: Text(
//                 "Вернуться назад",
//                 style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
//               ),
//             ),
//           ),
//           SizedBox(height: heightRatio(size: 40, context: context)),
//         ],
//       ),
//     );
//   }
// }
// TODO удалить