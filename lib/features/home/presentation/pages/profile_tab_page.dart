import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../global.dart';
import '../../../profile/presentation/cubit/user_profile_cubit.dart';
import '../../../profile/presentation/cubit/user_profile_state.dart';
import '../widgets/home_widgets.dart';

class ProfileTabPage extends StatelessWidget {
  final UserProfileCubit userProfileCubit;

  const ProfileTabPage({super.key, required this.userProfileCubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      bloc: userProfileCubit,
      builder: (context, state) {
        String userName = 'مستخدم ضيف';
        String userEmail = 'guest@drugvet.com';
        if (state is UserProfileSuccess) {
          userName = state.profile.name ?? 'مستخدم ضيف';
          userEmail = state.profile.email ?? '';
        }
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
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
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              MenuItemWidget(
                icon: Icons.person_outline,
                title: 'الملف الشخصي',
                onTap: () => Navigator.pushNamed(context, '/profile'),
              ),
              MenuItemWidget(
                icon: Icons.settings_outlined,
                title: 'الإعدادات',
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
              MenuItemWidget(
                icon: Icons.article_outlined,
                title: 'المدونة',
                onTap: () => Navigator.pushNamed(context, '/blog'),
              ),
              const Divider(height: 32),
              MenuItemWidget(
                icon: Icons.info_outline,
                title: 'عن التطبيق',
                onTap: () => Navigator.pushNamed(context, '/about'),
              ),
              MenuItemWidget(
                icon: Icons.help_outline,
                title: 'المساعدة',
                onTap: () => Navigator.pushNamed(context, '/help'),
              ),
              MenuItemWidget(
                icon: Icons.contact_support_outlined,
                title: 'اتصل بنا',
                onTap: () => Navigator.pushNamed(context, '/contact'),
              ),
              const Divider(height: 32),
              MenuItemWidget(
                icon: Icons.logout,
                title: 'تسجيل الخروج',
                onTap: () => _showLogoutDialog(context),
                color: AppTheme.errorColor,
              ),
              const SizedBox(height: 20),
              Center(child: Text('الإصدار 1.0.0', style: AppTheme.bodySmall)),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('تسجيل الخروج'),
            content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await Global.storageService.logout();
                  if (context.mounted) {
                    Navigator.of(
                      dialogContext,
                    ).pushNamedAndRemoveUntil(Routes.login, (route) => false);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
