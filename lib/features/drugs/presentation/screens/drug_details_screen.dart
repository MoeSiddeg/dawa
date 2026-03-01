import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/drug_details_entity.dart';
import '../cubit/drug_details_cubit.dart';
import '../cubit/drug_details_state.dart';

class DrugDetailsScreen extends StatefulWidget {
  final int drugId;

  const DrugDetailsScreen({super.key, required this.drugId});

  @override
  State<DrugDetailsScreen> createState() => _DrugDetailsScreenState();
}

class _DetailFieldData {
  const _DetailFieldData({
    required this.label,
    required this.value,
    this.fullWidth = false,
  });

  final String label;
  final String value;
  final bool fullWidth;
}

class _DrugDetailsScreenState extends State<DrugDetailsScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الدواء'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<DrugDetailsCubit, DrugDetailsState>(
        builder: (context, state) {
          if (state is DrugDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DrugDetailsError) {
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
                    'حدث خطأ',
                    style: AppTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DrugDetailsCubit>().loadDrugDetails(
                        widget.drugId,
                      );
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is DrugDetailsSuccess) {
            return _buildContent(state.drug);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(DrugDetailsEntity drug) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drug Image at the top
          _buildDrugImage(drug),

          // Drug Details Section
          _buildSectionHeader('Drug Details', AppTheme.primaryColor),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildKeyValueTable(_buildDrugDetailsFields(drug)),
          ),

          // Registration Details Section
          _buildSectionHeader('Registration Details', AppTheme.primaryColor),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildKeyValueTable([
                  _DetailFieldData(
                    label: 'Applicant | مقدم الطلب',
                    value: drug.applicant ?? 'غير محدد',
                  ),
                ]),
                const SizedBox(height: 16),
                _buildCompaniesTable(drug.companies ?? []),
                const SizedBox(height: 16),
                _buildKeyValueTable(_buildRegistrationFields(drug)),
              ],
            ),
          ),

          // Generics Section
          _buildSectionHeader('Generics', AppTheme.primaryColor),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildGenericsTable(drug.generics),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDrugImage(DrugDetailsEntity drug) {
    return Container(
      width: double.infinity,
      height: 250,
      color: AppTheme.primaryColor.withValues(alpha: 0.1),
      child:
          drug.image != null && drug.image!.isNotEmpty
              ? CachedNetworkImage(
                imageUrl: drug.image!,
                fit: BoxFit.contain,
                placeholder:
                    (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                errorWidget:
                    (context, url, error) => const Center(
                      child: Icon(
                        Icons.medication,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
              )
              : const Center(
                child: Icon(Icons.medication, size: 100, color: Colors.grey),
              ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: color.withOpacity(0.1),
      child: Text(title, style: AppTheme.heading3.copyWith(color: color)),
    );
  }

  List<_DetailFieldData> _buildDrugDetailsFields(DrugDetailsEntity drug) {
    return [
      _DetailFieldData(label: 'Name | الاسم', value: drug.name ?? 'غير محدد'),
      _DetailFieldData(
        label: 'Product Type | نوع المنتج',
        value: drug.productType ?? 'غير محدد',
      ),
      _DetailFieldData(
        label: 'Dosage Form | الشكل الصيدلي',
        value: drug.dosageForm ?? 'غير محدد',
      ),
      _DetailFieldData(
        label: 'Shelf Life | مدة الصلاحية',
        value: drug.shelfLife ?? 'غير محدد',
      ),
      _DetailFieldData(
        label: 'Route | طريقة الإعطاء',
        value: drug.route ?? 'غير محدد',
      ),
      _DetailFieldData(
        label: 'Strength | التركيز',
        value: drug.strength ?? 'غير محدد',
      ),
      _DetailFieldData(
        label: 'Pack Unit | وحدة التغليف',
        value: drug.packUnit ?? 'غير محدد',
      ),
      _DetailFieldData(
        label: 'Pack Details | تفاصيل التغليف',
        value: drug.packDetails ?? 'غير محدد',
      ),
      _DetailFieldData(label: 'Price | السعر', value: drug.price ?? 'غير محدد'),
      _DetailFieldData(
        label: 'Views Count | عدد المشاهدات',
        value: drug.viewsCount?.toString() ?? 'غير محدد',
      ),
    ];
  }

  List<_DetailFieldData> _buildRegistrationFields(DrugDetailsEntity drug) {
    return [
      _DetailFieldData(
        label: 'Registration No | رقم التسجيل',
        value: drug.registrationNo ?? 'غير محدد',
      ),
      _DetailFieldData(
        label: 'Registration Type | نوع التسجيل',
        value: drug.registrationType ?? 'غير محدد',
      ),
      _DetailFieldData(
        label: 'Marketing Type | نوع التسويق',
        value: drug.marketingType ?? 'غير محدد',
      ),
      _DetailFieldData(
        label: 'License Status | حالة الترخيص',
        value: drug.licenseStatus ?? 'غير محدد',
      ),
      _DetailFieldData(
        label: 'Pricing Status | حالة التسعير',
        value: drug.pricingStatus ?? 'غير محدد',
      ),
      _DetailFieldData(
        label: 'Physical Characters | الخصائص الفيزيائية',
        value: drug.physicalCharacters ?? 'غير محدد',
        fullWidth: true,
      ),
      _DetailFieldData(
        label: 'Storage Conditions | ظروف التخزين',
        value: drug.storageConditions ?? 'غير محدد',
        fullWidth: true,
      ),
      _DetailFieldData(
        label: 'Registration Data | بيانات التسجيل',
        value: drug.registrationData ?? 'غير محدد',
      ),
      _DetailFieldData(
        label: 'Target Species | الأنواع المستهدفة',
        value: drug.targetSpecies ?? 'غير محدد',
        fullWidth: true,
      ),
    ];
  }

  Widget _buildKeyValueTable(List<_DetailFieldData> items) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Table(
        columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.grey.shade300),
        ),
        children: [
          for (final item in items)
            TableRow(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xFFECEFF5),
                  child: Text(
                    item.label,
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Text(item.value, style: AppTheme.bodyMedium),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCompaniesTable(List<CompanyEntity> companies) {
    if (companies.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Text('لا توجد شركات مسجلة'),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: AppTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
          dataTextStyle: AppTheme.bodyMedium,
          headingRowColor: WidgetStateProperty.resolveWith(
            (states) => const Color(0xFFECEFF5),
          ),
          columnSpacing: 32,
          columns: const [
            DataColumn(label: Text('Company name | اسم الشركة')),
            DataColumn(label: Text('Country | الدولة')),
            DataColumn(label: Text('Relation | العلاقة')),
          ],
          rows: [
            for (final company in companies)
              DataRow(
                cells: [
                  DataCell(Text(company.name ?? 'غير محدد')),
                  DataCell(Text(company.countryName ?? 'غير محدد')),
                  DataCell(
                    Text(
                      company.companyMedicineRelation?.name?.ar ??
                          company.companyMedicineRelation?.name?.en ??
                          'غير محدد',
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenericsTable(String? generics) {
    if (generics == null || generics.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Text('لا توجد مواد فعالة مسجلة'),
      );
    }

    // Parse generics string (format: "SUBSTANCE amount unit ;")
    final genericsList =
        generics.split(';').where((g) => g.trim().isNotEmpty).toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: AppTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
          dataTextStyle: AppTheme.bodyMedium,
          headingRowColor: WidgetStateProperty.resolveWith(
            (states) => const Color(0xFFECEFF5),
          ),
          columnSpacing: 32,
          columns: const [
            DataColumn(label: Text('Generic name')),
            DataColumn(label: Text('Strength')),
          ],
          rows: [
            for (final generic in genericsList)
              DataRow(
                cells: [
                  DataCell(Text(_parseGenericName(generic))),
                  DataCell(Text(_parseGenericStrength(generic))),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _parseGenericName(String generic) {
    final parts = generic.trim().split(' ');
    if (parts.isEmpty) return 'غير محدد';
    return parts.first;
  }

  String _parseGenericStrength(String generic) {
    final parts = generic.trim().split(' ');
    if (parts.length < 2) return 'غير محدد';
    return parts.sublist(1).join(' ');
  }
}
