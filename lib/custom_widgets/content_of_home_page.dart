// // ignore: implementation_imports
// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smart/bloc_files/shops_bloc.dart';
// import 'package:smart/bloc_files/diverse_food_bloc.dart';
// import 'package:smart/bloc_files/favorite_product_bloc.dart';
// import 'package:smart/bloc_files/im_in_shop_bloc.dart';
// import 'package:smart/bloc_files/profile_bloc.dart';
// import 'package:smart/bloc_files/secondary_pages_bloc.dart';
// import 'package:smart/bloc_files/shopping_lists_bloc.dart';
// import 'package:smart/bloc_files/smart_contacts_bloc.dart';
// import 'package:smart/custom_widgets/contacts_widgets.dart';
// import 'package:smart/custom_widgets/diverse_food_content.dart';
// import 'package:smart/custom_widgets/promo_descriptions_content.dart';
// import 'package:smart/custom_widgets/second_item_card.dart';
// import 'package:smart/custom_widgets/make_order_home_card.dart';
// import 'package:smart/custom_widgets/big_home_card.dart';
// import 'package:smart/models/favorite_product_variant_uuid_model.dart';
// import 'package:smart/pages/assortments_list_page.dart';
// import 'package:smart/pages/favorite_product_page.dart';
// import 'package:smart/pages/im_in_shop_page.dart';
// import 'package:smart/pages/secondary_page.dart';
// import 'package:smart/pages/shopping_lists_page.dart';
// import 'package:smart/pages/shops_page.dart';
// import 'package:smart/services/services.dart';
// import 'package:smart/core/constants/source.dart';

// class ContentHome extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // ignore: close_sinks
//     ImInShopBloc _imInShopBloc = BlocProvider.of<ImInShopBloc>(context);
//     // ignore: close_sinks
//     FavoriteProductbloc _favoriteProductbloc =
//         BlocProvider.of<FavoriteProductbloc>(context);
//     // ignore: close_sinks
//     ShoppingListsBloc _shoppingListsBloc =
//         BlocProvider.of<ShoppingListsBloc>(context);
//     // ignore: close_sinks
//     ShopsBloc _shopsBloc = BlocProvider.of<ShopsBloc>(context);
//     // ignore: close_sinks
//     SecondaryPageBloc _bottomNavBloc =
//         BlocProvider.of<SecondaryPageBloc>(context);
//     //ignore: close_sinks
//     // CatalogsBloc _catalogsBloc = BlocProvider.of<CatalogsBloc>(context);

//     // ignore: close_sinks
//     SmartContactsBloc _smartContactsBloc = BlocProvider.of(context);

//     // ignore: close_sinks
//     // ShoppingHistoryBloc _shoppingHistoryBloc =
//     //     BlocProvider.of<ShoppingHistoryBloc>(context);

//     return Container(
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: const Radius.circular(15),
//               topRight: const Radius.circular(15),
//             )),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               MakeOrderCard(),

//               // Home Menu
//               Container(
//                 margin: const EdgeInsets.only(left: 14, right: 20),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: InkWell(
//                         onTap: () {
//                           _imInShopBloc.add(ImInShopLoadEvent());
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ImInShopPage(),
//                               ));
//                         },
//                         child: SecondItemCard(
//                           elipsColor: imInShopElipsColor,
//                           imageAsset: 'assets/images/imInShopIcon.svg',
//                           label: 'iAmInStoreText'.tr(),
//                         ),
//                       ),
//                       flex: 1,
//                     ),
//                     Expanded(
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => SecondaryPage(
//                                     upText: "promoText".tr(),
//                                     contentWidget: PromoDescriptionsContent()),
//                               ));
//                         },
//                         child: SecondItemCard(
//                           elipsColor: sharesElipsColor,
//                           imageAsset: 'assets/images/sahredIcon.svg',
//                           label: 'promotionsText'.tr(),
//                         ),
//                       ),
//                       flex: 1,
//                     ),
//                     Expanded(
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => AssortmentsListPage(
//                                   isSearchPage: false,
//                                   isRecommendations: true,
//                                   preCataloName:
//                                       "productsForYouOneLineText".tr(),
//                                 ),
//                               ));
//                           // _catalogsBloc.add(CatalogAllAssortmentsEvent(
//                           //     currentPage: 1, isRecommendations: true));
//                           // _bottomNavBloc.add(CatalogEvent());
//                         },
//                         child: SecondItemCard(
//                           elipsColor: Color.fromRGBO(97, 204, 108, 1),
//                           imageAsset: 'assets/images/productForYouIcon.svg',
//                           label: 'productsForYouText'.tr(),
//                         ),
//                       ),
//                       flex: 1,
//                     ),
//                   ],
//                 ),
//               ),

//               BlocBuilder<ProfileBloc, ProfileState>(
//                 builder: (context, profileState) {
//                   String text2 = "";
//                   Color text2Color = Colors.grey;

//                   return BlocBuilder<DiverseFoodBloc, DiverseFoodState>(
//                     builder: (context, state) {
//                       if (profileState is ProfileLoadedState) {
//                         if (profileState
//                             .profileModel.data.isAgreeWithDiverseFoodPromo) {
//                           if (state is DiverseFoodLoadedState) {
//                             if (state
//                                 .diverseFoodPresentDiscountModel.data.isEmpty) {
//                               text2 = 'yourDiscountText'.tr() + ' 0%';
//                               text2Color = Colors.green;
//                             } else {
//                               text2 = 'yourDiscountText'.tr() +
//                                   ' ${state.diverseFoodPresentDiscountModel.data.first.discountPercent} %';
//                               text2Color = Colors.green;
//                             }
//                           }
//                         } else {
//                           text2 = '\n' + 'participateText'.tr();
//                           text2Color = Colors.grey;
//                         }
//                       }

//                       return Container(
//                         margin: const EdgeInsets.only(left: 10, right: 20),
//                         child: Row(
//                           children: [
//                             Expanded(
//                                 flex: 1,
//                                 child: InkWell(
//                                   onTap: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => SecondaryPage(
//                                                   upText:
//                                                       "diverseFoodOneLineText"
//                                                           .tr(),
//                                                   contentWidget:
//                                                       DiverseFoodContent(),
//                                                 )));
//                                     // _bottomNavBloc
//                                     // .add(DiverseFoodPageOpenEvent());
//                                   },
//                                   child: BigHomeCard(
//                                     text2Icon: null,
//                                     ellipsColor: foodEllipsColor,
//                                     text1: 'diverseFoodText'.tr(),
//                                     text2Color: text2Color,
//                                     text2: text2,
//                                     imageAsset: 'assets/images/%.svg',
//                                   ),
//                                 )),
//                             Expanded(
//                                 flex: 1,
//                                 child: BlocBuilder<FavoriteProductbloc,
//                                     FavoriteProductState>(
//                                   builder: (context, state) {
//                                     return InkWell(
//                                       onTap: () async {
//                                         // _assortmentRecommendationBloc.add(
//                                         //     AssortmentRecommendationsLoadEvent());
//                                         FavoriteProductVariantUuidModel
//                                             _favoriteProductVariantUuidModel =
//                                             await FavoriteProductProvider()
//                                                 .getFavoriteProductVariantUuidResponse();
//                                         if (state
//                                                 is FavoriteProductLoadedState &&
//                                             state.favoriteProductModel.data
//                                                 .isEmpty) {
//                                           if (_favoriteProductVariantUuidModel
//                                               .data.isEmpty) {
//                                             _favoriteProductbloc.add(
//                                                 FavoriteProductLoadEvent());
//                                             _favoriteProductbloc.add(
//                                                 FavoriteProductLoadEvent());
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       FavoriteProductPage(),
//                                                 ));
//                                           } else {
//                                             _bottomNavBloc.add(CatalogEvent());
//                                           }
//                                         } else {
//                                           _favoriteProductbloc
//                                               .add(FavoriteProductLoadEvent());
//                                           _favoriteProductbloc
//                                               .add(FavoriteProductLoadEvent());
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     FavoriteProductPage(),
//                                               ));
//                                         }
//                                       },
//                                       child: BigHomeCard(
//                                         text2Icon:
//                                             (state is FavoriteProductLoadedState &&
//                                                         state
//                                                             .favoriteProductModel
//                                                             .data
//                                                             .isEmpty) ||
//                                                     state
//                                                         is FavoriteProductLoadingState
//                                                 ? null
//                                                 : Icon(
//                                                     Icons.check,
//                                                     color: Colors.green,
//                                                     size: 20,
//                                                   ),
//                                         ellipsColor: favoriteellipsColor,
//                                         text1: "Любимый продукт",
//                                         text2: (state is FavoriteProductLoadedState &&
//                                                     state.favoriteProductModel
//                                                         .data.isEmpty) ||
//                                                 state
//                                                     is FavoriteProductLoadingState
//                                             ? '\n' + 'selectText'.tr()
//                                             : '\n' + 'selectedText'.tr(),
//                                         text2Color:
//                                             (state is FavoriteProductLoadedState &&
//                                                         state
//                                                             .favoriteProductModel
//                                                             .data
//                                                             .isEmpty) ||
//                                                     state
//                                                         is FavoriteProductLoadingState
//                                                 ? Colors.grey
//                                                 : Colors.green,
//                                         imageAsset:
//                                             'assets/images/heartIcon.svg',
//                                       ),
//                                     );
//                                   },
//                                 ))
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),

//               //Bottom Row Cards
//               Container(
//                 margin: const EdgeInsets.only(left: 14, right: 20, bottom: 12),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           _smartContactsBloc.add(SmartContactsLoadEvent());
//                           // _bottomNavBloc.add(ContactsEvent());
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => SecondaryPage(
//                                       upText: "contactsText".tr(),
//                                       contentWidget:
//                                           Center(child: ContactsWidget()))));
//                         },
//                         child: SecondItemCard(
//                           elipsColor: sharesElipsColor,
//                           imageAsset: 'assets/images/contactsCardIcon.svg',
//                           label: 'contactsText'.tr(),
//                         ),
//                       ),
//                       flex: 1,
//                     ),
//                     Expanded(
//                       child: InkWell(
//                         onTap: () {
//                           _shopsBloc.add(ShopsAsMapPointsEvent());
//                           // _bottomNavBloc.add(
//                           //     ShopsOpenEvent(secondaryPageEvent: HomeEvent()));

//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => ShopsPage()));
//                         },
//                         child: SecondItemCard(
//                           elipsColor: subscriptionsElipsColor,
//                           imageAsset: 'assets/images/mapPointIcon.svg',
//                           label: 'storesText'.tr(),
//                         ),
//                       ),
//                       flex: 1,
//                     ),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           _shoppingListsBloc.add(ShoppingListsLoadEvent());
//                           // _bottomNavBloc.add(ShoppingListsPageEvent());
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => ShoppinglistsPage()));
//                         },
//                         child: SecondItemCard(
//                           elipsColor: imInShopElipsColor,
//                           imageAsset: 'assets/images/ListsImage.svg',
//                           label: 'ListsText'.tr(),
//                         ),
//                       ),
//                       flex: 1,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
