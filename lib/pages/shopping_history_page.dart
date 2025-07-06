import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/shopping_history_bloc.dart';
import 'package:smart/custom_widgets/shopping_history_content_widget.dart';
import 'package:smart/custom_widgets/switch_button_for_shopping_history_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class ShoppingHistoryPage extends StatelessWidget {
  final GlobalKey<NavigatorState> historyNavKey;
  final BuildContext outContext;
  final bool hasBack;

  const ShoppingHistoryPage({@required this.historyNavKey, this.outContext, this.hasBack = false});

  @override
  Widget build(BuildContext mainContext) {
    return BlocBuilder<ShoppingHistoryBloc, ShoppingHisoryState>(
      builder: (context, state) {
        return Navigator(
          key: historyNavKey,
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                color: newRedDark,
                child: SafeArea(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: heightRatio(size: 8, context: context)),
                        hasBack
                            ? Row(
                                children: [
                                  SizedBox(width: 16),
                                  InkWell(
                                    onTap: () => Navigator.pop(mainContext),
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: heightRatio(size: 22, context: context),
                                      color: whiteColor,
                                    ),
                                  ),
                                  SizedBox(width: widthRatio(size: 15, context: context)),
                                  Text(
                                    'История покупок',
                                    style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
                                  ),
                                ],
                              )
                            : Text(
                                'История покупок',
                                style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 22, context: context)),
                              ),
                        SizedBox(height: heightRatio(size: 12, context: context)),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(heightRatio(size: 15, context: context)),
                              topRight: Radius.circular(heightRatio(size: 15, context: context)),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: heightRatio(size: 20, context: context), left: widthRatio(size: 20, context: context), right: widthRatio(size: 20, context: context)),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  SwitchButtonForShoppingHistoryPage(),
                                  ShoppingHisoryContentWidget(hasBack: hasBack, mainContext: mainContext),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
