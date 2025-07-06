// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smart/features/profile/bloc/profile_bloc.dart';
// import 'package:smart/core/constants/source.dart';
// import 'package:smart/core/constants/text_styles.dart';

// class SelectedStoreOnMain extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProfileBloc, ProfileState>(
//       builder: (context, state) {
//         if (state is ProfileLoadedState) {
//           if (state.profileModel.data.selectedStoreAddress != null) {
//             return Container(child: Text("storeSelectedText".tr() + ":\n${state.profileModel.data.selectedStoreAddress}", style: appTextStyle(fontSize: heightRatio(size: 12, context: context), fontWeight: FontWeight.w500, color: Colors.green)));
//           }
//         }
//         return SizedBox();
//       },
//     );
//   }
// }
