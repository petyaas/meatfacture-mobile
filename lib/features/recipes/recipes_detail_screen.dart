import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/bloc_files/Basic_page_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/custom_widgets/reg_or_login_warning_bottomSheet.dart';
import 'package:smart/features/recipes/models/receipts_list_model.dart';
import 'package:smart/features/recipes/recipe_stories_screen.dart';
import 'package:smart/features/recipes/widgets/recipe_product_card.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/theme/app_alert.dart';
import 'package:smart/theme/app_button.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Datum recipe;
  const RecipeDetailScreen({@required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isActive;

  @override
  void initState() {
    isActive = widget.recipe.isFavorite;
    super.initState();
  }

  Future<String> loadToken() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    return _shared.getString(SharedKeys.token);
  }

  void loginOrRegWarning(BuildContext context) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(heightRatio(size: 25, context: context)),
            topRight: Radius.circular(heightRatio(size: 25, context: context)),
          ),
        ),
        builder: (BuildContext bc) {
          return RegOrLoginWarningBottomSheet();
        }).then((value) {});
  }

  void onTapFavoriteButton() async {
    String isAuth = await loadToken();
    if (isAuth != "guest") {
      if (widget.recipe.isFavorite) {
        setState(() {
          widget.recipe.isFavorite = false;
          isActive = false;
        });
      } else {
        setState(() {
          widget.recipe.isFavorite = true;
          isActive = true;
        });
        AppAlert.show(
          context: context,
          message: 'Рецепт “${widget.recipe.name != null ? widget.recipe.name : ''}” был добавлен в “Сохраненные рецепты”',
          sec: 3,
          svgName: 'newCart.svg',
        );
      }
      var _likeResponse = await AddOrDeleteReceiptsToFavoriteProvider(isFavorite: !widget.recipe.isFavorite, mealReceiptUuid: widget.recipe.uuid)
          .addOrDeleteReceiptsToFavoriteResponse();
      if (_likeResponse == "old token") {
        AuthPageBloc authPageBloc = BlocProvider.of(context);
        BlocProvider.of<BasicPageBloc>(context)?.add(ProfilePage.logout(regBloc: authPageBloc, basicPageBloc: BlocProvider.of(context)));
      }
    } else {
      loginOrRegWarning(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: newRedDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: heightRatio(size: 15, context: context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(isActive),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12.5),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: heightRatio(size: 25, context: context),
                      color: whiteColor,
                    ),
                  ),
                ),
                Text(
                  'Страница рецепта',
                  style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: widthRatio(size: 60, context: context)),
              ],
            ),
            SizedBox(height: heightRatio(size: 20, context: context)),
            Expanded(
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                    topRight: Radius.circular(heightRatio(size: 15, context: context)),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    vertical: heightRatio(size: 19, context: context),
                    horizontal: widthRatio(size: 16, context: context),
                  ),
                  children: [
                    widget.recipe.filePath != null && widget.recipe.filePath != '' && widget.recipe.filePath != ' '
                        ? Container(
                            height: heightRatio(size: 230.0, context: context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(widget.recipe.filePath)),
                            ),
                            alignment: Alignment.center,
                            child: widget.recipe.tabs.isNotEmpty
                                ? InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => RecipeStoriesScreen(
                                            recipe: widget.recipe,
                                          ),
                                        ),
                                      );
                                    },
                                    child: SvgPicture.asset('assets/images/play_recipe.svg'),
                                  )
                                : SizedBox.shrink(),
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: heightRatio(size: 10, context: context)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            widget.recipe.name != null ? widget.recipe.name : '',
                            style: appHeadersTextStyle(fontSize: heightRatio(size: 18, context: context)),
                          ),
                        ),
                        InkWell(
                          onTap: onTapFavoriteButton,
                          child: Container(
                            margin: EdgeInsets.only(left: widthRatio(size: 20, context: context)),
                            height: heightRatio(size: 36, context: context),
                            width: widthRatio(size: 36, context: context),
                            decoration: BoxDecoration(color: newBlack, borderRadius: BorderRadius.circular(18)),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              isActive ? 'assets/images/newHeartRactive.svg' : 'assets/images/newHeartR.svg',
                              height: heightRatio(size: 17, context: context),
                              width: widthRatio(size: 17, context: context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heightRatio(size: 16, context: context)),
                    Text(
                      widget.recipe.title != null ? widget.recipe.title : '',
                      style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack, height: 1.2),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: heightRatio(size: 16, context: context)),
                    Text(
                      widget.recipe.description != null ? widget.recipe.description : '',
                      style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack, height: 1.2),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: heightRatio(size: 16, context: context)),
                    Container(
                      color: Color(0xFFF2F2F2),
                      height: heightRatio(size: 1, context: context),
                    ),
                    SizedBox(height: heightRatio(size: 16, context: context)),
                    Text(
                      'Ингредиенты',
                      style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context)),
                    ),
                    SizedBox(height: heightRatio(size: 12, context: context)),
                    widget.recipe.ingredients != null && widget.recipe.ingredients.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.recipe.ingredients.map((item) {
                              return Text(
                                '${item.name} - ${item.quantity}',
                                style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack, height: 1.2),
                              );
                            }).toList(),
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: heightRatio(size: 25, context: context)),
                    AppButton(
                      text: isActive ? 'Вы уже сохранили этот рецепт' : 'Сохранить рецепт',
                      hasMargin: false,
                      colorButton: isActive ? newBlack : newRedDark,
                      onPress: onTapFavoriteButton,
                    ),
                    SizedBox(height: heightRatio(size: 30, context: context)),
                    if (widget.recipe.assortments.length > 0)
                      Text(
                        'Продукты для этого рецепта',
                        style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context)),
                      ),
                    SizedBox(height: heightRatio(size: 16, context: context)),
                    if (widget.recipe.assortments.length > 0)
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: widget.recipe.assortments.length,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.45, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
                        itemBuilder: (context, index) {
                          return RecipeProductCard(assortmentsListModel: widget.recipe.assortments[index], isRecomendations: false);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
