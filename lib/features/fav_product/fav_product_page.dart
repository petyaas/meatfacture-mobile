import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc_files/basic_page_bloc.dart';
import 'package:smart/bloc_files/favorite_product_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/features/fav_product/widgets/fav_product_choose_btn.dart';
import 'package:smart/features/home/widgets/home_icon_bottom_sheet.dart';
import 'package:smart/features/fav_product/widgets/fav_prod_picker_catalog_bottom_sheet.dart';
import 'package:smart/features/fav_product/widgets/fav_prod_active.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class FavProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BasicPageBloc _basicPageBloc = BlocProvider.of(context);
    AuthPageBloc _authPageBloc = BlocProvider.of(context);
    FavoriteProductBloc _favoriteProductbloc = BlocProvider.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: screenHeight(context),
        color: screenBackgrountGreyColor,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: screenHeight(context) / 2.8,
              width: screenWidth(context),
              padding: EdgeInsets.only(top: heightRatio(size: 6, context: context)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(heightRatio(size: 25, context: context)),
                  bottomRight: Radius.circular(heightRatio(size: 25, context: context)),
                ),
                color: newRedDark,
              ),
              child: SafeArea(
                child: Container(
                  height: heightRatio(size: 30, context: context),
                  width: screenWidth(context),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        left: 0,
                        child: InkWell(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.only(
                                bottom: heightRatio(size: 5, context: context),
                                right: widthRatio(size: 15, context: context),
                                left: widthRatio(size: 15, context: context)),
                            child: Icon(Icons.arrow_back_ios_new_rounded, size: heightRatio(size: 25, context: context), color: whiteColor),
                          ),
                          onTap: () {
                            // _bottomNavBloc.add(HomeEvent());
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(width: widthRatio(size: 10, context: context)),
                      Text(
                        "Любимый продукт",
                        style: appHeadersTextStyle(fontSize: heightRatio(size: 22, context: context), fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: heightRatio(size: 60, context: context),
              left: screenWidth(context) / 4 - widthRatio(size: 4, context: context),
              child: Image.asset('assets/images/heart_favorite_big.png'),
              width: screenWidth(context) / 1.8,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: screenHeight(context) / 3 - (screenHeight(context) / 3) / 1.65,
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        SizedBox(height: heightRatio(size: 10, context: context)),
                        BlocConsumer<FavoriteProductBloc, FavoriteProductState>(
                          listener: (context, state) {
                            if (state is FavoriteProductOldTokenState) {
                              ProfilePage.logout(regBloc: _authPageBloc, basicPageBloc: _basicPageBloc);
                            }
                          },
                          builder: (context, state) {
                            if (state is FavoriteProductLoadingState) {
                              return Container(
                                height: heightRatio(size: 290, context: context),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                              );
                            }
                            if (state is FavoriteProductErrorState) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
                                    decoration: BoxDecoration(color: colorBlack03, shape: BoxShape.circle),
                                    child: SvgPicture.asset(
                                      'assets/images/netErrorIcon.svg',
                                      color: Colors.white,
                                      height: heightRatio(size: 30, context: context),
                                    ),
                                  ),
                                  SizedBox(height: heightRatio(size: 15, context: context)),
                                  Text("errorText".tr(),
                                      style: appTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack06, fontWeight: FontWeight.w500)),
                                  SizedBox(height: heightRatio(size: 10, context: context)),
                                  InkWell(
                                    onTap: () {
                                      _favoriteProductbloc.add(FavoriteProductLoadEvent());
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Text("tryAgainText".tr(),
                                          style:
                                              appTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor, fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (state is FavoriteProductLoadedState) {
                              if (state.favoriteProductModel.data.isNotEmpty) {
                                return FavProdActive();
                              } else {
                                if (state.favoriteProductVariantUuidModel.data.isEmpty) {
                                  if (state.favoriteProductTitleModel.data.isNotEmpty) {
                                    // showBottomSheetWithtitle(
                                    //     description:
                                    //         state.favoriteProductTitleModel.data.first.description,
                                    //     context: context,
                                    //     title: state.favoriteProductTitleModel.data.first.title);
                                  } else {
                                    // showBottomSheetWithtitle(
                                    //     description: "", context: context, title: "");
                                  }
                                }
                                return Column(
                                  children: [
                                    SizedBox(height: heightRatio(size: 10, context: context)),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                                      child: Text(
                                        state.favoriteProductVariantUuidModel.data.isNotEmpty ? "У вас еще не выбран\nлюбимый продукт" : "",
                                        textAlign: TextAlign.center,
                                        style: appLabelTextStyle(
                                          fontSize: heightRatio(size: 22, context: context),
                                          color: whiteColor,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: heightRatio(size: 55, context: context)),
                                    if (state.favoriteProductVariantUuidModel.data.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                                        child: Column(
                                          children: [
                                            FavProductChooseBtn(),
                                            SizedBox(height: heightRatio(size: 16, context: context)),
                                            InkWell(
                                              onTap: () {
                                                showModalBottomSheet<dynamic>(
                                                  isScrollControlled: true,
                                                  useSafeArea: true,
                                                  context: context,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(heightRatio(size: 25, context: context)),
                                                      topRight: Radius.circular(heightRatio(size: 25, context: context)),
                                                    ),
                                                  ),
                                                  builder: (BuildContext bc) {
                                                    return FavProdPickerCatalogBottomSheet();
                                                  },
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: newRedDark, borderRadius: BorderRadius.circular(heightRatio(size: 15, context: context))),
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(vertical: heightRatio(size: 20, context: context)),
                                                child: Text(
                                                  "Выбрать любимый продукт",
                                                  style: appLabelTextStyle(
                                                      fontSize: heightRatio(size: heightRatio(size: 16, context: context), context: context),
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      Container(
                                        decoration: BoxDecoration(
                                          color: newBlack,
                                          borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)),
                                        ),
                                        alignment: Alignment.center,
                                        height: heightRatio(size: 57, context: context),
                                        margin: EdgeInsets.symmetric(horizontal: 16),
                                        child: RichText(
                                          text: TextSpan(
                                            text: "leftToBuyOnText".tr() + ": ${(900 - double.parse(state.purchasesSumModel)).toStringAsFixed(0)} ",
                                            style: appLabelTextStyle(fontSize: heightRatio(size: 16, context: context), color: Colors.white),
                                            children: [
                                              TextSpan(
                                                text: 'rubleSignText'.tr(),
                                                style: appTextStyle(fontSize: heightRatio(size: 16, context: context), color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              }
                            }
                            return Text("Что то пошло не так");
                          },
                        ),
                        SizedBox(height: heightRatio(size: 16, context: context)),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: heightRatio(size: 24, context: context),
                              horizontal: widthRatio(size: 15, context: context),
                            ),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                                topRight: Radius.circular(heightRatio(size: 15, context: context)),
                              ),
                            ),
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Как работает любимый\nпродукт?",
                                  style: appHeadersTextStyle(fontSize: heightRatio(size: 22, context: context)),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: heightRatio(size: 10, context: context)),
                                SvgPicture.asset(
                                  "assets/images/for_favorite.svg",
                                  height: heightRatio(size: 56, context: context),
                                  fit: BoxFit.scaleDown,
                                ),
                                SizedBox(height: heightRatio(size: 18, context: context)),
                                Text(
                                  "Любимый продукт действует в течении недели.\nЕго можно менять хоть каждый день.\nПри изменении продукта, скидка действует на следующий день. Нужно только:",
                                  style: appLabelTextStyle(
                                    fontSize: heightRatio(size: 15, context: context),
                                    color: newBlackLight,
                                    height: 1.22,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: heightRatio(size: 20, context: context)),
                                Text(
                                  "Купить продуктов на 900 рублей в течении 1 дня",
                                  style: appLabelTextStyle(
                                    fontSize: heightRatio(size: 15, context: context),
                                    color: newRedDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showBottomSheetWithtitle({String description, String title, BuildContext context}) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet<dynamic>(
          isScrollControlled: true,
          useSafeArea: true,
          context: context,
          // isDismissible: false,
          enableDrag: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(heightRatio(size: 25, context: context)),
              topRight: Radius.circular(heightRatio(size: 25, context: context)),
            ),
          ),
          builder: (BuildContext bc) {
            return Wrap(
              children: [
                HomeIconBottomSheet(
                  infoText: description,
                  promoName: title,
                ),
              ],
            );
          }).then((value) {});
    });
  }
}
