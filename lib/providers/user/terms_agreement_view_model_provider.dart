import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/user/terms_agreement_state_model.dart';
import 'package:travel_muse_app/viewmodels/user/terms_agreement_view_model.dart';

final termsAgreementViewModelProvider =
    AutoDisposeNotifierProvider<TermsAgreementViewModel, TermsAgreementState>(
      () => TermsAgreementViewModel(),
    );
