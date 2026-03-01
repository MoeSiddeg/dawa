import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/theme.dart';
import '../cubit/user_profile_cubit.dart';
import '../cubit/user_profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isEditing = false;
  bool _isInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateControllers(UserProfileState state) {
    if (!_isInitialized && state is UserProfileSuccess) {
      _nameController.text = state.profile.name ?? 'زائر';
      _emailController.text = state.profile.email ?? '';
      _phoneController.text = state.profile.phone ?? '';
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileCubit, UserProfileState>(
      bloc: getIt<UserProfileCubit>(),
      listener: (context, state) {
        if (state is UserProfileUpdateSuccess) {
          setState(() {
            _isEditing = false;
            _isInitialized = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.successColor,
            ),
          );
        } else if (state is UserProfileUpdateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        _updateControllers(state);
        final isUpdating = state is UserProfileUpdating;
        return Scaffold(
          appBar: AppBar(
            title: Text('الملف الشخصي', style: AppTheme.heading3),
            actions: [
              IconButton(
                icon: Icon(_isEditing ? Icons.close : Icons.edit),
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Profile Picture
                      Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppTheme.secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _nameController.text,
                        style: AppTheme.heading2.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _emailController.text,
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                // Profile Form
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('المعلومات الشخصية', style: AppTheme.heading3),
                        const SizedBox(height: 20),
                        // Name Field
                        TextFormField(
                          controller: _nameController,
                          enabled: _isEditing,
                          decoration: InputDecoration(
                            labelText: 'الاسم',
                            labelStyle: AppTheme.bodyMedium,
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال الاسم';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          enabled: _isEditing,
                          decoration: InputDecoration(
                            labelText: 'البريد الإلكتروني',
                            labelStyle: AppTheme.bodyMedium,
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            if (!value.contains('@')) {
                              return 'الرجاء إدخال بريد إلكتروني صحيح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Phone Field
                        TextFormField(
                          controller: _phoneController,
                          enabled: _isEditing,
                          decoration: InputDecoration(
                            labelText: 'رقم الهاتف',
                            labelStyle: AppTheme.bodyMedium,
                            prefixIcon: const Icon(Icons.phone_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال رقم الهاتف';
                            }
                            return null;
                          },
                        ),
                        if (_isEditing) ...[
                          const SizedBox(height: 32),
                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed:
                                  isUpdating
                                      ? null
                                      : () {
                                        if (_formKey.currentState!.validate()) {
                                          getIt<UserProfileCubit>()
                                              .updateProfile(
                                                name: _nameController.text,
                                                phone: _phoneController.text,
                                                email: _emailController.text,
                                              );
                                        }
                                      },
                              child:
                                  isUpdating
                                      ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : Text(
                                        'حفظ التغييرات',
                                        style: AppTheme.bodyLarge.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
