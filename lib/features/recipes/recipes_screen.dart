import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:pagination_view/pagination_view.dart";
import "package:smart/core/constants/source.dart";
import "package:smart/core/constants/text_styles.dart";
import 'package:smart/features/catalog/catalog_screen.dart';
import "package:smart/features/recipes/blocs/receipts_bloc/receipts_bloc.dart";
import 'package:smart/features/recipes/models/receipts_list_model.dart';
import "package:smart/features/recipes/recipes_favorites_screen.dart";
import "package:smart/features/recipes/recipes_search_screen.dart";
import 'package:smart/features/recipes/widgets/recipe_screen_card_widget.dart';
import "package:smart/features/recipes/widgets/recipe_category_item.dart";

class RecipesScreen extends StatefulWidget {
  final bool isPop;
  final Function(String recipeUuid, bool isFavorite) onRecipeUpdated;
  const RecipesScreen({key, Key, this.onRecipeUpdated, this.isPop = true});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  String selectedSection;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptsBloc, ReceiptsState>(
      builder: (context, state) {
        if (state is ReceiptsLoadedState) {
          List<Datum> filterRecipes() {
            if (selectedSection == null) {
              return state.receiptsList.data;
            } else {
              return state.receiptsList.data.where((recipe) => recipe.section == selectedSection).toList();
            }
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
                      SizedBox(
                        width: widthRatio(size: 84, context: context),
                        child: InkWell(
                          onTap: () {
                            widget.isPop
                                ? Navigator.pop(context)
                                : Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                    builder: (context) {
                                      return CatalogScreen(
                                        catalogNavKey: GlobalKey<NavigatorState>(),
                                        paginationViewkey: GlobalKey<PaginationViewState>(),
                                      );
                                    },
                                  ), (route) => false);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, right: 40),
                            child: Icon(Icons.arrow_back_ios_new_rounded, size: heightRatio(size: 25, context: context), color: whiteColor),
                          ),
                        ),
                      ),
                      Text(
                        "Рецепты",
                        style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
                        textAlign: TextAlign.left,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecipesSearchScreen())),
                            child: Container(
                              width: widthRatio(size: 36, context: context),
                              height: heightRatio(size: 36, context: context),
                              padding: EdgeInsets.all(widthRatio(size: 8, context: context)),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: white03),
                              child: SvgPicture.asset(
                                'assets/images/searchIcon.svg',
                                height: heightRatio(size: 20, context: context),
                                color: whiteColor,
                                width: widthRatio(size: 20, context: context),
                              ),
                            ),
                          ),
                          SizedBox(width: widthRatio(size: 8, context: context)),
                          InkWell(
                            onTap: () async {
                              final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => RecipesFavoritesScreen())) as List<Datum>;
                              if (result != null) {
                                state.receiptsList.data = List.from(result);
                                setState(() {});
                              }
                            },
                            child: Container(
                              width: widthRatio(size: 36, context: context),
                              height: heightRatio(size: 36, context: context),
                              padding: EdgeInsets.all(widthRatio(size: 8, context: context)),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: white03),
                              child: SvgPicture.asset(
                                'assets/images/newHeartContur.svg',
                                height: heightRatio(size: 20, context: context),
                                color: whiteColor,
                                width: widthRatio(size: 20, context: context),
                              ),
                            ),
                          ),
                          SizedBox(width: widthRatio(size: 17, context: context)),
                        ],
                      ),
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
                          state.sectionsList.data.isNotEmpty
                              ? SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 10, context: context), vertical: heightRatio(size: 20, context: context)),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      RecipeCategoryItem(
                                          title: 'Все',
                                          isActive: selectedSection == null,
                                          onTap: (section) {
                                            setState(() {
                                              selectedSection = null;
                                            });
                                          }),
                                      ...state.sectionsList.data
                                          .map<Widget>(
                                            (e) => RecipeCategoryItem(
                                              title: e.section,
                                              isActive: e.section == selectedSection,
                                              onTap: (section) {
                                                setState(() {
                                                  selectedSection = e.section;
                                                });
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink(),
                          Expanded(
                            child: GridView.builder(
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
                                );
                              },
                            ),
                          ),
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
