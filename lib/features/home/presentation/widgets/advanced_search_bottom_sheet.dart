import 'package:flutter/material.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/route/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../drugs/presentation/cubit/special_medicine_search_cubit.dart';

class AdvancedSearchBottomSheet extends StatefulWidget {
  const AdvancedSearchBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AdvancedSearchBottomSheet(),
    );
  }

  @override
  State<AdvancedSearchBottomSheet> createState() =>
      _AdvancedSearchBottomSheetState();
}

class _AdvancedSearchBottomSheetState extends State<AdvancedSearchBottomSheet> {
  final _tradeNameController = TextEditingController();
  final _registerNoController = TextEditingController();
  final _applicantNameController = TextEditingController();
  final _genericNameController = TextEditingController();
  final _targetSpeciesController = TextEditingController();
  final _dosageFormController = TextEditingController();
  final _pharmacologicalGroupController = TextEditingController();

  @override
  void dispose() {
    _tradeNameController.dispose();
    _registerNoController.dispose();
    _applicantNameController.dispose();
    _genericNameController.dispose();
    _targetSpeciesController.dispose();
    _dosageFormController.dispose();
    _pharmacologicalGroupController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final cubit = getIt<SpecialMedicineSearchCubit>();
    cubit.search(
      tradeName:
          _tradeNameController.text.trim().isNotEmpty
              ? _tradeNameController.text.trim()
              : null,
      registerNo:
          _registerNoController.text.trim().isNotEmpty
              ? _registerNoController.text.trim()
              : null,
      applicantName:
          _applicantNameController.text.trim().isNotEmpty
              ? _applicantNameController.text.trim()
              : null,
      genericName:
          _genericNameController.text.trim().isNotEmpty
              ? _genericNameController.text.trim()
              : null,
      targetSpecies:
          _targetSpeciesController.text.trim().isNotEmpty
              ? _targetSpeciesController.text.trim()
              : null,
      dosageForm:
          _dosageFormController.text.trim().isNotEmpty
              ? _dosageFormController.text.trim()
              : null,
      pharmacologicalGroup:
          _pharmacologicalGroupController.text.trim().isNotEmpty
              ? _pharmacologicalGroupController.text.trim()
              : null,
    );
    Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.specialMedicineSearch,
      (route) => route.settings.name == Routes.home,
    );
  }

  void _clearFields() {
    _tradeNameController.clear();
    _registerNoController.clear();
    _applicantNameController.clear();
    _genericNameController.clear();
    _targetSpeciesController.clear();
    _dosageFormController.clear();
    _pharmacologicalGroupController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _clearFields,
                  child: const Text('مسح الكل'),
                ),
                Text('بحث متقدم', style: AppTheme.heading2),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchField(
                    controller: _tradeNameController,
                    label: 'Trade Name | الاسم التجارى',
                    hint: 'Enter trade name',
                    icon: Icons.medication,
                  ),
                  const SizedBox(height: 16),

                  _buildSearchField(
                    controller: _registerNoController,
                    label: 'Reg No | رقم التسجيل',
                    hint: 'Enter registration number',
                    icon: Icons.confirmation_number,
                  ),
                  const SizedBox(height: 16),

                  _buildSearchField(
                    controller: _applicantNameController,
                    label: 'Applicant Name | الشركة المنتجة أو المستوردة',
                    hint: 'Enter applicant name',
                    icon: Icons.business_center,
                  ),
                  const SizedBox(height: 16),

                  _buildSearchField(
                    controller: _genericNameController,
                    label: 'Generic Name | المادة الفعالة',
                    hint: 'Enter generic name',
                    icon: Icons.science,
                  ),
                  const SizedBox(height: 16),

                  _buildSearchField(
                    controller: _targetSpeciesController,
                    label: 'Target Species | الأنواع المستهدفة',
                    hint: 'Enter target species',
                    icon: Icons.pets,
                  ),
                  const SizedBox(height: 16),

                  _buildSearchField(
                    controller: _dosageFormController,
                    label: 'Dosage Form | الشكل الصيدلى',
                    hint: 'Enter dosage form',
                    icon: Icons.medical_services,
                  ),
                  const SizedBox(height: 16),

                  _buildSearchField(
                    controller: _pharmacologicalGroupController,
                    label: 'Pharmacological Group | المجموعات الدوائية',
                    hint: 'Enter pharmacological group',
                    icon: Icons.category,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _performSearch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'بحث',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.bodyLarge),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppTheme.primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
