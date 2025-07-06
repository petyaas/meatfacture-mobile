import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/recipes/models/receipts_list_model.dart';
import 'package:smart/features/recipes/recipes_screen.dart';
import 'package:smart/features/recipes/widgets/recipes_carousel_widget.dart';

class RecipesRecommended extends StatelessWidget {
  final ReceiptsListModel receiptsList;
  const RecipesRecommended({Key key, @required this.receiptsList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: widthRatio(size: 16, context: context)),
            Text(
              'Рекомендованные рецепты',
              style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack),
            ),
            Spacer(),
            InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecipesScreen(isPop: false))),
              child: Container(
                decoration: BoxDecoration(color: lightGreyColor, borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: widthRatio(size: 12, context: context),
                    right: widthRatio(size: 10, context: context),
                    top: heightRatio(size: 4, context: context),
                    bottom: heightRatio(size: 4, context: context),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Все',
                        style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newBlack),
                      ),
                      SizedBox(width: widthRatio(size: 7.54, context: context)),
                      RotationTransition(
                        turns: AlwaysStoppedAnimation(180 / 360),
                        child: SvgPicture.asset(
                          'assets/images/arrow_back.svg',
                          width: widthRatio(size: 4.31, context: context),
                          height: heightRatio(size: 7.54, context: context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: widthRatio(size: 16, context: context)),
          ],
        ),
        SizedBox(height: heightRatio(size: 20, context: context)),
        RecipesCarousel(receiptsList: receiptsList),
        SizedBox(height: heightRatio(size: 50, context: context)),
      ],
    );
  }
}
