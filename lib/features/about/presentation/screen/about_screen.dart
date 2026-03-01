import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ads_widget.dart';
import '../../../pages/presentation/cubit/page_content_cubit.dart';
import '../../../pages/presentation/cubit/page_content_state.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              getIt<PageContentCubit>()..loadPageContent(PageType.aboutUs),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'عن التطبيق',
            style: AppTheme.heading3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppTheme.primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
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
                        onPressed: () {
                          context.read<PageContentCubit>().loadPageContent(
                            PageType.aboutUs,
                          );
                        },
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }

              if (state is PageContentSuccess) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // App Logo
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.2,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 250,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        state.content.name ?? 'عن التطبيق',
                        style: AppTheme.heading1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text('الإصدار 1.0.0', style: AppTheme.bodyMedium),
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 16),
                      // Content from API
                      if (state.content.description != null)
                        Html(
                          data: state.content.description!,
                          style: {
                            "body": Style(
                              fontSize: FontSize(16),
                              lineHeight: const LineHeight(1.8),
                              textAlign: TextAlign.center,
                            ),
                          },
                        ),
                      const SizedBox(height: 32),
                      // Ads
                      const AdsWidget(),
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
