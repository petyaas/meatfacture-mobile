// // ignore: implementation_imports
// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:smart/bloc_files/assortment_recommendations_bloc.dart';
// import 'package:smart/bloc_files/secondary_pages_bloc.dart';
// import 'package:smart/custom_widgets/selected_store_om_main.dart';
// import 'package:smart/core/constants/source.dart';
// import 'package:smart/core/constants/text_styles.dart';

// class MakeOrderCard extends StatelessWidget {
//   const MakeOrderCard({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // ignore: close_sinks
//     AssortmentRecommendationBloc _assortmentRecommendationBloc = BlocProvider.of<AssortmentRecommendationBloc>(context);
//     // ignore: close_sinks
//     SecondaryPageBloc _secondaryPageBloc = BlocProvider.of<SecondaryPageBloc>(context);
//     return InkWell(
//       onTap: () {
//         _assortmentRecommendationBloc.add(AssortmentRecommendationsLoadEvent());

//         _secondaryPageBloc.add(CatalogEvent());
//       },
//       child: Card(
//         margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
//         clipBehavior: Clip.hardEdge,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightRatio(size: 20, context: context))),
//         elevation: 10,
//         shadowColor: colorBlack04,
//         child: Container(
//           height: heightRatio(size: 100, context: context),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.only(top: widthRatio(size: 15, context: context), left: widthRatio(size: 15, context: context), bottom: 0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("makeOrderText".tr(), style: appTextStyle(color: Colors.black, fontSize: heightRatio(size: 16, context: context), fontWeight: FontWeight.w700)),
//                       SizedBox(height: heightRatio(size: 5, context: context)),
//                       SelectedStoreOnMain(),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 alignment: Alignment.bottomRight,
//                 decoration: BoxDecoration(),
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     SvgPicture.asset('assets/images/pinkEllipse.svg'),
//                     Positioned(right: 17, bottom: 15, child: SvgPicture.asset('assets/images/boxPink.svg')),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
