import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart/features/addresses/addresses_delivery/bloc/addresses_client_bloc.dart';
import 'package:smart/bloc_files/geocoding_bloc.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/main.dart';
import 'package:smart/pages/init_add_user_address.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class ClientAddressListForProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Geocodingbloc _geocodingbloc = BlocProvider.of(context);
    AddressesClientBloc _clientAddressBloc = BlocProvider.of<AddressesClientBloc>(context);
    return BlocBuilder<AddressesClientBloc, ClientAddressState>(
      builder: (context, state) {
        if (state is LoadedClientAddressState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Адрес доставки', style: appHeadersTextStyle(color: newBlack212121, fontSize: 14)),
              SizedBox(height: heightRatio(size: 20, context: context)),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    String addressText = (state.clientAddressModelList[index].house == null || state.clientAddressModelList[index].house == "")
                        ? "${state.clientAddressModelList[index].city}, ${state.clientAddressModelList[index].street}"
                        : "${state.clientAddressModelList[index].city}, ${state.clientAddressModelList[index].street} ${state.clientAddressModelList[index].house}";

                    if (state.clientAddressModelList[index].apartmentNumber != null) {
                      addressText += "к${state.clientAddressModelList[index].apartmentNumber}";
                    }
                    return Container(
                      margin: EdgeInsets.only(bottom: heightRatio(size: 10, context: context)),
                      padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context), vertical: heightRatio(size: 10, context: context)),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)),
                        boxShadow: [BoxShadow(color: newShadow, offset: Offset(6, 6), blurRadius: 12, spreadRadius: 0)],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              addressText,
                              style: appLabelTextStyle(fontSize: heightRatio(size: 14, context: context), color: newBlack),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // showModalBottomSheet<dynamic>(
                              //     isScrollControlled: true,
                              //     context: context,
                              //     enableDrag: false,
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.only(
                              //             topLeft: Radius.circular(15),
                              //             topRight: Radius.circular(15))),
                              //     builder: (BuildContext bc) {
                              //       return AddressPicker(
                              //         clientAddressDataModel:
                              //             state.clientAddressModelList[index],
                              //       );
                              //     });
                              _geocodingbloc.add(GeocodingLoadEvent(address: "${state.clientAddressModelList.first.city} ${state.clientAddressModelList.first.street} ${state.clientAddressModelList.first.house}"));

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InitAddUserAddress(
                                      heightOfBottomNavBar: 60,
                                      clientAddressDataModel: state.clientAddressModelList[index],
                                      isNewAddress: false,
                                    ),
                                  ));
                            },
                            child: SvgPicture.asset(
                              "assets/images/newEdit.svg",
                              height: heightRatio(size: 26, context: context),
                              width: widthRatio(size: 26, context: context),
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          SizedBox(width: widthRatio(size: 8, context: context)),
                          if (state.clientAddressModelList.length > 1)
                            InkWell(
                              onTap: () async {
                                Fluttertoast.showToast(msg: "Подождите...");
                                if (await AddressesClientProvider().deleteClientAddressResponse(addressId: state.clientAddressModelList[index].uuid)) {
                                  _clientAddressBloc.add(LoadedAddressesClientEvent());
                                } else {
                                  Fluttertoast.showToast(msg: "errorText".tr());
                                }
                                if (state.clientAddressModelList.length == 1) {
                                  await prefs.remove(SharedKeys.myAddress);
                                }
                              },
                              child: SvgPicture.asset(
                                "assets/images/newTrash.svg",
                                height: heightRatio(size: 26, context: context),
                                width: widthRatio(size: 26, context: context),
                                fit: BoxFit.scaleDown,
                                color: newRedDark,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.clientAddressModelList.length,
                ),
              ),
            ],
          );
        }
        return Column(
          children: [
            Text('Адрес доставки', style: appHeadersTextStyle(color: newBlack212121, fontSize: 14)),
            SizedBox(height: heightRatio(size: 20, context: context)),
          ],
        );
      },
    );
  }
}
