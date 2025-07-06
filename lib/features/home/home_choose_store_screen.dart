import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_event.dart';
import 'package:smart/features/basket/bloc/basket_list_bloc.dart';
import 'package:smart/features/home/widgets/home_choose_store_filter_button.dart';
import 'package:smart/features/home/widgets/home_choose_store_map.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

// TODO просто ознакомиться
class HomeChooseStoreScreen extends StatelessWidget {
  final TextEditingController shopsSearchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: newRedDark,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: heightRatio(size: 10, context: context)),
              Row(
                children: [
                  SizedBox(width: widthRatio(size: 16, context: context)),
                  InkWell(
                    onTap: () {
                      context.read<AddressesShopBloc>().add(EmptyAddressesShopEvent());
                      context.read<BasketListBloc>().add(BasketLoadEvent());
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios_new_rounded, size: heightRatio(size: 22, context: context), color: Colors.white),
                  ),
                  SizedBox(width: widthRatio(size: 15, context: context)),
                  Text(
                    'Выбор магазина',
                    style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
                  ),
                  Spacer(),
                  HomeChooseStoreFilterButton(),
                  SizedBox(width: widthRatio(size: 16, context: context)),
                ],
              ),
              SizedBox(height: heightRatio(size: 14, context: context)),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                    topRight: Radius.circular(heightRatio(size: 15, context: context)),
                  ),
                  child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: HomeChooseStoreMap(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
