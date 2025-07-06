import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:smart/features/recipes/recipe_story_screen.dart';
import 'models/receipts_list_model.dart' as receiptsListModel;

class RecipeStoriesScreen extends StatefulWidget {
  const RecipeStoriesScreen({@required this.recipe});

  final receiptsListModel.Datum recipe;

  @override
  State<RecipeStoriesScreen> createState() => _RecipeStoriesScreenState();
}

class _RecipeStoriesScreenState extends State<RecipeStoriesScreen> {
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: ExpandablePageView.builder(
                padEnds: false,
                controller: _pageController,
                itemCount: widget.recipe.tabs.length,
                itemBuilder: (context, index) => RecipeStoryScreen(
                  title: widget.recipe.tabs[index].title,
                  text: widget.recipe.tabs[index].text,
                  image: widget.recipe.tabs[index].filePath,
                  duration: widget.recipe.tabs[index].duration,
                  textColor: widget.recipe.tabs[index].textColor,
                ),
              ),
            ),
            // Container(
            //   child: BlocBuilder<ReceiptsFavoriteBloc, ReceiptsFavoriteState>(
            //     builder: (context, state) {
            //       if (state is ReceiptsFavoriteLoadingState) {
            //         return Container(
            //           width: widthRatio(size: 39.0, context: context),
            //           height: heightRatio(size: 39.0, context: context),
            //           child: CircularProgressIndicator(
            //             valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
            //           ),
            //         );
            //       }
            //       if (state is ReceiptsFavoriteLoadedState && state.singleRecipe.data.uuid == widget.recipe.uuid) {
            //         widget.recipe.clientLikeValue = state.singleRecipe.data.clientLikeValue;
            //         return InkWell(
            //           onTap: () {
            //             _receiptsBloc.add(ReactReceiptsEvent(state.singleRecipe.data.uuid, state.singleRecipe.data.clientLikeValue != null ? !state.singleRecipe.data.clientLikeValue : true));
            //             print(_receiptsBloc.state);
            //           },
            //           child: Container(
            //             child: SvgPicture.asset(
            //               state.singleRecipe.data.clientLikeValue == false || state.singleRecipe.data.clientLikeValue == null ? 'assets/images/heart_for_recipes_false.svg' : 'assets/images/heart_for_recipes_true.svg',
            //             ),
            //           ),
            //         );
            //       }
            //       if (state is ReceiptsFavoriteErrorState) {
            //         return InkWell(
            //             onTap: () {
            //               _receiptsBloc.add(ReactReceiptsEvent(widget.recipe.uuid, widget.recipe.clientLikeValue != null ? !widget.recipe.clientLikeValue : true));
            //               print(_receiptsBloc.state);
            //             },
            //             child: Container(
            //               child: SvgPicture.asset(
            //                 widget.recipe.clientLikeValue == false || widget.recipe.clientLikeValue == null ? 'assets/images/heart_for_recipes_false.svg' : 'assets/images/heart_for_recipes_true.svg',
            //               ),
            //             ));
            //       } else {
            //         return InkWell(
            //           onTap: () {
            //             _receiptsBloc.add(ReactReceiptsEvent(widget.recipe.uuid, widget.recipe.clientLikeValue != null ? !widget.recipe.clientLikeValue : true));
            //             print(_receiptsBloc.state);
            //           },
            //           child: Container(
            //             child: SvgPicture.asset(
            //               widget.recipe.clientLikeValue == false || widget.recipe.clientLikeValue == null ? 'assets/images/heart_for_recipes_false.svg' : 'assets/images/heart_for_recipes_true.svg',
            //             ),
            //           ),
            //         );
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
