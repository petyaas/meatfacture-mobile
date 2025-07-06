import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/recomedations_bloc.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_assortments_card2_widget.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class RecommendationListWidget extends StatefulWidget {
  final bool isHomePage;

  const RecommendationListWidget({this.isHomePage});

  @override
  State<RecommendationListWidget> createState() => _RecommendationListWidgetState();
}

class _RecommendationListWidgetState extends State<RecommendationListWidget> {
  final ScrollController scrollController = ScrollController();

  RecomendationsBloc recomBloc;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        recomBloc.add(RecomendationsNextPageEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecomendationsBloc(),
      child: BlocBuilder<RecomendationsBloc, RecomendationsState>(
        builder: (context, state) {
          recomBloc = BlocProvider.of(context);
          if (state is RecomendationsInitState) {
            recomBloc.add(RecomendationsLoadEvent());
          }
          if ((state is RecomendationsLoadingState && state.recomList.isEmpty) || state is RecomendationsEmptyState || state is RecomendationsErrorState) {
            return SizedBox();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.isHomePage == null
                  ? Padding(
                      padding: EdgeInsets.only(left: widthRatio(size: 18, context: context)),
                      child: Text("Рекомендованные товары", style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: newBlack)),
                    )
                  : SizedBox(),
              SizedBox(
                height: widget.isHomePage == null ? heightRatio(size: 160, context: context) : heightRatio(size: 140, context: context),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: scrollController,
                  child: Row(
                    children: [
                      ListView.builder(
                        padding: widget.isHomePage == null
                            ? EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context), vertical: heightRatio(size: 15, context: context))
                            : EdgeInsets.only(bottom: heightRatio(size: 10, context: context), top: heightRatio(size: 3, context: context)),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.recomList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Container(
                          padding: EdgeInsets.only(bottom: heightRatio(size: 5, context: context)),
                          width: (screenWidth(context) / 2) - widthRatio(size: 10, context: context),
                          child: RedesAssortmentsCard2Widget(
                            assortmentsListModel: state.recomList[index],
                            isRecomendations: true,
                          ),
                        ),
                      ),
                      if (state is RecomendationsLoadingState && state.recomList.isNotEmpty)
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(newRedDark),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
