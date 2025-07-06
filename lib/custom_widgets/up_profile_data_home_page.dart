import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/bloc_files/credit_cards_bloc.dart';
import 'package:smart/bloc_files/loyalty_cards_list_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_bloc.dart';
import 'package:smart/features/addresses/addresses_shop/bloc/addresses_shop_event.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/custom_widgets/notification_list_widget.dart';
import 'package:smart/pages/secondary_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class UpProfileDataHome extends StatelessWidget {
  const UpProfileDataHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoyaltyCardsListBloc _loyaltyCardsListBloc = BlocProvider.of<LoyaltyCardsListBloc>(context);
    CreditCardsListBloc _cardsListBloc = BlocProvider.of<CreditCardsListBloc>(context);
    SecondaryPageBloc _secondaryPageBloc = BlocProvider.of<SecondaryPageBloc>(context);
    AddressesShopBloc _addressesShopBloc = BlocProvider.of<AddressesShopBloc>(context);

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadedState) {
          _addressesShopBloc.add(SelectAddressShopEvent(
            shopUuid: state.profileModel.data.selectedStoreUserUuid,
          ));
        }
        return SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _loyaltyCardsListBloc.add(LoyaltyCardsListLoadEvent());
                      _cardsListBloc.add(CreditCardsListLoadEvent());
                      _secondaryPageBloc.add(ProfilePageEvent());
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Text(
                        state is ProfileLoadedState
                            ? state.profileModel.data.filledProfileBonusesAdded != false
                                ? state.profileModel.data.name != null
                                    ? state.profileModel.data.name
                                    : 'Заполните профиль'
                                : 'Заполните профиль'
                            : '',
                        style: appHeadersTextStyle(fontSize: heightRatio(size: 22, context: context), fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _loyaltyCardsListBloc.add(LoyaltyCardsListLoadEvent());
                        _cardsListBloc.add(CreditCardsListLoadEvent());
                        _secondaryPageBloc.add(ProfilePageEvent());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: white03),
                        child: SvgPicture.asset('assets/images/newProfile.svg', height: 20, width: 20),
                      ),
                    ),
                    SizedBox(width: widthRatio(size: 10, context: context)),
                    InkWell(
                      onTap: () {
                        _secondaryPageBloc.add(NotificationPageLoadEvent());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SecondaryPage(upText: 'Уведомления', contentWidget: NotificationListWidget());
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 36,
                        width: 36,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: white03),
                        child: SvgPicture.asset('assets/images/newBellIcon.svg'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
