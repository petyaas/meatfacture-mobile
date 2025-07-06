// // ignore: implementation_imports
// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:smart/bloc_files/shops_bloc.dart';
// import 'package:smart/features/profile/bloc/profile_bloc.dart';
// import 'package:smart/bloc_files/secondary_pages_bloc.dart';
// import 'package:smart/features/home/home_choose_store_screen.dart';
// import 'package:smart/core/constants/source.dart';
// import 'package:smart/core/constants/text_styles.dart';

// class MessageSelectShopBottomSheet extends StatelessWidget {
//   const MessageSelectShopBottomSheet({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // ignore: close_sinks
//     ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);

//     // ignore: close_sinks
//     // ShopsBloc _shopsBloc = BlocProvider.of<ShopsBloc>(context);
//     // ignore: close_sinks
//     SecondaryPageBloc _bottomNavBloc = BlocProvider.of<SecondaryPageBloc>(context);
//     return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
//       if (state is ProfileLoadedState) {
//         if (state.profileModel.data.selectedStoreUserUuid != null) {
//           SchedulerBinding.instance.addPostFrameCallback((_) {
//             Navigator.pop(context);
//             Navigator.pop(context);
//           });
//         }
//       }
//       if (state is ProfileAsGuestState) {
//         if (state.shopAddress != null) {
//           SchedulerBinding.instance.addPostFrameCallback((_) {
//             Navigator.pop(context);
//             Navigator.pop(context);
//           });
//         }
//       }

//       return WillPopScope(
//         onWillPop: () async {
//           if (_profileBloc.state is ProfileAsGuestState) {
//           } else {
//             _bottomNavBloc.add(HomeEvent());
//             Navigator.pop(context);
//           }
//           return false;
//         },
//         child: ClipRRect(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(heightRatio(size: 15, context: context)),
//             topRight: Radius.circular(heightRatio(size: 15, context: context)),
//           ),
//           child: Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: widthRatio(size: 20, context: context),
//               vertical: heightRatio(size: 15, context: context),
//             ),
//             color: Colors.white,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(
//                     left: widthRatio(size: 15, context: context),
//                     right: widthRatio(size: 15, context: context),
//                   ),
//                   child: Text(
//                     "selectTheNearestStoreText".tr(),
//                     style: appTextStyle(fontSize: heightRatio(size: 20, context: context)),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 SizedBox(height: heightRatio(size: 20, context: context)),
//                 InkWell(
//                   onTap: () {
//                     // _shopsBloc.add(ShopsAsMapPointsEvent());
//                     // // Navigator.pop(context);
//                     // Navigator.push(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //       builder: (context) => HomeChooseStoreScreen(),
//                     //     ));
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: heightRatio(size: 15, context: context)),
//                     alignment: Alignment.center,
//                     child: Text(
//                       "selectAddressText".tr(),
//                       style: appTextStyle(color: Colors.white, fontSize: heightRatio(size: 18, context: context)),
//                     ),
//                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 15, context: context)), color: newRedDark),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
// } // TODO удалить
