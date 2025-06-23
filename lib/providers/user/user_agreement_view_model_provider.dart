import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/user/user_agreement_state_model.dart';
import 'package:travel_muse_app/viewmodels/user/user_agreement_view_model.dart';

final userAgreementViewModelProvider =
    AutoDisposeNotifierProvider<UserAgreementViewModel, UserAgreementState>(
      () => UserAgreementViewModel(),
    );
