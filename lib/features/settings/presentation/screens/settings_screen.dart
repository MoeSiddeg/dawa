import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/route/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../global.dart';
import '../../../profile/presentation/cubit/user_profile_cubit.dart';
import '../../../profile/presentation/cubit/user_profile_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      bloc: getIt<UserProfileCubit>(),
      builder: (context, state) {
        String userName = 'زائر';
        String userEmail = '';
        if (state is UserProfileSuccess) {
          userName = state.profile.name ?? 'زائر';
          userEmail = state.profile.email ?? '';
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'الإعدادات',
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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Account Section
                Text('الحساب', style: AppTheme.heading3),
                const SizedBox(height: 16),
                _buildListTile(
                  userName,
                  userEmail.isNotEmpty ? userEmail : 'تحديث معلوماتك الشخصية',
                  Icons.person,
                  () => Navigator.pushNamed(context, Routes.profile),
                ),
                _buildListTile(
                  'تغيير كلمة المرور',
                  'تحديث كلمة المرور',
                  Icons.lock,
                  () => Navigator.pushNamed(context, Routes.forgotPassword),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                // About Section
                Text('حول', style: AppTheme.heading3),
                const SizedBox(height: 16),
                _buildListTile(
                  'شروط الاستخدام',
                  'اقرأ شروط وأحكام الاستخدام',
                  Icons.description,
                  () => Navigator.pushNamed(context, Routes.termsOfUse),
                ),
                _buildListTile('الإصدار', '1.0.0', Icons.info, null),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(),
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text(
          'تسجيل الخروج',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
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
                  if (mounted) {
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

  Widget _buildListTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback? onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title, style: AppTheme.bodyLarge),
        subtitle: Text(subtitle, style: AppTheme.bodySmall),
        trailing:
            onTap != null
                ? const Icon(Icons.arrow_forward_ios, size: 16)
                : null,
        onTap: onTap,
      ),
    );
  }
}
