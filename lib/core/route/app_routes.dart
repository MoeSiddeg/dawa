import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/dependency_injection.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/register_cubit.dart';
import '../../features/auth/presentation/cubit/reset_password_cubit.dart';
import '../../features/auth/presentation/screen/forgot_password_screen.dart';
import '../../features/auth/presentation/screen/verify_otp_screen.dart';
import '../../features/auth/presentation/screen/reset_password_screen.dart';
import '../../features/doctors/presentation/cubit/category_doctors_cubit.dart';
import '../../features/doctors/presentation/screens/category_doctors_screen.dart';

// Screen imports
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screen/login_screen.dart';
import '../../features/auth/presentation/screen/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/consultant_screen.dart';
import '../../features/drugs/presentation/screens/drug_details_screen.dart';
import '../../features/drugs/presentation/screens/most_viewed_medicines_screen.dart';
import '../../features/drugs/presentation/screens/special_medicine_search_screen.dart';
import '../../features/drugs/presentation/cubit/most_viewed_medicines_cubit.dart';
import '../../features/drugs/presentation/cubit/drug_details_cubit.dart';
import '../../features/drugs/presentation/cubit/special_medicine_search_cubit.dart';
import '../../features/compaies/presentation/screens/companies_screen.dart';
import '../../features/compaies/presentation/screens/company_products_screen.dart';
import '../../features/companies/presentation/screens/company_details_screen.dart';
import '../../features/categories/presentation/screens/categories_screen.dart';
import '../../features/categories/presentation/screens/category_drugs_screen.dart';
import '../../features/about/presentation/screen/about_screen.dart';
import '../../features/contact/presentation/screens/contact_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/help/presentation/screens/help_screen.dart';
import '../../features/doctors/presentation/screens/doctor_details_screen.dart';
import '../../features/doctors/presentation/cubit/doctor_details_cubit.dart';
import '../../features/blog/presentation/screens/blog_detail_screen.dart';
import '../../features/blog/presentation/screens/blog_list_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/pages/presentation/screens/privacy_policy_screen.dart';
import '../../features/pages/presentation/screens/terms_of_use_screen.dart';

/// Route names as constants for type-safe navigation
class Routes {
  Routes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String consultant = '/consultant';
  static const String drugDetails = '/drug-details';
  static const String mostViewedMedicines = '/most-viewed-medicines';
  static const String specialMedicineSearch = '/special-medicine-search';
  static const String companies = '/companies';
  static const String companyProducts = '/company-products';
  static const String companyDetails = '/company-details';
  static const String categories = '/categories';
  static const String categoryDrugs = '/category-drugs';
  static const String about = '/about';
  static const String contact = '/contact';
  static const String settings = '/settings';
  static const String help = '/help';
  static const String doctorDetails = '/doctor-details';
  static const String blog = '/blog';
  static const String blogDetails = '/blog-details';
  static const String profile = '/profile';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfUse = '/terms-of-use';
  static const String forgotPassword = '/forgot-password';
  static const String verifyOtp = '/verify-otp';
  static const String resetPassword = '/reset-password';
  static const String categoryDoctors = '/category-doctors';
}

/// App Router class that handles all routing logic
/// Designed to work with BlocProvider for state management
class AppRouter {
  /// Generate route based on settings
  /// This method can be extended to wrap screens with BlocProvider
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _buildRoute(settings, const SplashScreen());

      case Routes.login:
        return _buildRouteWithBloc<LoginCubit>(
          settings,
          create: (_) => getIt<LoginCubit>(),
          child: const LoginScreen(),
        );

      case Routes.register:
        return _buildRouteWithBloc<RegisterCubit>(
          settings,
          create: (_) => getIt<RegisterCubit>(),
          child: const RegisterScreen(),
        );

      case Routes.home:
        return _buildRoute(
          settings,
          const HomeScreen(),
          // TODO: Wrap with BlocProvider<HomeCubit>
        );

      case Routes.consultant:
        return _buildRoute(settings, const ConsultantScreen());

      case Routes.drugDetails:
        final drugId = settings.arguments as int?;
        if (drugId == null) {
          return _buildRoute(settings, const _NotFoundScreen());
        }
        return _buildRouteWithBloc<DrugDetailsCubit>(
          settings,
          create: (_) => getIt<DrugDetailsCubit>()..loadDrugDetails(drugId),
          child: DrugDetailsScreen(drugId: drugId),
        );

      case Routes.mostViewedMedicines:
        return _buildRouteWithBloc<MostViewedMedicinesCubit>(
          settings,
          create:
              (_) =>
                  getIt<MostViewedMedicinesCubit>()..loadMostViewedMedicines(),
          child: const MostViewedMedicinesScreen(),
        );

      case Routes.specialMedicineSearch:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (context) => BlocProvider<SpecialMedicineSearchCubit>.value(
                value: getIt<SpecialMedicineSearchCubit>(),
                child: const SpecialMedicineSearchScreen(),
              ),
        );

      case Routes.companies:
        return _buildRoute(
          settings,
          const CompaniesScreen(),
          // TODO: Wrap with BlocProvider<CompaniesCubit>
        );

      case Routes.companyProducts:
        final args = settings.arguments as CompanyProductsArgs?;
        return _buildRoute(
          settings,
          CompanyProductsScreen(
            companyName: args?.companyName ?? '',
            companyNameAr: args?.companyNameAr ?? '',
          ),
        );

      case Routes.companyDetails:
        final companyId = settings.arguments as int?;
        if (companyId == null) {
          return _buildRoute(settings, const _NotFoundScreen());
        }
        return _buildRoute(
          settings,
          CompanyDetailsScreen(companyId: companyId),
        );

      case Routes.categories:
        return _buildRoute(
          settings,
          const CategoriesScreen(),
          // TODO: Wrap with BlocProvider<CategoriesCubit>
        );

      case Routes.categoryDrugs:
        final args = settings.arguments as CategoryDrugsArgs?;
        return _buildRoute(
          settings,
          CategoryDrugsScreen(
            categoryName: args?.categoryName ?? '',
            categoryColor: args?.categoryColor ?? Colors.blue,
          ),
        );

      case Routes.about:
        return _buildRoute(settings, const AboutScreen());

      case Routes.contact:
        return _buildRoute(settings, const ContactScreen());

      case Routes.settings:
        return _buildRoute(settings, const SettingsScreen());

      case Routes.help:
        return _buildRoute(settings, const HelpScreen());

      case Routes.doctorDetails:
        final doctorId = settings.arguments as int?;
        if (doctorId == null) {
          return _buildRoute(settings, const _NotFoundScreen());
        }
        return _buildRouteWithBloc<DoctorDetailsCubit>(
          settings,
          create:
              (_) => getIt<DoctorDetailsCubit>()..loadDoctorDetails(doctorId),
          child: DoctorDetailsScreen(doctorId: doctorId),
        );

      case Routes.blog:
        return _buildRoute(settings, const BlogListScreen());

      case Routes.blogDetails:
        final blogId = settings.arguments as int?;
        if (blogId == null) {
          return _buildRoute(settings, const _NotFoundScreen());
        }
        return _buildRoute(settings, BlogDetailScreen(blogId: blogId));

      case Routes.profile:
        return _buildRoute(
          settings,
          const ProfileScreen(),
          // TODO: Wrap with BlocProvider<ProfileCubit>
        );

      case Routes.privacyPolicy:
        return _buildRoute(settings, const PrivacyPolicyScreen());

      case Routes.termsOfUse:
        return _buildRoute(settings, const TermsOfUseScreen());

      case Routes.forgotPassword:
        return _buildRouteWithBloc<ResetPasswordCubit>(
          settings,
          create: (_) => getIt<ResetPasswordCubit>(),
          child: const ForgotPasswordScreen(),
        );

      case Routes.verifyOtp:
        final email = settings.arguments as String?;
        if (email == null) {
          return _buildRoute(settings, const _NotFoundScreen());
        }
        return _buildRouteWithBloc<ResetPasswordCubit>(
          settings,
          create: (_) => getIt<ResetPasswordCubit>(),
          child: VerifyOtpScreen(email: email),
        );

      case Routes.resetPassword:
        final email = settings.arguments as String?;
        if (email == null) {
          return _buildRoute(settings, const _NotFoundScreen());
        }
        return _buildRouteWithBloc<ResetPasswordCubit>(
          settings,
          create: (_) => getIt<ResetPasswordCubit>(),
          child: ResetPasswordScreen(email: email),
        );

      case Routes.categoryDoctors:
        final args = settings.arguments as CategoryDoctorsArgs?;
        if (args == null) {
          return _buildRoute(settings, const _NotFoundScreen());
        }
        return _buildRouteWithBloc<CategoryDoctorsCubit>(
          settings,
          create: (_) => getIt<CategoryDoctorsCubit>(),
          child: CategoryDoctorsScreen(
            initialCategoryId: args.categoryId,
            initialCategoryName: args.categoryName,
          ),
        );

      default:
        return _buildRoute(settings, const _NotFoundScreen());
    }
  }

  /// Build a MaterialPageRoute
  /// This method can be modified to wrap with BlocProvider
  static MaterialPageRoute<dynamic> _buildRoute(
    RouteSettings settings,
    Widget screen,
  ) {
    return MaterialPageRoute(settings: settings, builder: (_) => screen);
  }

  /// Helper method to wrap screen with BlocProvider
  static MaterialPageRoute<dynamic>
  _buildRouteWithBloc<T extends Cubit<Object?>>(
    RouteSettings settings, {
    required T Function(BuildContext) create,
    required Widget child,
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => BlocProvider<T>(create: create, child: child),
    );
  }
}

/// Arguments classes for routes that require parameters

class CompanyProductsArgs {
  final String companyName;
  final String companyNameAr;

  const CompanyProductsArgs({
    required this.companyName,
    required this.companyNameAr,
  });
}

class CategoryDrugsArgs {
  final String categoryName;
  final Color categoryColor;

  const CategoryDrugsArgs({
    required this.categoryName,
    required this.categoryColor,
  });
}

class DoctorDetailsArgs {
  final String name;
  final String image;
  final String city;
  final String subDescription;
  final String description;
  final String email;
  final String whatsapp;
  final String phone;
  final String linkedin;
  final String instagram;
  final String twitter;
  final String facebook;
  final String youtube;

  const DoctorDetailsArgs({
    required this.name,
    required this.image,
    required this.city,
    required this.subDescription,
    required this.description,
    required this.email,
    required this.whatsapp,
    required this.phone,
    required this.linkedin,
    required this.instagram,
    required this.twitter,
    required this.facebook,
    required this.youtube,
  });
}

class CategoryDoctorsArgs {
  final int categoryId;
  final String? categoryName;

  const CategoryDoctorsArgs({required this.categoryId, this.categoryName});
}

/// 404 Not Found Screen
class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: const Center(
        child: Text('404 - Page Not Found', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
