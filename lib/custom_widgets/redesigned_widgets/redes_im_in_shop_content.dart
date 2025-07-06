import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart/bloc_files/basic_page_bloc.dart';
import 'package:smart/bloc_files/im_in_shop_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_event.dart';
import 'package:smart/features/catalog/widgets/catalog_product_widget.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_im_in_shop_assortments_list_widget.dart';
import 'package:smart/features/home/home_choose_store_screen.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class RedesImInShopContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AddressesShopBloc _shopsBloc = BlocProvider.of<AddressesShopBloc>(context);
    ImInShopBloc _imInShopBloc = BlocProvider.of(context);
    BasicPageBloc basicPageBloc = BlocProvider.of(context);
    AuthPageBloc authPageBloc = BlocProvider.of(context);
    return BlocConsumer<ImInShopBloc, ImInShopState>(
      listener: (context, state) {
        if (state is ImInShopOldTokenState) {
          ProfilePage.logout(regBloc: authPageBloc, basicPageBloc: basicPageBloc);
        }
      },
      builder: (context, state) {
        if (state is ImInShopLoadingState) {
          return Container(
            alignment: Alignment.center,
            color: whiteColor,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(newRedDark),
            ),
          );
        }
        if (state is ImInShopNotStoreShooseState) {
          return Container(
            color: whiteColor,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/im_in_shop_main_icon.svg"),
                SizedBox(width: screenWidth(context) / 2),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 40, context: context)),
                  child: Text("chooseStoreWarningText".tr(), textAlign: TextAlign.center, style: appTextStyle(fontSize: heightRatio(size: 22, context: context), color: blackColor, fontWeight: FontWeight.w800)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: widthRatio(size: 40, context: context), right: widthRatio(size: 40, context: context), top: heightRatio(size: 10, context: context), bottom: heightRatio(size: 30, context: context)),
                  child: Text("imInShopDescText".tr(), textAlign: TextAlign.center, style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: blackColor, fontWeight: FontWeight.w500)),
                ),
                InkWell(
                  onTap: () {
                    _shopsBloc.add(MapAddressesShopEvent());
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeChooseStoreScreen()));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
                    padding: EdgeInsets.symmetric(vertical: heightRatio(size: 16, context: context)),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: newRedDark,
                      borderRadius: BorderRadius.circular(widthRatio(size: 12, context: context)),
                    ),
                    child: Text(
                      "Выбрать магазин",
                      style: appTextStyle(
                        fontWeight: FontWeight.w600,
                        color: whiteColor,
                        fontSize: heightRatio(size: 14, context: context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is ImInShopLoadedState) {
          return Column(
            children: [
              SizedBox(height: heightRatio(size: 12, context: context)),
              Expanded(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                      topRight: Radius.circular(heightRatio(size: 15, context: context)),
                    ),
                    color: Colors.white,
                  ),
                  child: GridView.builder(
                    padding: EdgeInsets.only(
                      left: widthRatio(size: 16, context: context),
                      right: widthRatio(size: 16, context: context),
                      top: heightRatio(size: 25, context: context),
                    ),
                    shrinkWrap: true,
                    itemCount: state.imInShopModel.data.products.length,
                    //ya v magazine
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.7,
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                    ),
                    itemBuilder: (context, index) => CatalogProductWidget(
                      isRecomendations: false,
                      assortmentsListModel: mapImInShopProductToAssortmentProduct(product: state.imInShopModel.data.products[index]),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        if (state is ImInShopErrorState) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: widthRatio(size: 20, context: context), right: widthRatio(size: 20, context: context)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                topRight: Radius.circular(heightRatio(size: 15, context: context)),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
                    decoration: BoxDecoration(color: colorBlack03, shape: BoxShape.circle),
                    child: SvgPicture.asset('assets/images/netErrorIcon.svg', color: Colors.white, height: heightRatio(size: 30, context: context)),
                  ),
                  SizedBox(height: heightRatio(size: 15, context: context)),
                  Text("errorText".tr(), style: appTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack06, fontWeight: FontWeight.w500)),
                  SizedBox(height: heightRatio(size: 10, context: context)),
                  InkWell(
                    onTap: () {
                      _imInShopBloc.add(ImInShopLoadEvent());
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Text("tryAgainText".tr(), style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Center(child: Text("errorText".tr()));
      },
    );
  }
}
