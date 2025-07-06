import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:smart/core/constants/source.dart";
import "package:smart/core/constants/text_styles.dart";
import "package:smart/features/recipes/blocs/receipts_bloc/receipts_bloc.dart";
import 'package:smart/features/recipes/models/receipts_list_model.dart';
import 'package:smart/features/recipes/widgets/recipe_screen_card_widget.dart';
import "package:smart/features/recipes/widgets/recipes_recommended.dart";

class RecipesFavoritesScreen extends StatefulWidget {
  const RecipesFavoritesScreen({key, Key});

  @override
  State<RecipesFavoritesScreen> createState() => _RecipesFavoritesScreenState();
}

class _RecipesFavoritesScreenState extends State<RecipesFavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptsBloc, ReceiptsState>(
      builder: (context, state) {
        if (state is ReceiptsLoadedState) {
          List<Datum> filterRecipes() {
            return state.receiptsList.data.where((recipe) => recipe.isFavorite == true).toList();
          }

          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: newRedDark,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: heightRatio(size: 10, context: context)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          Navigator.of(context).pop(state.receiptsList.data);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14, right: 16),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: heightRatio(size: 25, context: context),
                            color: whiteColor,
                          ),
                        ),
                      ),
                      Text(
                        "Сохраненные рецепты",
                        style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(width: widthRatio(size: 60, context: context)),
                    ],
                  ),
                  SizedBox(height: heightRatio(size: 12, context: context)),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: heightRatio(size: 17, context: context)),
                          Expanded(
                            child: filterRecipes().length > 0
                                ? GridView.builder(
                                    padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1.15,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 11,
                                    ),
                                    itemCount: filterRecipes().length,
                                    itemBuilder: (context, index) {
                                      Datum product = filterRecipes()[index];
                                      return RecipesScreenCardWidget(
                                        recipe: product,
                                        onFavoriteChanged: (uuid, isFavorite) {
                                          state.receiptsList.data.singleWhere((e) => e.uuid == uuid).isFavorite == isFavorite;
                                          setState(() {});
                                        },
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      'У вас еще нет сохраненных рецептов',
                                      style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context)),
                                    ),
                                  ),
                          ),
                          RecipesRecommended(receiptsList: state.receiptsList),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
