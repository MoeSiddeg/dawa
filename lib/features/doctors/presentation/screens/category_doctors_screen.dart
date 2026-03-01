import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/doctor_entity.dart';
import '../cubit/category_doctors_cubit.dart';
import '../cubit/category_doctors_state.dart';

class CategoryDoctorsScreen extends StatefulWidget {
  final int initialCategoryId;
  final String? initialCategoryName;

  const CategoryDoctorsScreen({
    super.key,
    required this.initialCategoryId,
    this.initialCategoryName,
  });

  @override
  State<CategoryDoctorsScreen> createState() => _CategoryDoctorsScreenState();
}

class _CategoryDoctorsScreenState extends State<CategoryDoctorsScreen> {
  late final CategoryDoctorsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit =
        getIt<CategoryDoctorsCubit>()
          ..loadCategories(initialCategoryId: widget.initialCategoryId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الأطباء',
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
      body: BlocBuilder<CategoryDoctorsCubit, CategoryDoctorsState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state is CategoryDoctorsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CategoryDoctorsError) {
            return _buildError(state.message);
          }

          if (state is CategoryDoctorsSuccess) {
            return _buildContent(state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(CategoryDoctorsSuccess state) {
    return Column(
      children: [
        // Category Dropdown
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<int>(
            value: state.selectedCategoryId,
            decoration: InputDecoration(
              labelText: 'اختر التخصص',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items:
                state.categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name ?? 'غير محدد'),
                  );
                }).toList(),
            onChanged: (categoryId) {
              if (categoryId != null) {
                _cubit.selectCategory(categoryId);
              }
            },
          ),
        ),
        // Doctors List
        Expanded(
          child:
              state.doctors.isEmpty
                  ? _buildEmpty()
                  : RefreshIndicator(
                    onRefresh: () => _cubit.refresh(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.doctors.length,
                      itemBuilder: (context, index) {
                        return _DoctorCard(doctor: state.doctors[index]);
                      },
                    ),
                  ),
        ),
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
              onPressed:
                  () => _cubit.loadCategories(
                    initialCategoryId: widget.initialCategoryId,
                  ),
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
              'لا يوجد أطباء في هذا التخصص',
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
                    if (doctor.governorateName != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            doctor.governorateName!,
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
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
