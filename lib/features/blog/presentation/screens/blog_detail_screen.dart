import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/blog_entity.dart';
import '../cubit/blog_details_cubit.dart';
import '../cubit/blog_details_state.dart';

class BlogDetailScreen extends StatefulWidget {
  const BlogDetailScreen({super.key, required this.blogId});

  final int blogId;

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  late final BlogDetailsCubit _blogDetailsCubit;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _blogDetailsCubit =
        getIt<BlogDetailsCubit>()..loadBlogDetails(widget.blogId);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _blogDetailsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تفاصيل المقال', style: AppTheme.heading3)),
      body: SafeArea(
        child: BlocBuilder<BlogDetailsCubit, BlogDetailsState>(
          bloc: _blogDetailsCubit,
          builder: (context, state) {
            if (state is BlogDetailsLoading || state is BlogDetailsInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BlogDetailsError) {
              return _buildError(state.message);
            }

            if (state is BlogDetailsSuccess) {
              return _buildContent(state.blog);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTheme.bodyLarge.copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _blogDetailsCubit.loadBlogDetails(widget.blogId),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel(List<String> images) {
    return Column(
      children: [
        SizedBox(
          height: 280,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: images[index],
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder:
                    (context, url) => Container(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 64,
                        color: AppTheme.primaryColor,
                      ),
                    ),
              );
            },
          ),
        ),
        if (images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        _currentPage == index
                            ? AppTheme.primaryColor
                            : AppTheme.primaryColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent(BlogEntity blog) {
    final images = blog.images ?? [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (images.isNotEmpty)
            _buildImageCarousel(images)
          else
            Container(
              height: 220,
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              alignment: Alignment.center,
              child: const Icon(
                Icons.image_not_supported_outlined,
                size: 64,
                color: AppTheme.primaryColor,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (blog.name != null)
                  Html(
                    data: blog.name!,
                    style: {
                      "body": Style(
                        fontSize: FontSize(22),
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                    },
                  ),
                const SizedBox(height: 20),
                if (blog.description != null)
                  Html(
                    data: blog.description!,
                    style: {
                      "body": Style(
                        fontSize: FontSize(16),
                        lineHeight: LineHeight(1.6),
                        color: AppTheme.textPrimary,
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
