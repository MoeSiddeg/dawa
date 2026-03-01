import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/blog_entity.dart';
import '../cubit/blogs_cubit.dart';
import '../cubit/blogs_state.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  late final BlogsCubit _blogsCubit;

  @override
  void initState() {
    super.initState();
    _blogsCubit = getIt<BlogsCubit>()..loadBlogs();
  }

  @override
  void dispose() {
    _blogsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('المدونة', style: AppTheme.heading3)),
      body: SafeArea(
        child: BlocBuilder<BlogsCubit, BlogsState>(
          bloc: _blogsCubit,
          builder: (context, state) {
            if (state is BlogsLoading || state is BlogsInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BlogsError) {
              return _buildError(state.message);
            }

            if (state is BlogsEmpty) {
              return _buildEmpty();
            }

            final blogs = state is BlogsSuccess ? state.blogs : <BlogEntity>[];
            final hasMore = state is BlogsSuccess ? state.hasMore : false;

            return RefreshIndicator(
              onRefresh: _blogsCubit.refresh,
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: blogs.length + (hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == blogs.length) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ElevatedButton(
                          onPressed: _blogsCubit.loadMore,
                          child: const Text('تحميل المزيد'),
                        ),
                      ),
                    );
                  }
                  final blog = blogs[index];
                  return _BlogCard(
                    blog: blog,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/blog-details',
                        arguments: blog.id,
                      );
                    },
                  );
                },
              ),
            );
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
              onPressed: _blogsCubit.loadBlogs,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد مقالات متاحة حالياً',
              style: AppTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BlogCard extends StatelessWidget {
  const _BlogCard({required this.blog, required this.onTap});

  final BlogEntity blog;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child:
                  blog.image != null && blog.image!.isNotEmpty
                      ? CachedNetworkImage(
                        imageUrl: blog.image!,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                size: 48,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                      )
                      : Container(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 48,
                          color: AppTheme.primaryColor,
                        ),
                      ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Html(
                    data: blog.name ?? 'بدون عنوان',
                    style: {
                      "body": Style(
                        fontSize: FontSize(18),
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    },
                  ),
                  if (blog.description != null) ...[
                    const SizedBox(height: 12),
                    Html(
                      data: blog.description!,
                      style: {
                        "body": Style(
                          fontSize: FontSize(14),
                          color: AppTheme.textSecondary,
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
