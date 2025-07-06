// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/bloc_files/shopping_lists_bloc.dart';
import 'package:smart/custom_widgets/create_new_shopping_list_bottom_sheet.dart';
import 'package:smart/features/catalog/subcatalog_screen.dart';
import 'package:smart/main.dart';
import 'package:smart/pages/shopping_list/shopping_lists_item_builder.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

import '../../bloc_files/basic_page_bloc.dart';
import '../../bloc_files/reg_page_bloc.dart';

// Списки покупок
class ShoppingListsContentWidget extends StatelessWidget {
  void _openBottomSheetNewShoppingListCrater(BuildContext context) {
    showModalBottomSheet(
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
        return Wrap(
          children: [
            NewShoppingListBottomSheetWidget(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    BasicPageBloc _basicPageBloc = BlocProvider.of(context);
    AuthPageBloc _authPageBloc = BlocProvider.of(context);
    ShoppingListsBloc _shoppingListsBloc = BlocProvider.of(context);
    return BlocConsumer<ShoppingListsBloc, ShoppingListsState>(
      listener: (context, state) {
        if (state is ShoppingListsOldTokenState) {
          ProfilePage.logout(regBloc: _authPageBloc, basicPageBloc: _basicPageBloc);
        }
      },
      builder: (context, state) {
        if (state is ShoppingListsEmptyState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/newEmptyList.svg',
                  width: widthRatio(size: 131, context: context),
                  height: heightRatio(size: 131, context: context),
                ),
                SizedBox(height: heightRatio(size: 22, context: context)),
                SizedBox(
                  width: widthRatio(size: 256, context: context),
                  child: Text(
                    'У вас не создано ни одного списка покупок',
                    textAlign: TextAlign.center,
                    style: appLabelTextStyle(
                      fontSize: heightRatio(size: 18, context: context),
                      color: newBlack,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(height: heightRatio(size: 25, context: context)),
                InkWell(
                  onTap: () => BlocProvider.of<SecondaryPageBloc>(context).add(CatalogEvent()),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    margin: const EdgeInsets.only(right: 20, left: 20),
                    width: widthRatio(size: 205, context: context),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                    child: Text(
                      'Перейти к покупкам',
                      style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                    ),
                  ),
                ),
                SizedBox(height: heightRatio(size: 15, context: context)),
                InkWell(
                  onTap: () async {
                    BlocProvider.of<SecondaryPageBloc>(context).add(CatalogEvent());
                    navigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (context) => SubcatalogScreen(isSearchPage: false, isFavorite: true),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    margin: const EdgeInsets.only(right: 20, left: 20),
                    width: widthRatio(size: 205, context: context),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newBlack),
                    child: Text(
                      'Перейти в избранное',
                      style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        if (state is ShoppingListsLoadingState) {
          return Center(
            child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(newRedDark)),
          );
          // return ShimmerLoaderForShopList(); //можно удалить наверное
        }

        if (state is ShoppingListsLoadedState) {
          return Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: state.shoppingListsModel.data.length * 100.0,
                  child: ShoppingListsItemBuilder(shoppingListsModel: state.shoppingListsModel),
                ),
                InkWell(
                  onTap: () => _openBottomSheetNewShoppingListCrater(context),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: heightRatio(size: 15, context: context), bottom: heightRatio(size: 18, context: context)),
                    margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: newRedDark),
                    child: Text(
                      'Создать новый список',
                      style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
                decoration: BoxDecoration(color: colorBlack03, shape: BoxShape.circle),
                child: SvgPicture.asset(
                  'assets/images/netErrorIcon.svg',
                  color: whiteColor,
                  height: heightRatio(size: 30, context: context),
                ),
              ),
              SizedBox(height: heightRatio(size: 15, context: context)),
              Text("errorText".tr(), style: appTextStyle(fontSize: heightRatio(size: 18, context: context), color: colorBlack06, fontWeight: FontWeight.w500)),
              SizedBox(height: heightRatio(size: 10, context: context)),
              InkWell(
                onTap: () => _shoppingListsBloc.add(ShoppingListsLoadEvent()),
                child: Container(
                  color: Colors.transparent,
                  child: Text(
                    "tryAgainText".tr(),
                    style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor, fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
