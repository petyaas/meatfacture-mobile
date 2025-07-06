// // ignore: implementation_imports
// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:smart/bloc_files/Shopping_history_bloc.dart';
// import 'package:smart/bloc_files/product_details_middle_content_bloc.dart';
// import 'package:smart/custom_widgets/Ingredient_middle_content_widget.dart';
// import 'package:smart/pages/shopping_history_page.dart';
// import 'package:smart/core/constants/source.dart';

// import 'assortment_comments_in_product_Details_widget.dart';

// class ProductDetailsMiddleContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // ignore: close_sinks
//     ShoppingHistoryBloc _shoppingHistoryBloc =
//         BlocProvider.of<ShoppingHistoryBloc>(context);

//     return BlocBuilder<ProductDetMiddleContentBloc,
//         ProductDetMiddleContentState>(builder: (context, state) {
//       if (state is ProductDetMiddleContentEmptyState) {
//         return Container();
//       }
//       if (state is ProductDetMiddleContentErrorState) {
//         return Container(
//           child: Text('errorText'.tr()),
//         );
//       }
//       if (state is ProductDetMiddleContentLoadingState) {
//         return Container(
//           child: CircularProgressIndicator(),
//         );
//       }
//       if (state is ProductDetMiddleContentDescriptionState) {
//         return Container(
//           alignment: Alignment.centerLeft,
//           padding: const EdgeInsets.symmetric(horizontal: 5),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (state.productDetailsModel.data.shelfLife != 0)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Text(
//                     //   "shelfLifeText".tr() +
//                     //           ": " +
//                     //           state.productDetailsModel.data.shelfLife
//                     //               .toString() +
//                     //           " " +
//                     //           getDayOrDays(
//                     //               state.productDetailsModel.data.shelfLife) ??
//                     //       "",
//                     // ),
//                     // RichText(
//                     //   text: TextSpan(children: [
//                     //     TextSpan(
//                     //         text: "shelfLifeText".tr() + ":",
//                     //         style: GoogleFonts.raleway(
//                     //             fontSize: 16,
//                     //             color: Colors.black,
//                     //             fontWeight: FontWeight.w700)),
//                     //     TextSpan(
//                     //       text: " " +
//                     //               state.productDetailsModel.data.shelfLife
//                     //                   .toString() +
//                     //               " " +
//                     //               getDayOrDays(state
//                     //                   .productDetailsModel.data.shelfLife) ??
//                     //           "",
//                     //       style: GoogleFonts.raleway(
//                     //           fontSize: 16, color: Colors.black),
//                     //     )
//                     //   ]),
//                     // ),
//                     // SizedBox(height: 15),
//                     // Divider(),
//                     // SizedBox(height: 15),
//                   ],
//                 ),
//               Text(
//                 state.productDetailsModel.data.description ?? "",
//                 style: GoogleFonts.raleway(fontSize: 16),
//               ),
//               SizedBox(height: 15),
//               Divider(),
//               SizedBox(height: 10),
//               RichText(
//                 text: TextSpan(children: [
//                   TextSpan(
//                       text: "shelfLifeText".tr() + ":",
//                       style: GoogleFonts.raleway(
//                           fontSize: 16,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w700)),
//                   TextSpan(
//                     text: " " +
//                             state.productDetailsModel.data.shelfLife
//                                 .toString() +
//                             " " +
//                             getDayOrDays(
//                                 state.productDetailsModel.data.shelfLife) ??
//                         "",
//                     style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                         fontWeight: FontWeight.w300),
//                   )
//                 ]),
//               ),
//             ],
//           ),
//         );
//         // return Column(
//         //   children: [
//         //     Row(
//         //       children: [
//         //         Text('Производитель: ',
//         //             style: TextStyle(fontWeight: FontWeight.bold)),
//         //         Text(state.productDetailsModel.data.manufacturer == null
//         //             ? 'Неизвестно'
//         //             : state.productDetailsModel.data.manufacturer)
//         //       ],
//         //     ),
//         //     SizedBox(height: 10),
//         //     Divider(),
//         //     SizedBox(height: 10),
//         //     Row(
//         //       children: [
//         //         Text('Срок Годности: ',
//         //             style: TextStyle(fontWeight: FontWeight.bold)),
//         //         Text(state.productDetailsModel.data.shelfLife == null
//         //             ? 'Неизвестно'
//         //             : state.productDetailsModel.data.shelfLife.toString())
//         //       ],
//         //     ),
//         //     SizedBox(height: 10),
//         //     Divider(),
//         //     SizedBox(height: 10),
//         //     Text(
//         //       // state.productDetailsModel.data.description == null
//         //       // ? 'Неизвестно'
//         //       // :
//         //       exampleDecriptionOfProduct,
//         //       style: TextStyle(wordSpacing: 4, height: 1.5),
//         //     ),
//         //   ],
//         // );
//       }

//       if (state is ProductDetMiddleContentIngredientsState) {
//         return ProductIngredientMiddleContent(
//           ingredients: state.productDetailsModel.data.ingredients ?? "",
//           weght: state.productDetailsModel.data.weight ?? "",
//         );
//       }

//       if (state is ProductDetMiddleContentComentsState) {
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(height: 10),
//             AssortmentCommentsInProductDetailsWidget(),
//             SizedBox(height: 15),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       _shoppingHistoryBloc.add(ShoppingHistoryCheckListEvent());
//                       Navigator.push(context, MaterialPageRoute(
//                         builder: (context) {
//                           return ShoppingHistoryPage(
//                             historyNavKey: null,
//                             outContext: context,
//                           );
//                         },
//                       ));
//                       // _bottomNavBloc.add(HisotyPageEvent());
//                     },
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.add,
//                           size: 12,
//                           color: mainColor,
//                         ),
//                         // SizedBox(width: 5),
//                         Container(
//                           color: Colors.transparent,
//                           child: Text(
//                             "Оценить в своих покупках",
//                             style: GoogleFonts.raleway(
//                                 fontSize: 14, color: mainColor),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   InkWell(
//                     child: Container(
//                       color: Colors.transparent,
//                       child: Text(
//                         "viewAllText".tr(),
//                         style:
//                             GoogleFonts.raleway(fontSize: 14, color: mainColor),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         );
//       }

//       return Center(child: Text('errorText'.tr()));
//     });
//   }

//   String getDayOrDays(int shelfLife) {
//     if (shelfLife % 10 == 1) {
//       return "1dayText".tr();
//     } else {
//       return "daysText".tr();
//     }
//   }
// }
