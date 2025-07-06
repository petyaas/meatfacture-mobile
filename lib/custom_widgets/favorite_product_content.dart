// // ignore: implementation_imports
// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:smart/bloc_files/assortment_recommendations_bloc.dart';
// import 'package:smart/bloc_files/product_details_bloc.dart';
// import 'package:smart/bloc_files/product_details_middle_content_bloc.dart';
// import 'package:smart/bloc_files/product_in_shop_bloc.dart';
// import 'package:smart/bloc_files/secondary_pages_bloc.dart';
// import 'package:smart/custom_widgets/assortment_filter_button.dart';
// import 'package:smart/custom_widgets/product_details_middle_content_widget.dart';
// import 'package:smart/custom_widgets/product_details_tegs_widget.dart';
// import 'package:smart/custom_widgets/recomendation_list_widget.dart';
// import 'package:smart/custom_widgets/switch_buttons_on_product_details.dart';
// import 'package:smart/pages/product_in_shop_page.dart';
// import 'package:smart/services/services.dart';
// import 'package:smart/core/constants/source.dart';

// class FavoriteProductContent extends StatefulWidget {
//   @override
//   _ProductDetailsPageState createState() => _ProductDetailsPageState();
// }

// class _ProductDetailsPageState extends State<FavoriteProductContent> {
//   @override
//   Widget build(BuildContext context) {
//     ProductDetailsBloc _productDetailsBloc = BlocProvider.of(context);

//     SecondaryPageBloc _bottomNavBloc =
//         BlocProvider.of<SecondaryPageBloc>(context);

//     // ignore: close_sinks
//     ProductInShopBloc _productInShopBloc =
//         BlocProvider.of<ProductInShopBloc>(context);

//     // ignore: close_sinks
//     ProductDetMiddleContentBloc _productDetMiddleContentBloc =
//         BlocProvider.of<ProductDetMiddleContentBloc>(context);
//     // // ignore: close_sinks
//     // SecondaryPageBloc _bottomNavBloc =
//     //     BlocProvider.of<SecondaryPageBloc>(context);

//     // void _openaddingProductToShoppingListBottomSheet(
//     //     {BuildContext context,
//     //     String assortmentUuid,
//     //     String price,
//     //     int priceWithDiscount,
//     //     List<ProductDetailsUserShoppingList> addedShoppingList}) {
//     //   showModalBottomSheet<dynamic>(
//     //       isScrollControlled: true,
//     //       context: context,
//     //       shape:
//     //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
//     //       builder: (BuildContext bc) {
//     //         return AddProductToShoppingListBottomSheetwidget(
//     //           priceWithDiscount: priceWithDiscount,
//     //           assortmentPrice: price,
//     //           addedShoppingList: addedShoppingList,
//     //           assortmentUuid: assortmentUuid,
//     //         );
//     //       }).then((value) {});
//     // }

//     return WillPopScope(
//       onWillPop: () async {
//         // _bottomNavBloc.add(CatalogEvent());
//         _productDetMiddleContentBloc.add(ProductDetMiddleContentDisableEvent());
//         Navigator.pop(context);
//         return false;
//       },
//       child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
//           builder: (context, state) {
//         if (state is ProductDetailsEmptyState) {
//           return Container(
//             alignment: Alignment.center,
//             color: Colors.white,
//           );
//         }
//         if (state is ProductDetailsLoadingState) {
//           return Container(
//             alignment: Alignment.center,
//             color: Colors.white,
//             child: CircularProgressIndicator(
//               valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
//             ),
//           );
//         }
//         if (state is ProductDetailsErrorState) {
//           return Center(
//               child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.only(
//                     top: 15, bottom: 15, left: 15, right: 15),
//                 decoration:
//                     BoxDecoration(color: colorBlack03, shape: BoxShape.circle),
//                 child: SvgPicture.asset(
//                   'assets/images/netErrorIcon.svg',
//                   color: Colors.white,
//                   height: 30,
//                 ),
//               ),
//               SizedBox(height: 15),
//               Text("errorText".tr(),
//                   style: GoogleFonts.raleway(
//                       fontSize: 18,
//                       color: colorBlack06,
//                       fontWeight: FontWeight.w500)),
//               SizedBox(height: 10),
//               InkWell(
//                   onTap: () {
//                     _productDetailsBloc
//                         .add(ProductDetailsLoadEvent(uuid: state.uuid));
//                   },
//                   child: Container(
//                     color: Colors.transparent,
//                     child: Text("tryAgainText".tr(),
//                         style: GoogleFonts.raleway(
//                             fontSize: 14,
//                             color: mainColor,
//                             fontWeight: FontWeight.w500)),
//                   ))
//             ],
//           ));
//         }

//         // Basic State
//         if (state is ProductDetailsLoadedState) {
//           if (_productDetMiddleContentBloc.state
//               is ProductDetMiddleContentEmptyState) {
//             _productDetMiddleContentBloc.add(
//                 ProductDetMiddleContentDescriptionEvent(
//                     productDetailsModel: state.productDetailsModel));
//           }
//           return Container(
//             color: Colors.white,
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Container(
//                     alignment: Alignment.topLeft,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Stack(children: [
//                           Container(
//                             height: 380,
//                             width: MediaQuery.of(context).size.width,
//                             child: Image.network(
//                               state.productDetailsModel.data.images[0].path,
//                               fit: BoxFit.contain,
//                             ),
//                           ),
//                           //Rating
//                           Positioned(
//                               top: 320,
//                               left: 20,
//                               child: Container(
//                                 padding: const EdgeInsets.only(
//                                     left: 7, top: 3, bottom: 3, right: 5),
//                                 decoration: BoxDecoration(
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black26,
//                                         spreadRadius: 5,
//                                         offset: Offset(0, 0),
//                                         blurRadius: 20,
//                                       )
//                                     ],
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(5)),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Icon(
//                                       state.productDetailsModel.data.rating !=
//                                               null
//                                           ? Icons.star
//                                           : Icons.star_outline,
//                                       size: 20,
//                                       color: Color.fromRGBO(255, 166, 101, 1),
//                                     ),
//                                     SizedBox(width: 5),
//                                     Text(
//                                       state.productDetailsModel.data.rating ==
//                                               null
//                                           ? ''
//                                           : state
//                                               .productDetailsModel.data.rating
//                                               .toString(),
//                                       style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600,
//                                           color: colorBlack04),
//                                     )
//                                   ],
//                                 ),
//                               )),
//                           Container(
//                             margin: const EdgeInsets.only(top: 15),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   flex: 1,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       InkWell(
//                                         onTap: () async {
//                                           if (await AssortmentFilterButton()
//                                                   .loadToken() ==
//                                               "guest") {
//                                             AssortmentFilterButton()
//                                                 .loginOrRegWarning(context);
//                                           }
//                                         },
//                                         child: Container(
//                                           height: 45,
//                                           width: 45,
//                                           padding: const EdgeInsets.all(10),
//                                           decoration: BoxDecoration(
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.black26,
//                                                 spreadRadius: 5,
//                                                 offset: Offset(0, 0),
//                                                 blurRadius: 20,
//                                               )
//                                             ],
//                                             shape: BoxShape.circle,
//                                             color: Colors.white,
//                                           ),
//                                           child: Icon(
//                                             state.productDetailsModel.data
//                                                     .isPromoFavorite
//                                                 ? Icons.favorite
//                                                 : Icons.favorite_border,
//                                             color: orangeTextColor,
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(width: 25),
//                                       InkWell(
//                                         onTap: () async {
//                                           if (await AssortmentFilterButton()
//                                                   .loadToken() !=
//                                               "guest") {
//                                             if (state.productDetailsModel.data
//                                                 .isFavorite) {
//                                               setState(() {
//                                                 state.productDetailsModel.data
//                                                     .isFavorite = false;
//                                               });
//                                             } else {
//                                               setState(() {
//                                                 state.productDetailsModel.data
//                                                     .isFavorite = true;
//                                               });
//                                             }

//                                             await AddDeleteProductToFavoriteProvider(
//                                                     isLiked: !state
//                                                         .productDetailsModel
//                                                         .data
//                                                         .isFavorite,
//                                                     productUuid: state
//                                                         .productDetailsModel
//                                                         .data
//                                                         .uuid)
//                                                 .getisAddProductTofavoriteResponse();
//                                           } else {
//                                             AssortmentFilterButton()
//                                                 .loginOrRegWarning(context);
//                                           }
//                                         },
//                                         child: Container(
//                                           height: 45,
//                                           width: 45,
//                                           padding: const EdgeInsets.all(10),
//                                           decoration: BoxDecoration(
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.black26,
//                                                 spreadRadius: 5,
//                                                 offset: Offset(0, 0),
//                                                 blurRadius: 20,
//                                               )
//                                             ],
//                                             shape: BoxShape.circle,
//                                             color: Colors.white,
//                                           ),
//                                           child: SvgPicture.asset(
//                                             state.productDetailsModel.data
//                                                         .isFavorite ==
//                                                     true
//                                                 ? "assets/images/activeTapeIcon.svg"
//                                                 : "assets/images/tapeIcon.svg",
//                                             color: orangeTextColor,
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(width: 15),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ]),
//                         Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey[200],
//                                   offset: Offset(0, -10),
//                                   blurRadius: 15,
//                                   spreadRadius: 7,
//                                 )
//                               ],
//                               borderRadius: BorderRadius.only(
//                                 topLeft: const Radius.circular(15),
//                                 topRight: const Radius.circular(15),
//                               ),
//                             ),
//                             child: Column(children: [
//                               //Name
//                               Container(
//                                 padding: const EdgeInsets.only(
//                                     left: 10, right: 15, top: 15),
//                                 alignment: Alignment.centerLeft,
//                                 child: Text(
//                                   state.productDetailsModel.data.name,
//                                   style: GoogleFonts.raleway(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18),
//                                 ),
//                               ),
//                               SizedBox(height: 25),

//                               //button in shop
//                               InkWell(
//                                 onTap: () {
//                                   _productInShopBloc.add(
//                                       ProductInShopAsListEvent(
//                                           assortmentUnitId: state
//                                               .productDetailsModel
//                                               .data
//                                               .assortmentUnitId,
//                                           storesListModel: state
//                                               .productDetailsModel
//                                               .data
//                                               .stores));

//                                   Navigator.push(
//                                       context,
//                                       new MaterialPageRoute(
//                                         builder: (context) => ProductInShopPage(
//                                           assortmentUnitId: state
//                                               .productDetailsModel
//                                               .data
//                                               .assortmentUnitId,
//                                           storesListModel: state
//                                               .productDetailsModel.data.stores,
//                                         ),
//                                       ));
//                                 },
//                                 child: Container(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 15),
//                                   margin: const EdgeInsets.symmetric(
//                                       horizontal: 10),
//                                   decoration: BoxDecoration(
//                                       border: Border.all(
//                                           color: orangeTextColor, width: 1.5),
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(15)),
//                                   alignment: Alignment.center,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.pin_drop_outlined,
//                                         color: orangeTextColor,
//                                       ),
//                                       Text('availabilityinStoresText'.tr(),
//                                           style: GoogleFonts.raleway(
//                                               color: mainColor))
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 35),

//                               Container(
//                                   margin: const EdgeInsets.symmetric(
//                                       horizontal: 10),
//                                   child: SwitchButtonsOnProductDetails(
//                                     productDetailsModel:
//                                         state.productDetailsModel,
//                                   )),

//                               //Middle content

//                               Container(
//                                   margin: const EdgeInsets.symmetric(
//                                       horizontal: 10, vertical: 20),
//                                   child: ProductDetailsMiddleContent()),
//                               ProductDetailsTegsWidget(
//                                 tagsList: state.productDetailsModel.data.tags,
//                               ),

//                               BlocBuilder<AssortmentRecommendationBloc,
//                                   AssortmentRecommendationsState>(
//                                 builder: (context, state) {
//                                   if (state
//                                       is AssortmentRecommendationsLoadedState) {
//                                     return Column(
//                                       children: [
//                                         Container(
//                                             margin: const EdgeInsets.only(
//                                                 left: 15, right: 15),
//                                             alignment: Alignment.bottomLeft,
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Text("RecommendationsText".tr(),
//                                                     style: GoogleFonts.raleway(
//                                                         fontSize: 16,
//                                                         fontWeight:
//                                                             FontWeight.w600)),
//                                                 InkWell(
//                                                   onTap: () {
//                                                     // _catalogsBloc.add(
//                                                     //     CatalogAllAssortmentsEvent(
//                                                     //         currentPage: 1,
//                                                     //         isRecommendations:
//                                                     //             true));
//                                                     _bottomNavBloc
//                                                         .add(CatalogEvent());
//                                                   },
//                                                   child: Text(
//                                                       "viewAllText".tr(),
//                                                       style:
//                                                           GoogleFonts.raleway(
//                                                               fontSize: 14,
//                                                               color: mainColor,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500)),
//                                                 ),
//                                               ],
//                                             )),
//                                         SizedBox(height: 20),

//                                         Container(
//                                             height: 240,
//                                             child: RecomendationListWidget()),
//                                         // CatalogRecomendWidget(),
//                                         SizedBox(height: 20),
//                                       ],
//                                     );
//                                   }
//                                   return SizedBox();
//                                 },
//                               ),
//                             ])),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }

//         return Container(
//           alignment: Alignment.center,
//           color: Colors.white,
//           child: Text('errorText'.tr()),
//         );
//       }),
//     );
//   }
// }
