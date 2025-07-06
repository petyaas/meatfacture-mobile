import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/bloc_files/basic_page_bloc.dart';
import 'package:smart/features/addresses/addresses_delivery/bloc/addresses_client_bloc.dart';
import 'package:smart/bloc_files/credit_cards_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/bloc_files/reg_page_bloc.dart';
import 'package:smart/bloc_files/smart_contacts_bloc.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/custom_widgets/birthday_picker.dart';
import 'package:smart/custom_widgets/client_address_list_for_profile.dart';
import 'package:smart/custom_widgets/contacts_widgets.dart';
import 'package:smart/custom_widgets/credit_cards_list.dart';
import 'package:smart/custom_widgets/profile_switch.dart';
import 'package:smart/custom_widgets/redesigned_widgets/accaunt_will_be_deleted_content.dart';
import 'package:smart/custom_widgets/redesigned_widgets/delete_profile_bottom_sheet.dart';
import 'package:smart/features/profile/models/profile_model.dart';
import 'package:smart/main.dart';
import 'package:smart/models/url_for_credit_carde_link_model.dart';
import 'package:smart/pages/shopping_history_page.dart';
import 'package:smart/theme/app_gender_selection.dart';
import 'package:smart/theme/app_text_field.dart';
import 'package:smart/theme/app_screen.dart';
import 'package:smart/pages/init_add_user_address.dart';
import 'package:smart/pages/redesigned_pages/open_url_page.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/theme/app_alert.dart';

// Профиль
class ProfilePage extends StatefulWidget {
  final GlobalKey<NavigatorState> profileNavKey;

  const ProfilePage({Key key, this.profileNavKey}) : super(key: key);
  //это было нужно для модифициорванного браущера оплаты
  // AndroidServiceWorkerController androidServiceWorkerController =
  //     AndroidServiceWorkerController.instance();
  static Future<void> destroySharedPref() async {
    await prefs.remove('token');
    await prefs.remove('phone');
    await prefs.remove('shopUuid');
    await prefs.remove('shopAddress');
    await prefs.remove('shopLogo');
  }

  static logout({@required AuthPageBloc regBloc, @required BasicPageBloc basicPageBloc}) async {
    await ProfilePage.destroySharedPref();
    regBloc.add(LoginEvent());
    basicPageBloc.add(BasicPagesEvent.regPageEvent);
  }

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileModel profileModelFirst;
  ProfileModel profileModelSecond;
  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  bool isCardLinkIsOpened = false;
  AddressesClientBloc _clientAddressBloc;
  Timer _debounce;

  @override
  void initState() {
    _clientAddressBloc = BlocProvider.of<AddressesClientBloc>(context);
    _clientAddressBloc.add(LoadedAddressesClientEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
    BasicPageBloc _basicPageBloc = BlocProvider.of<BasicPageBloc>(context);
    AuthPageBloc _regBloc = BlocProvider.of<AuthPageBloc>(context);
    CreditCardsListBloc _cardsListBloc = BlocProvider.of<CreditCardsListBloc>(context);
    SmartContactsBloc _smartContactsBloc = BlocProvider.of<SmartContactsBloc>(context);
    String bDateText;
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileOldTokenState) {
          ProfilePage.logout(regBloc: _regBloc, basicPageBloc: _basicPageBloc);
        }
      },
      builder: (context, state) {
        if (state is ProfileLoadedState) {
          profileModelFirst = state.profileModel;
          profileModelSecond = state.profileModel;
          nameTextController.text = state.profileModel.data.name;
          emailTextController.text = state.profileModel.data.email;
          phoneTextController.text = state.profileModel.data.phone.replaceFirst("+7", "");
        }
        final bool isDeleted = false;
        if (profileModelSecond.data.birthDate != null) {
          String birthDateString = profileModelSecond.data.birthDate;
          DateFormat serverDateFormat = DateFormat("yyyy-MM-dd HH:mm:ssZ");
          DateTime bDate = serverDateFormat.parse(birthDateString, true);
          String monthName;
          switch (bDate.month) {
            case 1:
              monthName = "januaryText".tr();
              break;
            case 2:
              monthName = "februaryText".tr();
              break;
            case 3:
              monthName = "marchText".tr();
              break;
            case 4:
              monthName = "aprilText".tr();
              break;
            case 5:
              monthName = "mayText".tr();
              break;
            case 6:
              monthName = "juneText".tr();
              break;
            case 7:
              monthName = "julyText".tr();
              break;
            case 8:
              monthName = "augustText".tr();
              break;
            case 9:
              monthName = "septemberText".tr();
              break;
            case 10:
              monthName = "octoberText".tr();
              break;
            case 11:
              monthName = "novemberText".tr();
              break;
            case 12:
              monthName = "decemberText".tr();
              break;
            default:
              monthName = '';
          }
          bDateText = "${bDate.day} $monthName ${bDate.year}";
        }

        return Navigator(
          key: widget.profileNavKey,
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: newRedDark,
                body: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: heightRatio(size: 10, context: context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'profileText'.tr(),
                            style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(height: heightRatio(size: 12, context: context)),
                      Expanded(
                        child: state is ProfileLoadedState
                            ? Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                                    topRight: Radius.circular(heightRatio(size: 15, context: context)),
                                  ),
                                ),
                                child: RefreshIndicator(
                                  color: mainColor,
                                  onRefresh: () async {
                                    _cardsListBloc.add(CreditCardsListLoadEvent());
                                    _clientAddressBloc.add(LoadedAddressesClientEvent());
                                    _profileBloc.add(ProfileLoadEvent());
                                  },
                                  child: Form(
                                    key: formKey,
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: Container(
                                        padding: EdgeInsets.only(left: widthRatio(size: 20, context: context), right: widthRatio(size: 20, context: context)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: heightRatio(size: 30, context: context)),
                                            Text('Личные данные', style: appHeadersTextStyle(color: newBlack212121, fontSize: 14)),
                                            SizedBox(height: heightRatio(size: 10, context: context)),
                                            AppTextField(
                                              context: context,
                                              controller: nameTextController,
                                              hintText: 'Имя',
                                              inputFormatters: [
                                                TextInputFormatter.withFunction((oldValue, newValue) {
                                                  // Проверяем, не пустая ли строка и не является ли первый символ заглавным
                                                  if (newValue.text.isNotEmpty && newValue.text[0] != newValue.text[0].toUpperCase()) {
                                                    // Возвращаем значение с первой заглавной буквой
                                                    return newValue.copyWith(
                                                      text: newValue.text.replaceFirst(newValue.text[0], newValue.text[0].toUpperCase()),
                                                      selection: TextSelection.collapsed(offset: newValue.selection.end),
                                                    );
                                                  }
                                                  return newValue;
                                                }),
                                              ],
                                              // validator: (value) => AppValidators.emptyValidator(value, 'Будем знать, как к Вам обращаться'),
                                              onChanged: (value) {
                                                // Обнуляем предыдущий таймер, если пользователь продолжает ввод
                                                if (_debounce?.isActive ?? false) {
                                                  _debounce.cancel();
                                                }

                                                // Запускаем новый таймер с задержкой 1.5 секунды
                                                _debounce = Timer(const Duration(milliseconds: 1500), () {
                                                  if (value.length > 1) {
                                                    final form = formKey.currentState;
                                                    if (state is ProfileLoadedState) {
                                                      if (form.validate()) {
                                                        profileModelSecond.data.name = nameTextController.text ?? '';
                                                        if (emailTextController.text.isNotEmpty) {
                                                          profileModelSecond.data.email = emailTextController.text;
                                                        }
                                                        if (phoneTextController.text.isNotEmpty && phoneTextController.text.length == 10) {
                                                          profileModelSecond.data.phone = "+7" + phoneTextController.text;
                                                        } else {
                                                          profileModelSecond.data.phone = profileModelFirst.data.phone;
                                                        }
                                                        _profileBloc.add(
                                                          ProfileUpdateDataEvent(
                                                            name: profileModelSecond.data.name,
                                                            email: profileModelSecond.data.email,
                                                            phone: profileModelSecond.data.phone,
                                                          ),
                                                        );
                                                      } else {}
                                                    } else {}
                                                  }
                                                });
                                              },
                                            ),
                                            SizedBox(height: heightRatio(size: 6, context: context)),
                                            Text(
                                              'Будем знать, как к Вам обращаться',
                                              style: appLabelTextStyle(color: newGrey6B6B6B, fontSize: heightRatio(size: 12, context: context)),
                                            ),
                                            SizedBox(height: heightRatio(size: 15, context: context)),
                                            InkWell(
                                              onTap: () {
                                                AppAlert.show(
                                                  context: context,
                                                  message: 'К сожалению, нельзя изменить номер телефона учетной записи, ',
                                                  messageTap: 'обратитесь в поддержку',
                                                  sec: 3,
                                                  isPushToContactsWidget: true,
                                                  funcPushToContactsWidgetOnTap: () {
                                                    _smartContactsBloc.add(SmartContactsLoadEvent());
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => AppScreen(
                                                          title: "Поддержка",
                                                          content: ContactsWidget(),
                                                          titleCenter: true,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: AppTextField(
                                                context: context,
                                                controller: TextEditingController(text: state.profileModel.data.phone),
                                                hintText: '+7 901 123 45 67',
                                                // validator: (value) => AppValidators.emptyValidator(value, 'Будем уведомлять о скидках и новинках (можно выключить)'),
                                                enabled: false,
                                                onChanged: (value) {},
                                              ),
                                            ),
                                            SizedBox(height: heightRatio(size: 6, context: context)),
                                            Text(
                                              'Будем уведомлять о скидках и новинках (можно выключить)',
                                              style: appLabelTextStyle(color: newGrey6B6B6B, fontSize: heightRatio(size: 12, context: context)),
                                            ),
                                            SizedBox(height: heightRatio(size: 15, context: context)),
                                            AppTextField(
                                              context: context,
                                              controller: emailTextController,
                                              hintText: 'your@mail.ru',
                                              // validator: (email) => AppValidators.emailValidator(email),
                                              keyboardType: TextInputType.emailAddress,
                                              onChanged: (value) {
                                                // Обнуляем предыдущий таймер, если пользователь продолжает ввод
                                                if (_debounce?.isActive ?? false) {
                                                  _debounce.cancel();
                                                }

                                                // Запускаем новый таймер с задержкой 3 секунды
                                                _debounce = Timer(const Duration(milliseconds: 3000), () {
                                                  if (value.length > 1) {
                                                    final form = formKey.currentState;
                                                    if (state is ProfileLoadedState) {
                                                      if (form.validate()) {
                                                        profileModelSecond.data.name = nameTextController.text ?? "";
                                                        emailTextController.text != ""
                                                            ? profileModelSecond.data.email = emailTextController.text
                                                            : emailTextController.text;
                                                        profileModelSecond.data.phone = phoneTextController.text.length == 10
                                                            ? "+7" + phoneTextController.text
                                                            : profileModelFirst.data.phone;
                                                        _profileBloc.add(ProfileUpdateDataEvent(
                                                            name: profileModelSecond.data.name,
                                                            email: profileModelSecond.data.email,
                                                            phone: profileModelSecond.data.phone));
                                                      } else {
                                                        // scrollController.animateTo(
                                                        //     100,
                                                        //     duration: Duration(
                                                        //         milliseconds:
                                                        //             500),
                                                        //     curve:
                                                        //         Curves.ease);
                                                      }
                                                    } else {
                                                      // _bottomNavBloc.add(  ());
                                                      // Navigator.pop(context);
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                            SizedBox(height: heightRatio(size: 6, context: context)),
                                            Text(
                                              'Будем отправлять чеки и акции на продукты',
                                              style: appLabelTextStyle(color: newGrey6B6B6B, fontSize: heightRatio(size: 12, context: context)),
                                            ),
                                            SizedBox(height: heightRatio(size: profileModelSecond.data.birthDate == null ? 35 : 15, context: context)),
                                            profileModelSecond.data.birthDate == null
                                                ? BirthdayPicker(
                                                    dateFromProfile: profileModelSecond.data.birthDate != null
                                                        ? profileModelSecond.data.birthDate.replaceAll("+0300", "+0000")
                                                        : null,
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      AppAlert.show(
                                                        context: context,
                                                        message: 'К сожалению, нельзя изменить дату рождения, ',
                                                        messageTap: 'обратитесь в поддержку',
                                                        sec: 3,
                                                        isPushToContactsWidget: true,
                                                        funcPushToContactsWidgetOnTap: () {
                                                          _smartContactsBloc.add(SmartContactsLoadEvent());
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => AppScreen(
                                                                title: "Поддержка",
                                                                content: ContactsWidget(),
                                                                titleCenter: true,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: AppTextField(
                                                      context: context,
                                                      controller: TextEditingController(text: bDateText),
                                                      hintText: '',
                                                      enabled: false,
                                                      onChanged: (value) {},
                                                    ),
                                                  ),
                                            SizedBox(height: heightRatio(size: 6, context: context)),
                                            Text(
                                              'Будем поздравлять и дарить бонусы и скидки',
                                              style: appLabelTextStyle(color: newGrey6B6B6B, fontSize: heightRatio(size: 12, context: context)),
                                            ),

                                            SizedBox(height: heightRatio(size: 35, context: context)),

                                            Text('Ваш пол', style: appHeadersTextStyle(color: newBlack212121, fontSize: 14)),
                                            // GenderDropDown(
                                            //     sex: state.profileModel.data.sex == null
                                            //         ? 'selectText'.tr()
                                            //         : state.profileModel.data.sex == 'male'
                                            //             ? "maleText".tr()
                                            //             : "femaileText".tr()),
                                            SizedBox(height: heightRatio(size: 15, context: context)),
                                            AppGenderSelection(gender: state.profileModel.data.sex),
                                            // Text(
                                            //   'selectedStoreText'.tr(),
                                            //   style:
                                            //       profileGreyTextStyle,
                                            // ),
                                            // //stores
                                            // SizedBox(height: 15),
                                            // GestureDetector(
                                            //   onTap: () {
                                            //     CatalogPage()
                                            //         .openShopDetailsBottomSheet(
                                            //             context,
                                            //             ProfileSecondaryPageEvent());
                                            //   },
                                            //   child: Text(
                                            //     state.profileModel.data
                                            //                 .selectedStoreUserUuid !=
                                            //             null
                                            //         ? state
                                            //             .profileModel
                                            //             .data
                                            //             .selectedStoreAddress
                                            //         : "Магазин не выбран",
                                            //     style:
                                            //         notEmptyHintTextStyle,
                                            //   ),
                                            // ),
                                            // Divider(),
                                            SizedBox(height: heightRatio(size: 40, context: context)),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ShoppingHistoryPage(
                                                        historyNavKey: null,
                                                        hasBack: true,
                                                        outContext: context,
                                                      ),
                                                    ));
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
                                                        Container(
                                                          width: 60,
                                                          height: 60,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)), color: newIconBg),
                                                          child: SvgPicture.asset("assets/images/newHistory.svg",
                                                              height: heightRatio(size: 28, context: context),
                                                              width: widthRatio(size: 32, context: context),
                                                              fit: BoxFit.scaleDown),
                                                        ),
                                                        SizedBox(width: widthRatio(size: 15, context: context)),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'История покупок',
                                                                style: appHeadersTextStyle(fontSize: heightRatio(size: 15, context: context), color: newBlack),
                                                              ),
                                                              SizedBox(height: heightRatio(size: 5, context: context)),
                                                              Text(
                                                                'Здесь хранятся все выполненные заказы и оплаченные чеки',
                                                                textAlign: TextAlign.start,
                                                                style: appLabelTextStyle(
                                                                    fontSize: heightRatio(size: 13, context: context),
                                                                    fontWeight: FontWeight.w400,
                                                                    color: newBlackLight),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: widthRatio(size: 10, context: context)),
                                                        Icon(
                                                          Icons.arrow_forward_ios_rounded,
                                                          color: newRedDark,
                                                          size: heightRatio(size: 23, context: context),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: heightRatio(size: 40, context: context)),
                                            ClientAddressListForProfile(),
                                            SizedBox(height: heightRatio(size: 10, context: context)),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => InitAddUserAddress(heightOfBottomNavBar: 60, isNewAddress: true),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: widthRatio(size: 36, context: context),
                                                height: heightRatio(size: 36, context: context),
                                                decoration: BoxDecoration(color: newRedDark, borderRadius: BorderRadius.circular(19)),
                                                alignment: Alignment.center,
                                                child: Icon(Icons.add, color: Colors.white, size: heightRatio(size: 24, context: context)),
                                              ),
                                            ),
                                            SizedBox(height: heightRatio(size: 30, context: context)),
                                            Text('Способы оплаты', style: appHeadersTextStyle(color: newBlack212121, fontSize: 14)),
                                            SizedBox(height: heightRatio(size: 20, context: context)),
                                            CreditCardsList(),
                                            SizedBox(height: heightRatio(size: 10, context: context)),
                                            InkWell(
                                              onTap: () async => openLinkPayCardPAge(cardsListBloc: _cardsListBloc),
                                              child: Container(
                                                width: widthRatio(size: 36, context: context),
                                                height: heightRatio(size: 36, context: context),
                                                decoration: BoxDecoration(color: newRedDark, borderRadius: BorderRadius.circular(19)),
                                                alignment: Alignment.center,
                                                child: Icon(Icons.add, color: Colors.white, size: heightRatio(size: 24, context: context)),
                                              ),
                                            ),
                                            SizedBox(height: heightRatio(size: 40, context: context)),

                                            // LoyaltyCardsListWidget(),
                                            // SizedBox(
                                            //     height: heightRatio(
                                            //         size: 15,
                                            //         context: context)),

                                            // Divider(),

                                            //mailings(Рассылки)
                                            Text('Уведомления', style: appHeadersTextStyle(color: newBlack212121, fontSize: 14)),
                                            SizedBox(height: heightRatio(size: 10, context: context)),
                                            BlocBuilder<ProfileBloc, ProfileState>(
                                              builder: (context, state) {
                                                if (state is ProfileLoadedState) {
                                                  return Column(
                                                    children: [
                                                      ProfileSwitches(
                                                        check: state.profileModel.data.consentToServiceNewsletter,
                                                        switchText: "serviceText".tr(),
                                                      ),
                                                      ProfileSwitches(
                                                        check: state.profileModel.data.consentToReceivePromotionalMailings,
                                                        switchText: "promoText".tr(),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Center(child: CircularProgressIndicator());
                                                }
                                              },
                                            ),

                                            SizedBox(height: heightRatio(size: 40, context: context)),
                                            Center(
                                              child: InkWell(
                                                onTap: () async {
                                                  if (await ProfileProvider().logoutResponse()) {
                                                    (ProfilePage.logout(basicPageBloc: _basicPageBloc, regBloc: _regBloc));
                                                  } else {
                                                    ProfilePage.logout(basicPageBloc: _basicPageBloc, regBloc: _regBloc);
                                                  }
                                                },
                                                child: Text(
                                                  'Выйти из аккаунта',
                                                  style: appHeadersTextStyle(color: newBlack212121, fontSize: heightRatio(size: 14, context: context)),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: heightRatio(size: 40, context: context)),
                                            Text('Настройки профиля', style: appHeadersTextStyle(color: newBlack212121, fontSize: 14)),
                                            SizedBox(height: heightRatio(size: 15, context: context)),
                                            InkWell(
                                              onTap: () async {
                                                if (state.profileModel.data.markDeletedAt != null &&
                                                        DateTime.now().day - DateTime.parse(state.profileModel.data.markDeletedAt).day < 14 ||
                                                    isDeleted == true) {
                                                  prefs = await SharedPreferences.getInstance();
                                                  String number = await prefs.getString(SharedKeys.callCenterNumber);
                                                  showModalBottomSheet<dynamic>(
                                                      isScrollControlled: true,
                                                      useSafeArea: true,
                                                      context: context,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(heightRatio(size: 25, context: context)),
                                                          topRight: Radius.circular(heightRatio(size: 25, context: context)),
                                                        ),
                                                      ),
                                                      builder: (BuildContext bc) {
                                                        return Wrap(children: [AccauntWillBeDeletedContent(callCenterNumber: number)]);
                                                      });
                                                } else {
                                                  showModalBottomSheet<dynamic>(
                                                    isScrollControlled: true,
                                                    context: context,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(heightRatio(size: 25, context: context)),
                                                        topRight: Radius.circular(heightRatio(size: 25, context: context)),
                                                      ),
                                                    ),
                                                    builder: (BuildContext bc) {
                                                      return Wrap(children: [DeleteProfileBottomSheet(isDeleted: isDeleted)]);
                                                    },
                                                  );
                                                }
                                              },
                                              child: Text(
                                                'Удалить профиль',
                                                style: appLabelTextStyle(fontSize: 13, color: newRedDark),
                                              ),
                                            ),
                                            SizedBox(height: heightRatio(size: 30, context: context)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : state is ProfileEmptyState
                                ? Container(
                                    padding: EdgeInsets.only(left: widthRatio(size: 20, context: context), right: widthRatio(size: 20, context: context)),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                                        topRight: Radius.circular(heightRatio(size: 15, context: context)),
                                      ),
                                    ),
                                  )
                                : state is ProfileLoadingState
                                    ? Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(left: widthRatio(size: 20, context: context), right: widthRatio(size: 20, context: context)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                                            topRight: Radius.circular(heightRatio(size: 15, context: context)),
                                          ),
                                        ),
                                        child: Center(
                                            child: CircularProgressIndicator(
                                          valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                                        )),
                                      )
                                    : state is ProfileErrorState
                                        ? Container(
                                            alignment: Alignment.center,
                                            padding:
                                                EdgeInsets.only(left: widthRatio(size: 20, context: context), right: widthRatio(size: 20, context: context)),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                                                topRight: Radius.circular(heightRatio(size: 15, context: context)),
                                              ),
                                            ),
                                            child: Center(
                                                child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
                                                  decoration: BoxDecoration(color: colorBlack03, shape: BoxShape.circle),
                                                  child: SvgPicture.asset(
                                                    'assets/images/netErrorIcon.svg',
                                                    color: Colors.white,
                                                    height: heightRatio(size: 30, context: context),
                                                  ),
                                                ),
                                                SizedBox(height: heightRatio(size: 15, context: context)),
                                                Text(
                                                  "errorText".tr(),
                                                  style: appHeadersTextStyle(
                                                      fontSize: heightRatio(size: 18, context: context), color: colorBlack06, fontWeight: FontWeight.w500),
                                                ),
                                                SizedBox(height: heightRatio(size: 10, context: context)),
                                                InkWell(
                                                    onTap: () {
                                                      _profileBloc.add(ProfileLoadEvent());
                                                    },
                                                    child: Container(
                                                      color: Colors.transparent,
                                                      child: Text(
                                                        "tryAgainText".tr(),
                                                        style: appHeadersTextStyle(
                                                            fontSize: heightRatio(size: 14, context: context), color: mainColor, fontWeight: FontWeight.w500),
                                                      ),
                                                    ))
                                              ],
                                            )),
                                          )
                                        : Container(
                                            padding:
                                                EdgeInsets.only(left: widthRatio(size: 20, context: context), right: widthRatio(size: 20, context: context)),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                                                topRight: Radius.circular(heightRatio(size: 15, context: context)),
                                              ),
                                            ),
                                            child: Text('errorText'.tr()),
                                          ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  openLinkPayCardPAge({@required CreditCardsListBloc cardsListBloc}) async {
    if (isCardLinkIsOpened == false) {
      setState(() {
        isCardLinkIsOpened = true;
      });
      Fluttertoast.showToast(msg: "Подождите...");
      UrlForCreditCardLinkModel _urlForCreditCardLinkModel = await CreditCardsProvider().getUrlForCreditCardLinkResponse();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return openUrlPage(
                cardsListBloc: cardsListBloc, orderId: _urlForCreditCardLinkModel.data.orderId, url: _urlForCreditCardLinkModel.data.formUrl, context: context);
          },
        ),
      ).then(
        (value) async {
          setState(() {
            isCardLinkIsOpened = false;
          });
          if (await CreditCardsProvider().setSuccessStatusOfLinkingCardResponse(orderId: _urlForCreditCardLinkModel.data.orderId)) {
            cardsListBloc.add(CreditCardsListLoadEvent());
          }
        },
      );
    }
  }
}
