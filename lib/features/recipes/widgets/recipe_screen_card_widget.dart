import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/bloc_files/Basic_page_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/custom_widgets/reg_or_login_warning_bottomSheet.dart';
import 'package:smart/features/recipes/models/receipts_list_model.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/recipes/recipes_detail_screen.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/theme/app_alert.dart';

class RecipesScreenCardWidget extends StatefulWidget {
  final Datum recipe;
  final Function(String uuid, bool isFavorite) onFavoriteChanged;
  const RecipesScreenCardWidget({this.recipe, this.onFavoriteChanged});

  @override
  State<RecipesScreenCardWidget> createState() => _RecipesScreenCardWidgetState();
}

class _RecipesScreenCardWidgetState extends State<RecipesScreenCardWidget> {
  bool isActive;

  @override
  void initState() {
    isActive = widget.recipe.isFavorite;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RecipesScreenCardWidget oldWidget) {
    isActive = widget.recipe.isFavorite;
    super.didUpdateWidget(oldWidget);
  }

  Future<String> loadToken() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    return _shared.getString(SharedKeys.token);
  }

  void loginOrRegWarning(BuildContext context) {
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
          return RegOrLoginWarningBottomSheet();
        }).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeDetailScreen(recipe: widget.recipe))) as bool;
        if (result != null) {
          isActive = result;
          setState(() {});
        }
      },
      child: SizedBox(
        width: widthRatio(size: 161, context: context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: widthRatio(size: 161, context: context),
              height: heightRatio(size: 104, context: context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(heightRatio(size: 7, context: context)),
                image: DecorationImage(
                  image: NetworkImage(widget.recipe.filePath != null ? widget.recipe.filePath : ''),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  widget.recipe.duration != null
                      ? Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: widthRatio(size: 55, context: context),
                            height: heightRatio(size: 18, context: context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(2), topRight: Radius.zero, bottomRight: Radius.circular(5), bottomLeft: Radius.circular(2)),
                              color: newRedDark,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${widget.recipe.duration} мин',
                              style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 10, context: context)),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  Positioned(
                    top: heightRatio(size: 8, context: context),
                    right: widthRatio(size: 8, context: context),
                    child: InkWell(
                      onTap: () async {
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
                          var _likeResponse =
                              await AddOrDeleteReceiptsToFavoriteProvider(isFavorite: !widget.recipe.isFavorite, mealReceiptUuid: widget.recipe.uuid)
                                  .addOrDeleteReceiptsToFavoriteResponse();
                          if (_likeResponse == "old token") {
                            AuthPageBloc authPageBloc = BlocProvider.of(context);
                            BlocProvider.of<BasicPageBloc>(context)?.add(ProfilePage.logout(regBloc: authPageBloc, basicPageBloc: BlocProvider.of(context)));
                          }

                          if (widget.onFavoriteChanged != null) {
                            widget.onFavoriteChanged(widget.recipe.uuid, isActive);
                          }
                        } else {
                          loginOrRegWarning(context);
                        }
                      },
                      child: SvgPicture.asset(isActive ? 'assets/images/newHeartRLactive.svg' : 'assets/images/newHeartRL.svg'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: heightRatio(size: 8, context: context)),
            Flexible(
              child: Text(
                widget.recipe.name != null ? widget.recipe.name : '',
                style: appLabelTextStyle(color: newBlack, fontSize: 12),
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
