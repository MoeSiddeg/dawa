import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/route/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ads_widget.dart';
import '../../../doctors/domain/entities/doctor_entity.dart';
import '../../../doctors/presentation/cubit/doctors_cubit.dart';
import '../../../doctors/presentation/cubit/doctors_state.dart';

class ConsultantScreen extends StatefulWidget {
  const ConsultantScreen({super.key});

  @override
  State<ConsultantScreen> createState() => _ConsultantScreenState();
}

class _ConsultantScreenState extends State<ConsultantScreen> {
  late final DoctorsCubit _doctorsCubit;

  @override
  void initState() {
    super.initState();
    _doctorsCubit = getIt<DoctorsCubit>()..loadDoctorsByCategories();
  }

  @override
  void dispose() {
    _doctorsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<DoctorsCubit, DoctorsState>(
        bloc: _doctorsCubit,
        builder: (context, state) {
          if (state is DoctorsLoading || state is DoctorsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DoctorsError) {
            return _buildError(state.message);
          }

          if (state is DoctorsEmpty) {
            return _buildEmpty();
          }

          if (state is DoctorsByCategorySuccess) {
            return _buildCategoriesView(state.categories);
          }

          final doctors =
              state is DoctorsSuccess ? state.doctors : <DoctorEntity>[];

          return RefreshIndicator(
            onRefresh: _doctorsCubit.refresh,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الاستشاريين',
                    style: AppTheme.heading1.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 16),
                  const AdsWidget(),
                  const SizedBox(height: 24),
                  Text('الأطباء المتاحين', style: AppTheme.heading2),
                  const SizedBox(height: 12),
                  ...doctors.map((doctor) => _DoctorCard(doctor: doctor)),
                  if (state is DoctorsSuccess && state.hasMore)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ElevatedButton(
                          onPressed: _doctorsCubit.loadMore,
                          child: const Text('تحميل المزيد'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoriesView(List<DoctorCategoryWithDoctors> categories) {
    return RefreshIndicator(
      onRefresh: _doctorsCubit.refresh,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الاستشاريين',
              style: AppTheme.heading1.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 16),
            const AdsWidget(),
            const SizedBox(height: 24),
            ...categories.map(
              (categoryWithDoctors) =>
                  _buildCategorySection(categoryWithDoctors),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(DoctorCategoryWithDoctors categoryWithDoctors) {
    final category = categoryWithDoctors.category;
    final doctors = categoryWithDoctors.doctors;

    if (doctors.isEmpty) return const SizedBox.shrink();

    final displayDoctors = doctors.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category.name ?? 'غير محدد', style: AppTheme.heading2),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.categoryDoctors,
                  arguments: CategoryDoctorsArgs(
                    categoryId: category.id,
                    categoryName: category.name,
                  ),
                );
              },
              child: Text(
                'مشاهدة الكل',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...displayDoctors.map((doctor) => _DoctorCard(doctor: doctor)),
        const SizedBox(height: 24),
      ],
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
              onPressed: _doctorsCubit.loadDoctorsByCategories,
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
            Icon(Icons.person_off, size: 64, color: AppTheme.textTertiary),
            const SizedBox(height: 16),
            Text(
              'لا يوجد أطباء متاحين حالياً',
              style: AppTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({required this.doctor});

  final DoctorEntity doctor;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/doctor-details', arguments: doctor.id);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppTheme.primaryColor,
                  size: 42,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name ?? 'غير محدد',
                      style: AppTheme.heading3.copyWith(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (doctor.jobTitle != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        doctor.jobTitle!,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (doctor.email != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        doctor.email!,
                        style: AppTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (doctor.mobile != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 16,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              doctor.mobile!,
                              style: AppTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
