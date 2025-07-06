import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/recipes/blocs/receipts_bloc/receipts_bloc.dart';
import 'package:smart/features/recipes/models/receipts_list_model.dart';
import 'package:smart/features/recipes/widgets/recipe_screen_card_widget.dart';

class RecipesSearchScreen extends StatefulWidget {
  const RecipesSearchScreen({key, Key});

  @override
  State<RecipesSearchScreen> createState() => _RecipesSearchScreenState();
}

class _RecipesSearchScreenState extends State<RecipesSearchScreen> {
  String _searchQuery = '';
  List<Datum> _searchResults = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptsBloc, ReceiptsState>(
      builder: (context, state) {
        if (state is ReceiptsLoadedState) {
          _searchResults = _searchRecipes(state.receiptsList.data, _searchQuery);

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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: widthRatio(size: 16, context: context)),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: heightRatio(size: 25, context: context),
                            color: whiteColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: white04,
                            borderRadius: BorderRadius.circular(heightRatio(size: 50, context: context)),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() => _searchQuery = value);
                            },
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _searchQuery = '';
                                      _searchController.clear(); // Очистка TextField
                                    });
                                  },
                                  child: Icon(Icons.close, color: white04),
                                ),
                                prefixIconConstraints: BoxConstraints(maxHeight: heightRatio(size: 20, context: context)),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(right: widthRatio(size: 10, context: context), left: widthRatio(size: 14, context: context)),
                                  child: SvgPicture.asset(
                                    'assets/images/searchIcon.svg',
                                    width: widthRatio(size: 19, context: context),
                                    color: white08,
                                    height: heightRatio(size: 19, context: context),
                                  ),
                                ),
                                border: InputBorder.none,
                                hintText: 'Найти рецепт',
                                hintStyle: appLabelTextStyle(color: white04, fontSize: heightRatio(size: 18, context: context)),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                errorBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.only(top: heightRatio(size: 14, context: context))),
                            style: appLabelTextStyle(
                              color: Colors.white,
                              fontSize: heightRatio(size: 18, context: context),
                              decoration: TextDecoration.none,
                              decorationColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: widthRatio(size: 16, context: context)),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: heightRatio(size: 19, context: context)),
                          Expanded(
                            child: _searchResults.isNotEmpty
                                ? GridView.builder(
                                    padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1.15,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 11,
                                    ),
                                    itemCount: _searchResults.length,
                                    itemBuilder: (context, index) {
                                      Datum product = _searchResults[index];
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
                                      _searchController.text.isEmpty ? '' : 'По данному запросу\nрецептов не найдено',
                                      style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), height: 1.5),
                                      textAlign: TextAlign.center,
                                    ),
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

  List<Datum> _searchRecipes(List<Datum> recipes, String query) {
    if (query.isEmpty) {
      return [];
    }

    return recipes.where((recipe) => recipe.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
