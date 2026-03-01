import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/pages_repository.dart';
import 'page_content_state.dart';

enum PageType { aboutUs, help, privacyPolicy, termsOfUse }

class PageContentCubit extends Cubit<PageContentState> {
  final PagesRepository _repository;

  PageContentCubit(this._repository) : super(PageContentInitial());

  Future<void> loadPageContent(PageType pageType) async {
    emit(PageContentLoading());

    final result = switch (pageType) {
      PageType.aboutUs => await _repository.getAboutUs(),
      PageType.help => await _repository.getHelp(),
      PageType.privacyPolicy => await _repository.getPrivacyPolicy(),
      PageType.termsOfUse => await _repository.getTermsOfUse(),
    };

    result.when(
      success: (content) {
        emit(PageContentSuccess(content));
      },
      failure: (error) {
        emit(PageContentError(error.apiErrorModel.message ?? 'حدث خطأ ما'));
      },
    );
  }
}
