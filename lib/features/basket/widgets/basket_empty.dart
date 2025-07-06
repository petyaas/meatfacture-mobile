import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/features/catalog/subcatalog_screen.dart';
import 'package:smart/main.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class BasketEmpty extends StatelessWidget {
  final BoxDecoration Function(BuildContext) decorationForContent;

  const BasketEmpty({Key key, @required this.decorationForContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: decorationForContent(context),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/newEmptyBasket.svg',
              width: widthRatio(size: 131, context: context),
              height: heightRatio(size: 131, context: context),
            ),
            SizedBox(height: heightRatio(size: 22, context: context)),
            Text('В корзине нет товаров', textAlign: TextAlign.center, style: appLabelTextStyle(fontSize: heightRatio(size: 18, context: context), color: newBlack, fontWeight: FontWeight.w400)),
            SizedBox(height: heightRatio(size: 25, context: context)),
            InkWell(
              onTap: () {
                BlocProvider.of<SecondaryPageBloc>(context).add(CatalogEvent());
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                margin: const EdgeInsets.only(right: 20, left: 20),
                width: widthRatio(size: 205, context: context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: newRedDark,
                ),
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
                    builder: (context) => SubcatalogScreen(
                      isSearchPage: false,
                      isFavorite: true,
                    ),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                margin: const EdgeInsets.only(right: 20, left: 20),
                width: widthRatio(size: 205, context: context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: newBlack,
                ),
                child: Text(
                  'Перейти в избранное',
                  style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 16, context: context)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
