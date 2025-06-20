import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/user/terms_model.dart';
import 'package:travel_muse_app/viewmodels/user/terms_view_model.dart';

final termsViewModelProvider =
    AutoDisposeAsyncNotifierProvider<TermsViewModel, List<Terms>>(
      () => TermsViewModel(),
    );
