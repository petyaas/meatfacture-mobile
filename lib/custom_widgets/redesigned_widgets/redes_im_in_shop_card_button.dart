import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/basic_page_bloc.dart';
import 'package:smart/bloc_files/im_in_shop_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_im_in_shop_assortments_list_widget.dart';
import 'package:smart/main.dart';
import 'package:smart/features/profile/profile_page.dart';
import 'package:smart/pages/redesigned_pages/redes_im_in_shop_before_page.dart';
import 'package:smart/pages/redesigned_pages/redes_im_in_shop_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class RedesImInShopCArdButton extends StatefulWidget {
  const RedesImInShopCArdButton({Key key}) : super(key: key);

  @override
  State<RedesImInShopCArdButton> createState() => _RedesImInShopCArdButtonState();
}

class _RedesImInShopCArdButtonState extends State<RedesImInShopCArdButton> {
  @override
  void initState() {
    super.initState();
  }

  // я в магазине
  @override
  Widget build(BuildContext context) {
    BasicPageBloc basicPageBloc = BlocProvider.of(context);
    AuthPageBloc authPageBloc = BlocProvider.of(context);
    return BlocConsumer<ImInShopBloc, ImInShopState>(listener: (context, state) {
      if (state is ImInShopOldTokenState) {
        ProfilePage.logout(regBloc: authPageBloc, basicPageBloc: basicPageBloc);
      }
    }, builder: (context, state) {
      // ignore: close_sinks
      ImInShopBloc _imInShopBloc = BlocProvider.of<ImInShopBloc>(context);
      return InkWell(
        onTap: () async {
          _imInShopBloc.add(ImInShopLoadEvent());
          String isChoosenAddressesForThisSessionIamInShop = await prefs.getString(SharedKeys.isChoosenAddressesForThisSessionIamInShop);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => isChoosenAddressesForThisSessionIamInShop == 'yes' ? RedesImInShopPage() : RedesImInShopBeforePage()),
          );
        },
        child: Container(
          padding: EdgeInsets.all(widthRatio(size: 10, context: context)),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)),
            boxShadow: [BoxShadow(color: newShadow, offset: Offset(12, 12), blurRadius: 24, spreadRadius: 0)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)), color: newIconBg),
                          child: Image.asset("assets/images/newPoint.png", height: heightRatio(size: 38, context: context), width: widthRatio(size: 38, context: context), fit: BoxFit.scaleDown),
                        ),
                        SizedBox(width: widthRatio(size: 15, context: context)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "iAmInStoreText".tr(),
                                style: appHeadersTextStyle(fontSize: heightRatio(size: 15, context: context), fontWeight: FontWeight.w700, color: newBlack),
                              ),
                              SizedBox(height: heightRatio(size: 5, context: context)),
                              Text(
                                "chooseStoreForImInShopText".tr(),
                                style: appLabelTextStyle(fontSize: heightRatio(size: 13, context: context), fontWeight: FontWeight.w400, color: newBlackLight),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: widthRatio(size: 10, context: context)),
                  Icon(Icons.arrow_forward_ios_rounded, color: newRedDark, size: heightRatio(size: 23, context: context)),
                ],
              ),
              prefs.getString(SharedKeys.isChoosenAddressesForThisSessionIamInShop) == 'yes' ? RedesImInShopAssortmentsListWidget() : SizedBox() //я в магазине
            ],
          ),
        ),
      );
    });
  }
}
