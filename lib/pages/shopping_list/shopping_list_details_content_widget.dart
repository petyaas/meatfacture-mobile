// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart/bloc_files/shopping_list_details_bloc.dart';
import 'package:smart/pages/shopping_list/widgets/shopping_list_products_item_builder.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

import '../../bloc_files/basic_page_bloc.dart';
import '../../bloc_files/reg_page_bloc.dart';

class ShoppingListDetailsContentWidget extends StatelessWidget {
  const ShoppingListDetailsContentWidget({Key key}) : super(key: key);
// Списки покупок, 1 тело
  @override
  Widget build(BuildContext context) {
    // // ignore: close_sinks
    // SecondaryPageBloc _secondaryPageBloc =
    //     BlocProvider.of<SecondaryPageBloc>(context);
    ShoppingListDetailsBloc _shoppingListDetailsBloc = BlocProvider.of(context);
    BasicPageBloc _basicPageBloc = BlocProvider.of(context);
    AuthPageBloc _authPageBloc = BlocProvider.of(context);
    return BlocConsumer<ShoppingListDetailsBloc, ShoppingListDetailsState>(
      listener: (context, state) {
        if (state is ShoppingListDetailsOldTokenState) {
          ProfilePage.logout(regBloc: _authPageBloc, basicPageBloc: _basicPageBloc);
        }
      },
      builder: (context, state) {
        if (state is ShoppingListDetailsEmptyState) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/ListsImage.svg',
                color: colorBlack03,
                height: heightRatio(size: 70, context: context),
              ),
              SizedBox(height: heightRatio(size: 25, context: context)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 20, context: context)),
                child: Text("youHasNoGotProductsInThisShopListsText".tr(), textAlign: TextAlign.center, style: appTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack06, fontWeight: FontWeight.w500)),
              ),
            ],
          ));
        }

        if (state is ShoppingListDetailsLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(newRedDark),
            ),
          );
          // return ShimmerLoaderForShopList(); //можно удалить
        }

        if (state is ShoppingListDetailsLoadedState) {
          //if smth goes wrong
          return Container(
            color: whiteColor,
            child: SingleChildScrollView(
              child: ShoppinsListProductItemBuilder(shoppingListDeatailsModel: state.shoppingListDeatailsModel),
            ),
          );
        }

        //if smth goes wrong
        if (state is ShoppingListDetailsErrorState) {
          return Center(
            child: Column(
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
                Text("errorText".tr(), style: appTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack06, fontWeight: FontWeight.w500)),
                SizedBox(height: heightRatio(size: 10, context: context)),
                InkWell(
                  onTap: () {
                    _shoppingListDetailsBloc.add(ShoppingListDetailsLoadEvent(shoppingListUuid: state.shoppingListUuid));
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Text(
                      "tryAgainText".tr(),
                      style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
