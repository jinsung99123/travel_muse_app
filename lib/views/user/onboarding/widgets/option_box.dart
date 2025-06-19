import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_other_styles.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/models/user/profile_state.dart';
import 'package:travel_muse_app/viewmodels/user/profile_view_model.dart';

class OptionBox extends StatelessWidget {
  const OptionBox({
    super.key,
    required this.value,
    required this.state,
    required this.viewmodel,
  });

  final String value;
  final ProfileViewModel viewmodel;
  final ProfileState state;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          viewmodel.selectGender(value);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 56,
          decoration:
              state.gender == value
                  ? AppOtherStyles.selectedBox
                  : AppOtherStyles.unselectedBox,
          child: Center(
            child: Text(
              value,
              style:
                  state.gender == value
                      ? AppTextStyles.selectedBoxText
                      : AppTextStyles.unselectedBoxText,
            ),
          ),
        ),
      ),
    );
  }
}
