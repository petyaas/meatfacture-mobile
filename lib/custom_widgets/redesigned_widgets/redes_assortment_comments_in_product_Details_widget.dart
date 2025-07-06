// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart/bloc_files/assortment_comments_bloc.dart';
import 'package:smart/bloc_files/shopping_history_bloc.dart';
import 'package:smart/pages/shopping_history_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class RedesAssortmentCommentsInProductDetailsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssortmentCommentsBloc _assortmentCommentsBloc = BlocProvider.of(context);
    return BlocBuilder<AssortmentCommentsBloc, AssortmentCommentsState>(
      builder: (context, state) {
        if (state is AssortmentCommentsErrorState) {
          return Center(
            child: Text("errorText".tr()),
          );
        }
        if (state is AssortmentCommentsEmtyState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Отзывы: 0", style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context))),
              SizedBox(height: heightRatio(size: 15, context: context)),
              Container(
                padding: EdgeInsets.only(bottom: heightRatio(size: 50, context: context)),
                height: heightRatio(size: 100, context: context),
                alignment: Alignment.center,
                child: Text(
                  "NoReviews".tr(),
                  style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newGrey),
                ),
              ),
            ],
          );
        }
        if ((state is AssortmentCommentsLoadingState || state is AssortmentCommentsInitState) &&
            (state.assortmentCommentsModel == null || state.assortmentCommentsModel.data.isEmpty)) {
          return Container(
            height: heightRatio(size: 50, context: context),
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Отзывы: ${state.assortmentCommentsModel.data.length}", style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context))),
            SizedBox(height: heightRatio(size: 8, context: context)),
            ListView.builder(
                padding: EdgeInsets.only(top: heightRatio(size: 10, context: context)),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: state.assortmentCommentsModel.data.length,
                itemBuilder: (context, index) {
                  // DateTime _createAt = DateTime.parse(state.assortmentCommentsModel.data[index].createdAt);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (state.assortmentCommentsModel.data[index].clientName != null)
                                Text(
                                  state.assortmentCommentsModel.data[index].clientName,
                                  style: appTextStyle(fontSize: heightRatio(size: 16, context: context), fontWeight: FontWeight.w600),
                                ),
                              if (state.assortmentCommentsModel.data[index].clientName != null) SizedBox(height: heightRatio(size: 10, context: context)),
                              //Comment
                              Text(
                                state.assortmentCommentsModel.data[index].comment ?? "",
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                                style: appTextStyle(fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w400, color: newGrey),
                              ),
                            ],
                          ),
                          //rating
                          Row(
                            children: [
                              SvgPicture.asset(
                                state.assortmentCommentsModel.data[index].value > 0 ? 'assets/images/activeStar.svg' : 'assets/images/star.svg',
                                width: widthRatio(size: 18, context: context),
                                height: heightRatio(size: 18, context: context),
                              ),
                              SizedBox(width: widthRatio(size: 5, context: context)),
                              SvgPicture.asset(
                                state.assortmentCommentsModel.data[index].value > 1 ? 'assets/images/activeStar.svg' : 'assets/images/star.svg',
                                width: widthRatio(size: 18, context: context),
                                height: heightRatio(size: 18, context: context),
                              ),
                              SizedBox(width: widthRatio(size: 5, context: context)),
                              SvgPicture.asset(
                                state.assortmentCommentsModel.data[index].value > 2 ? 'assets/images/activeStar.svg' : 'assets/images/star.svg',
                                width: widthRatio(size: 18, context: context),
                                height: heightRatio(size: 18, context: context),
                              ),
                              SizedBox(width: widthRatio(size: 5, context: context)),
                              SvgPicture.asset(
                                state.assortmentCommentsModel.data[index].value > 3 ? 'assets/images/activeStar.svg' : 'assets/images/star.svg',
                                width: widthRatio(size: 18, context: context),
                                height: heightRatio(size: 18, context: context),
                              ),
                              SizedBox(width: widthRatio(size: 5, context: context)),
                              SvgPicture.asset(
                                state.assortmentCommentsModel.data[index].value > 4 ? 'assets/images/activeStar.svg' : 'assets/images/star.svg',
                                width: widthRatio(size: 18, context: context),
                                height: heightRatio(size: 18, context: context),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: heightRatio(size: 10, context: context)),
                      Divider(),
                      SizedBox(height: heightRatio(size: 10, context: context)),
                    ],
                  );
                }),
            if (state is AssortmentCommentsLoadingState && state.assortmentCommentsModel.data.isNotEmpty)
              Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    BlocProvider.of<ShoppingHistoryBloc>(context).add(ShoppingHistoryCheckListEvent());
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ShoppingHistoryPage(
                          hasBack: true,
                          historyNavKey: null,
                          outContext: context,
                        );
                      },
                    ));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        size: heightRatio(size: 25, context: context),
                        color: mainColor,
                      ),
                      Container(
                        color: Colors.transparent,
                        child: Text(
                          "Оценить в своих покупках",
                          style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor),
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.assortmentCommentsModel.data.length > 5)
                  InkWell(
                    onTap: () {
                      _assortmentCommentsBloc.add(AssortmentCommentsShowMoreEvent());
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Text(
                        'Показать еще',
                        style: appTextStyle(fontSize: heightRatio(size: 14, context: context), color: mainColor),
                      ),
                    ),
                  )
              ],
            ),
            SizedBox(height: 80),
          ],
        );
      },
    );
  }
}
