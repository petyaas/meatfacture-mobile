// // ignore: implementation_imports
// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter/painting.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:smart/bloc_files/im_in_shop_bloc.dart';
// import 'package:smart/bloc_files/product_details_bloc.dart';
// import 'package:smart/pages/product_details_page.dart';
// import 'package:smart/core/constants/source.dart';

// class ImInShopContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     ImInShopBloc _imInShopBloc = BlocProvider.of(context);
//     // ignore: close_sinks
//     ProductDetailsBloc _productDetailsBloc =
//         BlocProvider.of<ProductDetailsBloc>(context);
//     return BlocBuilder<ImInShopBloc, ImInShopState>(
//       builder: (context, state) {
//         if (state is ImInShopLoadingState) {
//           return Center(
//             child: CircularProgressIndicator(
//               valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
//             ),
//           );
//         }
//         if (state is ImInShopNotStoreShooseState) {
//           return Center(
//               child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset("assets/images/redes_im_in_shop_image.png"),
//               SizedBox(height: 25),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Text("chooseStoreWarningText".tr(),
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.raleway(
//                         fontSize: 18,
//                         color: colorBlack06,
//                         fontWeight: FontWeight.w500)),
//               ),
//             ],
//           ));
//         }

//         if (state is ImInShopLoadedState) {
//           return ListView.builder(
//             padding: const EdgeInsets.only(top: 15),
//             itemBuilder: (context, index) {
//               return InkWell(
//                 onTap: () {
//                   _productDetailsBloc.add(ProductDetailsLoadEvent(
//                     uuid: state.imInShopModel.data.products[index].uuid,
//                   ));
//                   Navigator.push(
//                       context,
//                       new MaterialPageRoute(
//                         builder: (context) => ProductDetailsPage(),
//                       ));

//                   // _bottomNavBloc.add(ProductDetailsonSecondaryPageEvent());
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Card(
//                         clipBehavior: Clip.hardEdge,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                         elevation: 10,
//                         shadowColor: colorBlack04,
//                         child: Container(
//                           height: 100,
//                           width: 100,
//                           child: Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               Image.network(
//                                 state.imInShopModel.data.products[index]
//                                     .images[0].path,
//                                 fit: BoxFit.fill,
//                               ),
//                               //rating
//                               Positioned(
//                                   bottom: 10,
//                                   left: 10,
//                                   child: Container(
//                                     padding: const EdgeInsets.only(
//                                         left: 7, top: 3, bottom: 3, right: 5),
//                                     decoration: BoxDecoration(
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black12,
//                                             spreadRadius: 5,
//                                             offset: Offset(0, 0),
//                                             blurRadius: 20,
//                                           )
//                                         ],
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(5)),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: [
//                                         Icon(
//                                           state.imInShopModel.data
//                                                       .products[index].rating !=
//                                                   null
//                                               ? Icons.star
//                                               : Icons.star_outline,
//                                           size: 15,
//                                           color:
//                                               Color.fromRGBO(255, 166, 101, 1),
//                                         ),
//                                         SizedBox(width: 5),
//                                         Text(
//                                           state.imInShopModel.data
//                                                       .products[index].rating !=
//                                                   null
//                                               ? state.imInShopModel.data
//                                                   .products[index].rating
//                                                   .toString()
//                                               : '',
//                                           style: TextStyle(
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w600,
//                                               color: colorBlack04),
//                                         )
//                                       ],
//                                     ),
//                                   )),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: Container(
//                           height: 120,
//                           // color: Colors.amber,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                   alignment: Alignment.topLeft,
//                                   margin: const EdgeInsets.only(top: 5),
//                                   child: Text(state.imInShopModel.data
//                                       .products[index].name)),
//                               Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "availableText".tr() +
//                                             " " +
//                                             state.imInShopModel.data
//                                                 .products[index].quantity
//                                                 .toString() +
//                                             " " +
//                                             "piecesText".tr(),
//                                         style: TextStyle(
//                                             color: colorBlack04,
//                                             fontSize: 10,
//                                             fontWeight: FontWeight.w400),
//                                       ),
//                                       Row(
//                                         children: [
//                                           Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 5, vertical: 2),
//                                             //discount color
//                                             decoration: BoxDecoration(
//                                                 color: Color(int.parse(
//                                                     "0xff${state.imInShopModel.data.products[index].discountTypeColor}")),
//                                                 borderRadius:
//                                                     BorderRadius.circular(4)),

//                                             child: Text(
//                                               state
//                                                       .imInShopModel
//                                                       .data
//                                                       .products[index]
//                                                       .priceWithDiscount
//                                                       .toString() +
//                                                   "rubleSignText".tr(),
//                                               style: TextStyle(
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w800),
//                                             ),
//                                           ),
//                                           SizedBox(width: 5),
//                                           Container(
//                                             width: state
//                                                         .imInShopModel
//                                                         .data
//                                                         .products[index]
//                                                         .priceWithDiscount ==
//                                                     null
//                                                 ? 0
//                                                 : double.parse(state
//                                                         .imInShopModel
//                                                         .data
//                                                         .products[index]
//                                                         .price
//                                                         .toString()
//                                                         .length
//                                                         .toString()) *
//                                                     10,
//                                             child: Stack(
//                                               alignment: Alignment.center,
//                                               children: [
//                                                 Container(
//                                                   alignment: Alignment.center,
//                                                   child: Text(
//                                                       state
//                                                                   .imInShopModel
//                                                                   .data
//                                                                   .products[
//                                                                       index]
//                                                                   .priceWithDiscount !=
//                                                               null
//                                                           ? state
//                                                                       .imInShopModel
//                                                                       .data
//                                                                       .products[
//                                                                           index]
//                                                                       .price !=
//                                                                   null
//                                                               ? state
//                                                                       .imInShopModel
//                                                                       .data
//                                                                       .products[
//                                                                           index]
//                                                                       .price
//                                                                       .toString() +
//                                                                   " ${"rubleSignText".tr()}"
//                                                               : ""
//                                                           : "",
//                                                       style: TextStyle(
//                                                         decorationColor:
//                                                             colorBlack04,
//                                                         fontSize: 12,
//                                                         color: colorBlack04,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                       )),
//                                                 ),
//                                                 Container(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           bottom: 2),
//                                                   child: Image.asset(
//                                                     "assets/images/lineThroughImage.png",
//                                                     fit: BoxFit.contain,
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(width: 5),
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                   SizedBox(height: 5),
//                                   Divider()
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//             itemCount: state.imInShopModel.data.products.length,
//           );
//         }
//         if (state is ImInShopErrorState) {
//           return Container(
//             alignment: Alignment.center,
//             padding: const EdgeInsets.only(left: 20, right: 20),
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(15),
//                     topRight: Radius.circular(15))),
//             child: Center(
//                 child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.only(
//                       top: 15, bottom: 15, left: 15, right: 15),
//                   decoration: BoxDecoration(
//                       color: colorBlack03, shape: BoxShape.circle),
//                   child: SvgPicture.asset(
//                     'assets/images/netErrorIcon.svg',
//                     color: Colors.white,
//                     height: 30,
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 Text("errorText".tr(),
//                     style: GoogleFonts.raleway(
//                         fontSize: 18,
//                         color: colorBlack06,
//                         fontWeight: FontWeight.w500)),
//                 SizedBox(height: 10),
//                 InkWell(
//                     onTap: () {
//                       _imInShopBloc.add(ImInShopLoadEvent());
//                     },
//                     child: Container(
//                       color: Colors.transparent,
//                       child: Text("tryAgainText".tr(),
//                           style: GoogleFonts.raleway(
//                               fontSize: 14,
//                               color: mainColor,
//                               fontWeight: FontWeight.w500)),
//                     ))
//               ],
//             )),
//           );
//         }

//         return Center(child: Text("errorText".tr()));
//       },
//     );
//   }
// }
