import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/features/profile/bloc/profile_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class UserNameInLCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Container(
          alignment: Alignment.centerLeft,
          child: Text(
            state is ProfileLoadedState && state != null && state.profileModel.data.name != null && state.profileModel.data.name != "" ? state.profileModel.data.name : "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: appTextStyle(fontSize: heightRatio(size: 20, context: context), fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}

class UserNameInLCardForProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Container(
          alignment: Alignment.centerLeft,
          child: Text(
            state is ProfileLoadedState && state != null && state.profileModel.data.name != null ? state.profileModel.data.name : "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: appTextStyle(fontSize: heightRatio(size: 20, context: context), fontWeight: FontWeight.w800, color: Colors.white),
          ),
        );
      },
    );
  }
}
