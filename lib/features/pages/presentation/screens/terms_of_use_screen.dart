import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/theme.dart';
import '../cubit/page_content_cubit.dart';
import '../cubit/page_content_state.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              getIt<PageContentCubit>()..loadPageContent(PageType.termsOfUse),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'شروط الاستخدام',
            style: AppTheme.heading3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppTheme.primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<PageContentCubit, PageContentState>(
            builder: (context, state) {
              if (state is PageContentLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is PageContentError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: AppTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed:
                            () => context
                                .read<PageContentCubit>()
                                .loadPageContent(PageType.termsOfUse),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }

              if (state is PageContentSuccess) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.primaryColor.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.description_outlined,
                              size: 60,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.content.name ?? 'شروط الاستخدام',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (state.content.description != null)
                        Html(
                          data: state.content.description!,
                          style: {
                            "body": Style(
                              fontSize: FontSize(16),
                              lineHeight: const LineHeight(1.8),
                            ),
                          },
                        ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
