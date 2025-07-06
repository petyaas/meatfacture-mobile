import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/yellow_promo_assortments_bloc.dart';
import 'package:smart/features/catalog/widgets/catalog_product_widget.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/catalog/subcatalog_screen.dart';

class SpecialPromoDescPage extends StatelessWidget {
  final String promoName;
  final String infoText;
  final String yellowOrGreenPage;
  final String promotitle;

  const SpecialPromoDescPage({@required this.promoName, @required this.infoText, @required this.yellowOrGreenPage, @required this.promotitle});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YellowPromoAssortmentsBloc, YellowPromoAssortmentsState>(builder: (context, state) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          alignment: Alignment.topCenter,
          color: lightGreyColor,
          child: Column(children: [
            Container(
              decoration: BoxDecoration(color: yellowOrGreenPage == "y" ? yellowForPromo : greenForPromo, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(heightRatio(size: 20, context: context)), bottomRight: Radius.circular(heightRatio(size: 20, context: context)))),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    yellowOrGreenPage == "y" ? "assets/images/yellow_promo_bg_image.png" : "assets/images/green_promo_bg_image.png",
                    width: screenWidth(context) / 1,
                    height: screenHeight(context) / 5.5,
                  ),
                  Positioned(
                    left: 0,
                    top: heightRatio(size: 6, context: context),
                    child: SafeArea(
                      bottom: false,
                      child: InkWell(
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.only(left: widthRatio(size: 15, context: context)),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: heightRatio(size: 25, context: context),
                            color: blackColor,
                          ),
                        ),
                        onTap: () {
                          // _bottomNavBloc.add(HomeEvent());
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: heightRatio(size: 15, context: context)),
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                    topRight: Radius.circular(heightRatio(size: 15, context: context)),
                  ),
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: SizedBox(height: heightRatio(size: 20, context: context))),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                        child: Text(
                          promotitle,
                          style: appHeadersTextStyle(fontSize: heightRatio(size: 22, context: context), fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: heightRatio(size: 10, context: context))),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                        child: Text(
                          infoText,
                          style: appTextStyle(fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    if (yellowOrGreenPage == "y") SliverToBoxAdapter(child: SizedBox(height: heightRatio(size: 24, context: context))),
                    if (yellowOrGreenPage == "y")
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
                          child: Text(
                            "productsParticipatingInThePromotionText".tr(),
                            style: appTextStyle(fontSize: widthRatio(size: 18, context: context), fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    if (yellowOrGreenPage == "y")
                      if (state is YellowPromoAssortmentsLoadingState && yellowOrGreenPage == "y")
                        SliverToBoxAdapter(
                          child: Container(
                            margin: EdgeInsets.only(top: heightRatio(size: 30, context: context)),
                            width: screenWidth(context),
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor)),
                          ),
                        ),
                    if (state is YellowPromoAssortmentsLoadedState && yellowOrGreenPage == "y")
                      SliverToBoxAdapter(
                        child: SizedBox(height: heightRatio(size: 15, context: context)),
                      ),
                    if (state is YellowPromoAssortmentsLoadedState && yellowOrGreenPage == "y")
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 10, context: context)),
                        sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return CatalogProductWidget(isRecomendations: false, assortmentsListModel: state.assortmentsList[index]);
                              },
                              childCount: state.assortmentsList.length < 8 ? state.assortmentsList.length : 8,
                            ),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1.45, crossAxisCount: 2)),
                      ),
                    if (state is YellowPromoAssortmentsLoadedState && state.assortmentsList.length > 8 && yellowOrGreenPage == "y")
                      SliverToBoxAdapter(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubcatalogScreen(
                                    isPromoAssortment: true,
                                    isSearchPage: false,
                                    preCataloName: promoName,
                                  ),
                                ));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
                            margin: EdgeInsets.only(bottom: heightRatio(size: 15, context: context), top: heightRatio(size: 15, context: context), left: widthRatio(size: 15, context: context), right: widthRatio(size: 15, context: context)),
                            decoration: BoxDecoration(color: lightGreyColor, borderRadius: BorderRadius.circular(widthRatio(size: 15, context: context))),
                            child: Text(
                              "lookAllPromoAssortmentText".tr(),
                              style: appTextStyle(color: mainColor, fontSize: widthRatio(size: 14, context: context), fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            )
          ]),
        ),
      );
    });
  }
}

//yellow_promo_bg_image.png
