import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:smart/bloc_files/recomedations_bloc.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/models/assortments_list_model.dart';
import '../core/constants/source.dart';

import '../custom_widgets/recommend_item.dart';

class RecomendationsPage extends StatelessWidget {
  const RecomendationsPage({Key key}) : super(key: key);

  ///Используем готовый RecomendationsBloc для списка рекомендаций
  @override
  Widget build(BuildContext context) => BlocProvider<RecomendationsBloc>(
        create: (context) => RecomendationsBloc()
          ..add(
            RecomendationsLoadEvent(),
          ),
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: mainGradient),
            child: Column(
              children: [
                ///app bar похожый на стандартный
                RecommendBar(),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                          heightRatio(size: 15, context: context),
                        ),
                      ),
                    ),
                    child: BlocBuilder<RecomendationsBloc, RecomendationsState>(
                      builder: RecommendGridBuilder,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  ///Лист рекомендации
  Widget RecommendGridBuilder(BuildContext context, RecomendationsState state) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double childAspectRatio = screenWidth <= 385
        ? screenWidth <= 34
            ? 0.80
            : 0.70
        : 0.60;

    if (state is RecomendationsInitState || state is RecomendationsLoadingState) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state is RecomendationsErrorState) {
      return const ErrorRecommend();
    }
    if (state.recomList.isEmpty) {
      return const EmptyRecommend();
    }
    return GridView.count(
      // controller: controller,
      childAspectRatio: childAspectRatio,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(16),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      crossAxisCount: 2,
      children: state.recomList
          .map(
            (AssortmentsListModel assortment) => RecommendItem(recomendation: assortment),
          )
          .toList(),
    );
  }
}

class RecommendBar extends StatelessWidget {
  const RecommendBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.only(
                left: widthRatio(size: 2, context: context),
                right: widthRatio(size: 5, context: context),
              ),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: heightRatio(size: 22, context: context),
                color: whiteColor,
              ),
            ),
            SizedBox(width: widthRatio(size: 8, context: context)),
            Expanded(
              child: Text(
                "addOrder".tr(),
                style: appLabelTextStyle(
                  color: Colors.white,
                  fontSize: heightRatio(size: 22, context: context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorRecommend extends StatelessWidget {
  const ErrorRecommend({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(
            widthRatio(size: 15, context: context),
          ),
          decoration: const BoxDecoration(
            color: colorBlack03,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            'assets/images/netErrorIcon.svg',
            color: Colors.white,
            height: heightRatio(
              size: 30,
              context: context,
            ),
          ),
        ),
        SizedBox(
          height: heightRatio(size: 15, context: context),
        ),
        Text(
          "errorText".tr(),
          style: appTextStyle(
            fontSize: heightRatio(size: 18, context: context),
            color: colorBlack06,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: heightRatio(size: 10, context: context),
        ),
      ],
    );
  }
}

class EmptyRecommend extends StatelessWidget {
  const EmptyRecommend({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(
            widthRatio(size: 15, context: context),
          ),
          decoration: BoxDecoration(
            color: colorBlack03,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            'assets/images/closeCircleIcon.svg',
            color: Colors.white,
            height: heightRatio(
              size: 30,
              context: context,
            ),
          ),
        ),
        SizedBox(
          height: heightRatio(size: 15, context: context),
        ),
        Text(
          "thereIsNothing".tr(),
          style: appTextStyle(
            fontSize: heightRatio(size: 18, context: context),
            color: colorBlack06,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: heightRatio(size: 10, context: context),
        ),
      ],
    );
  }
}
