// // ignore: implementation_imports
// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:smart/bloc_files/Shopping_history_bloc.dart';
// // import 'package:smart/bloc_files/catalogs_bloc.dart';
// import 'package:smart/bloc_files/diverse_food_bloc.dart';
// import 'package:smart/bloc_files/secondary_pages_bloc.dart';
// import 'package:smart/core/constants/source.dart';

// // ignore: must_be_immutable
// class DiverseFoodIsActiveContent extends StatelessWidget {
//   int futuretRating = 0;
//   int futurePuchases = 0;
//   int minDiscountPercent = 0;
//   @override
//   Widget build(BuildContext context) {
// // ignore: close_sinks
//     ShoppingHistoryBloc _shoppingHistoryBloc =
//         BlocProvider.of<ShoppingHistoryBloc>(context);

//     // ignore: close_sinks
//     SecondaryPageBloc _secondaryPageBloc =
//         BlocProvider.of<SecondaryPageBloc>(context);

//     return BlocBuilder<DiverseFoodBloc, DiverseFoodState>(
//       builder: (context, state) {
//         if (state is DiverseFoodLoadingState) {
//           return Center(
//             child: CircularProgressIndicator(
//               valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
//             ),
//           );
//         }
//         if (state is DiverseFoodErrorState) {
//           return Center(
//             child: Text("errorText".tr()),
//           );
//         }

//         if (state is DiverseFoodLoadedState) {
//           if (state.diverseFoodFutureDiscountModel.data != null) {
//             minDiscountPercent =
//                 state.diverseFoodFutureDiscountModel.data.discountPercent;
//             for (var i = 0;
//                 i < state.diverseFoodPersentListModel.data.length;
//                 i++) {
//               if (minDiscountPercent <
//                   state.diverseFoodPersentListModel.data[i].discountPercent) {
//                 minDiscountPercent =
//                     state.diverseFoodPersentListModel.data[i].discountPercent;
//                 futurePuchases =
//                     state.diverseFoodPersentListModel.data[i].countPurchases;
//                 futuretRating =
//                     state.diverseFoodPersentListModel.data[i].countRatingScores;
//                 break;
//               }
//             }
//           } else {
//             minDiscountPercent =
//                 state.diverseFoodPersentListModel.data.first.discountPercent;
//             for (var i = 0;
//                 i < state.diverseFoodPersentListModel.data.length;
//                 i++) {
//               if (state.diverseFoodPersentListModel.data[i].discountPercent <=
//                   minDiscountPercent) {
//                 minDiscountPercent =
//                     state.diverseFoodPersentListModel.data[i].discountPercent;
//                 futurePuchases =
//                     state.diverseFoodPersentListModel.data[i].countPurchases;
//                 futuretRating =
//                     state.diverseFoodPersentListModel.data[i].countRatingScores;
//               }
//             }
//           }
//           return SingleChildScrollView(
//             child: Container(
//               alignment: Alignment.center,
//               child: Column(
//                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         left: 15, right: 15, top: 15, bottom: 15),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "yourDiscountForText".tr() +
//                               " " +
//                               getMonthName(month: DateTime.now().month),
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w400),
//                         ),
//                         Text(
//                           state.diverseFoodPresentDiscountModel.data.isEmpty
//                               ? "0%"
//                               : "${state.diverseFoodPresentDiscountModel.data.first.discountPercent}%",
//                           style: TextStyle(
//                               color: mainColor,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w400),
//                         )
//                       ],
//                     ),
//                   ),
//                   Divider(
//                     indent: 15,
//                     endIndent: 15,
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.only(
//                         left: 15, right: 15, top: 15, bottom: 15),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "yourDiscountForText".tr() +
//                               " " +
//                               getMonthName(
//                                   month: DateTime.now().month == 12
//                                       ? 1
//                                       : DateTime.now().month + 1),
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w400),
//                         ),
//                         Text(
//                           "folowNextText".tr(),
//                           style: TextStyle(
//                               color: colorBlack04,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 15, vertical: 15),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           state.diverseFoodFutureDiscountModel.data == null
//                               ? "0%"
//                               : state.diverseFoodFutureDiscountModel.data
//                                       .discountPercent
//                                       .toString() +
//                                   "%",
//                           style: TextStyle(
//                               color: mainColor,
//                               fontSize: 48,
//                               fontWeight: FontWeight.w800),
//                         ),
//                         Expanded(
//                             child: SvgPicture.asset(
//                                 "assets/images/LongArrowIcon.svg")),
//                         Text(
//                             state.diverseFoodFutureDiscountModel.data == null
//                                 ? "${state.diverseFoodPersentListModel.data.first.discountPercent.toString()}%"
//                                 : minDiscountPercent.toString() + "%",
//                             style: TextStyle(
//                                 color: colorBlack04,
//                                 fontSize: 26,
//                                 fontWeight: FontWeight.w600)),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 15),
//                     child: Text("toIncreaseTheDiscountText".tr(),
//                         style: GoogleFonts.raleway(
//                             color: colorBlack04,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500)),
//                   ),
//                   SizedBox(height: 25),

//                   //ПРОГРЕСС В ПОКУПКАХ
//                   Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("purchaseText".tr(),
//                               style: GoogleFonts.raleway(
//                                   fontSize: 14, fontWeight: FontWeight.w400)),
//                           Text(
//                               state.diverseFoodStatsModel.data.isEmpty
//                                   ? "0" +
//                                       "fromText".tr() +
//                                       (state.diverseFoodFutureDiscountModel
//                                                   .data ==
//                                               null
//                                           ? "0"
//                                           : state.diverseFoodFutureDiscountModel
//                                               .data.countPurchases
//                                               .toString())
//                                   : state.diverseFoodStatsModel.data.first
//                                           .purchasedCount
//                                           .toString() +
//                                       "fromText".tr() +
//                                       (futurePuchases.toString()),
//                               style: TextStyle(
//                                   fontSize: 14, fontWeight: FontWeight.w400)),
//                         ],
//                       )),
//                   SizedBox(height: 10),
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 15),
//                     height: 15,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             flex: state.diverseFoodStatsModel.data.isEmpty
//                                 ? 0
//                                 : state.diverseFoodStatsModel.data.first
//                                     .purchasedCount,
//                             child: Container(
//                                 height: 15,
//                                 decoration: BoxDecoration(
//                                   color: mainColor,
//                                 )),
//                           ),
//                           Expanded(
//                               flex: state.diverseFoodStatsModel.data.isEmpty ||
//                                       state.diverseFoodStatsModel.data.first
//                                               .purchasedCount ==
//                                           0
//                                   ? 1
//                                   // : state.diverseFoodFutureDiscountModel.data ==
//                                   //         null
//                                   //     ? 0
//                                   : futurePuchases -
//                                       state.diverseFoodStatsModel.data.first
//                                           .purchasedCount,
//                               child: Container(
//                                   height: 15,
//                                   decoration: BoxDecoration(
//                                     color: colorBlack03,
//                                   ))),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // прогресс в оценках
//                   SizedBox(height: 25),
//                   Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("evaluatedText".tr(),
//                               style: GoogleFonts.raleway(
//                                   fontSize: 14, fontWeight: FontWeight.w400)),
//                           Text(
//                               state.diverseFoodStatsModel.data.isEmpty
//                                   ? "0" +
//                                       "fromText".tr() +
//                                       (state.diverseFoodFutureDiscountModel
//                                                   .data ==
//                                               null
//                                           ? "0"
//                                           : state.diverseFoodFutureDiscountModel
//                                               .data.countRatingScores
//                                               .toString())
//                                   : state.diverseFoodStatsModel.data.first
//                                           .ratedCount
//                                           .toString() +
//                                       "fromText".tr() +
//                                       (futuretRating.toString()),
//                               style: TextStyle(
//                                   fontSize: 14, fontWeight: FontWeight.w400)),
//                         ],
//                       )),
//                   SizedBox(height: 10),
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 15),
//                     height: 15,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             flex: state.diverseFoodStatsModel.data.isEmpty
//                                 ? 0
//                                 : state.diverseFoodStatsModel.data.first
//                                     .ratedCount,
//                             child: Container(
//                                 height: 15,
//                                 decoration: BoxDecoration(
//                                   color: mainColor,
//                                 )),
//                           ),
//                           Expanded(
//                               flex: state.diverseFoodStatsModel.data.isEmpty ||
//                                       state.diverseFoodStatsModel.data.first
//                                               .ratedCount ==
//                                           0
//                                   ? 1
//                                   : futuretRating -
//                                       state.diverseFoodStatsModel.data.first
//                                           .ratedCount,
//                               child: Container(
//                                   height: 15,
//                                   decoration: BoxDecoration(
//                                     color: colorBlack03,
//                                   ))),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 45),

//                   InkWell(
//                     onTap: () {
//                       _secondaryPageBloc.add(HistoryPageEvent());
//                       _shoppingHistoryBloc.add(ShoppingHistoryCheckListEvent());
//                     },
//                     child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         margin: const EdgeInsets.symmetric(horizontal: 15),
//                         decoration: BoxDecoration(
//                             border:
//                                 Border.all(color: orangeTextColor, width: 1.5),
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(15)),
//                         alignment: Alignment.center,
//                         child: Text('Оцените ваши покупки'),
//                   ),
//                   SizedBox(height: 45),

//                   // BlocBuilder<AssortmentRecommendationBloc,
//                   //         AssortmentRecommendationsState>(
//                   //     builder: (context, state) {
//                   //   if (state is AssortmentRecommendationsLoadedState) {
//                   //     return Column(
//                   //       children: [
//                   //         Container(
//                   //             margin:
//                   //                 const EdgeInsets.only(left: 15, right: 15),
//                   //             alignment: Alignment.bottomLeft,
//                   //             child: Row(
//                   //               mainAxisAlignment:
//                   //                   MainAxisAlignment.spaceBetween,
//                   //               children: [
//                   //                 Text("RecommendationsText".tr(),
//                   //                     style: GoogleFonts.raleway(
//                   //                         fontSize: 16,
//                   //                         fontWeight: FontWeight.w600)),
//                   //                 InkWell(
//                   //                   onTap: () {
//                   //                     _catalogsBloc.add(
//                   //                         CatalogAllAssortmentsEvent(
//                   //                             currentPage: 1,
//                   //                             isRecommendations: true));
//                   //                     _bottomNavBloc.add(CatalogEvent());
//                   //                   },
//                   //                   child: Text("viewAllText".tr(),
//                   //                       style: GoogleFonts.raleway(
//                   //                           fontSize: 14,
//                   //                           color: mainColor,
//                   //                           fontWeight: FontWeight.w500)),
//                   //                 ),
//                   //               ],
//                   //             )),
//                   //         SizedBox(height: 20),
//                   //         Co ntainer(
//                   //             height: 240, child: RecomendationListWidget()),
//                   //       ],
//                   //     );
//                   //   }
//                   //   return SizedBox();
//                   // }),
//                 ],
//               ),
//             ),
//           );
//         }
//         return Container();
//       },
//     );
//   }

//   String getMonthName({int month}) {
//     switch (month) {
//       case 1:
//         return "januaryText".tr().toLowerCase();
//         break;

//       case 2:
//         return "februaryText".tr().toLowerCase();
//         break;

//       case 3:
//         return "marchText".tr().toLowerCase();
//         break;

//       case 4:
//         return "aprilText".tr().toLowerCase();
//         break;

//       case 5:
//         return "mayText".tr().toLowerCase();
//         break;

//       case 6:
//         return "juneText".tr().toLowerCase();
//         break;

//       case 7:
//         return "julyText".tr().toLowerCase();
//         break;

//       case 8:
//         return "augustText".tr().toLowerCase();
//         break;

//       case 9:
//         return "septemberText".tr().toLowerCase();
//         break;

//       case 10:
//         return "octoberText".tr().toLowerCase();
//         break;

//       case 11:
//         return "novemberText".tr().toLowerCase();
//         break;
//       case 12:
//         return "decemberText".tr().toLowerCase();
//         break;
//       default:
//         return "";
//     }
//   }
// }
