import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants/source.dart';
import '../core/constants/text_styles.dart';
import '../features/basket/basket_screen.dart';
import '../features/basket/bloc/basket_list_bloc.dart';
import '../models/assortments_list_model.dart';
import '../services/services.dart';
import 'assortment_filter_button.dart';

class RecommendItem extends StatefulWidget {
  const RecommendItem({
    Key key,
    @required this.recomendation,
  }) : super(key: key);

  final AssortmentsListModel recomendation;

  @override
  State<RecommendItem> createState() => _RecomendationsItemState();
}

class _RecomendationsItemState extends State<RecommendItem> {

  ///Тут все как в обычном CatalogProductWidget только рекомендации
  @override
  Widget build(BuildContext context) => BlocBuilder<BasketListBloc, BasketState>(
        builder: (context, state) {
          if (state is BasketLoadedState && state.basketListModel.data.isNotEmpty) {
            widget.recomendation.quantityInClientCart =
                state.basketListModel.data.where((element) => element.assortment.uuid == widget.recomendation.uuid).length.toDouble();
          }

          return Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    heightRatio(size: 5, context: context),
                  ),
                  child: widget.recomendation.images.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget.recomendation.images[0].thumbnails.the1000X1000,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Image.asset("assets/images/notImage.png", fit: BoxFit.contain),
                          useOldImageOnUrlChange: true,
                        )
                      : Image.asset(
                          "assets/images/notImage.png",
                          fit: BoxFit.contain,
                        ),
                ),
              ),
              SizedBox(height: heightRatio(size: 4, context: context)),
              SizedBox(
                height: heightRatio(size: 27, context: context),
                child: Text(
                  widget.recomendation.name != null ? '${widget.recomendation.name}' : "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: appLabelTextStyle(
                    fontSize: heightRatio(size: 12, context: context),
                    color: newBlack,
                  ),
                ),
              ),
              SizedBox(height: heightRatio(size: 3, context: context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  widget.recomendation.assortmentUnitId == "kilogram"
                      ? Text(
                          '${(widget.recomendation.weight.toDouble() % 1000 == 0) ? (widget.recomendation.weight.toDouble() ~/ 1000) : (widget.recomendation.weight.toDouble() / 1000).toStringAsFixed(1)} кг',
                          style: appHeadersTextStyle(
                            fontSize: heightRatio(size: 10, context: context),
                            color: grey6D6D6D,
                          ),
                        )
                      : Text(
                          '${(widget.recomendation.weight == "0" ? 1 : widget.recomendation.weight)} ${getAssortmentUnitId(assortmentUnitId: widget.recomendation.assortmentUnitId)[1]}',
                          style: appHeadersTextStyle(
                            fontSize: heightRatio(size: 10, context: context),
                            color: grey6D6D6D,
                          ),
                        ),
                  Text(
                    widget.recomendation.priceWithDiscount == null
                        ? '${(double.parse(widget.recomendation.currentPrice) % 1 == 0 ? double.parse(widget.recomendation.currentPrice).toStringAsFixed(0) : double.parse(widget.recomendation.currentPrice).toStringAsFixed(2))} руб/кг'
                        : '${(widget.recomendation.priceWithDiscount % 1 == 0 ? widget.recomendation.priceWithDiscount.toStringAsFixed(0) : widget.recomendation.priceWithDiscount.toStringAsFixed(2))} руб/кг',
                    style: appHeadersTextStyle(
                      fontSize: heightRatio(size: 10, context: context),
                      color: grey6D6D6D,
                    ),
                  ),
                ],
              ),
              SizedBox(height: heightRatio(size: 10, context: context)),
              Material(
                color: mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    heightRatio(size: 7, context: context),
                  ),
                ),
                child: RecomendButton,
              ),
            ],
          );
        },
      );

  Widget get RecomendButton => widget.recomendation.quantityInClientCart == null ||
          widget.recomendation.quantityInClientCart <= 0 ||
          !widget.recomendation.isbasketAdding
      ? SizedBox(
          width: double.infinity,
          child: InkWell(
            onTap: () async {
              setState(() => widget.recomendation.isbasketAdding = true);

              if (await loadToken() != "guest") {
                if (widget.recomendation.assortmentUnitId != "kilogram") {
                  if (widget.recomendation.quantityInClientCart < widget.recomendation.productsQuantity) {
                    widget.recomendation.quantityInClientCart++;
                    if (await BasketProvider().updateProductInBasket(
                        productUuid: widget.recomendation.uuid,
                        quantity: widget.recomendation.assortmentUnitId != "kilogram"
                            ? widget.recomendation.quantityInClientCart
                            : widget.recomendation.quantityInClientCart)) {
                      context.read<BasketListBloc>().add(BasketLoadEvent());
                    }
                  }
                } else {
                  double weight = double.tryParse(widget.recomendation.weight) ?? 0.0;
                  double weightInKg = weight / 1000;
                  if (widget.recomendation.quantityInClientCart < widget.recomendation.productsQuantity) {
                    setState(() {
                      widget.recomendation.quantityInClientCart += weightInKg;
                    });
                    if (await BasketProvider().updateProductInBasket(
                        productUuid: widget.recomendation.uuid, quantity: widget.recomendation.quantityInClientCart)) {
                      context.read<BasketListBloc>().add(BasketLoadEvent());
                    }
                  }
                }
              } else {
                AssortmentFilterButton().loginOrRegWarning(context);
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: heightRatio(size: 8, context: context),
              ),
              child: Text(
                "add".tr(),
                textAlign: TextAlign.center,
                style: appHeadersTextStyle(
                  color: whiteColor,
                  fontSize: heightRatio(size: 12, context: context),
                ),
              ),
            ),
          ),
        )
      : SizedBox(
          width: double.infinity,
          child: InkWell(
            onTap: ()                      => Navigator.push(
              context,
              CupertinoPageRoute(
                title: "Recommend",
                builder: (context) => BasketScreen(),
              ),
            ),

            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: heightRatio(size: 8, context: context),
              ),
              child: Text(
                "inBasket".tr(),
                textAlign: TextAlign.center,
                style: appHeadersTextStyle(
                  color: whiteColor,
                  fontSize: heightRatio(size: 12, context: context),
                ),
              ),
            ),
          ),
        );
}
