import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/user/terms_model.dart';
import 'package:travel_muse_app/repositories/user/terms_repository.dart';

class TermsViewModel extends AutoDisposeAsyncNotifier<List<Terms>> {
  @override
  Future<List<Terms>> build() async {
    final termsListbyOrder = await _repository.fetchAllTermsOrdered();
    return termsListbyOrder;
  }

  final _repository = TermsRepository();
}
