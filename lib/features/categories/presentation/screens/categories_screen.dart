import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import 'category_drugs_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('المجموعات الدوائية')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildCategorySection(
              context,
              'Antibiotics - المضادات الحيوية',
              Icons.medication,
              AppTheme.primaryColor,
              [
                'Penicillins - البنسلينات',
                'Aminoglycosides - الأمينوجليكوزيدات',
                'Chloramphenicols - الكلورامفينيكول',
                'Thiamphenicol',
                'Lincosamides',
                'Macrolides',
                'Polymyxins',
                'Quinolones',
                'Tetracyclines',
                'Sulphonamides - السلفوناميدات',
                'Cephalosporins - السيفالوسبورينات',
                'Misc. Antibiotics',
              ],
            ),
            const SizedBox(height: 16),
            _buildCategorySection(
              context,
              'Anticoccidials - مضادات الكوكسيديا',
              Icons.bug_report,
              const Color(0xFFEC4899),
              [
                'Amprolium',
                'Clopidol',
                'Diclazuril',
                'Toltrazuril',
                'Salinomycin',
                'Maduramicin',
                'Misc. Anticoccidials',
              ],
            ),
            const SizedBox(height: 16),
            _buildCategorySection(
              context,
              'Anthelmintics - مضادات الديدان',
              Icons.pest_control,
              const Color(0xFF8B5CF6),
              [
                'Albendazole',
                'Fenbendazole',
                'Flubendazole',
                'Ivermectin',
                'Levamisole',
                'Nitroxynil',
                'Rafoxanide',
                'Oxyclozanide',
                'Pierazine',
                'Pyrantel',
                'Tetramisole',
                'Triclabendazole',
                'Ricobendazole',
              ],
            ),
            const SizedBox(height: 16),
            _buildCategorySection(
              context,
              'Anti Blood Parasites - مضادات طفيليات الدم',
              Icons.bloodtype,
              const Color(0xFFEF4444),
              [
                'Buparvaquone',
                'Imidocarb Dipropionate',
                'Diminazine Aceturate',
                'Quinapyramine Sulphate',
              ],
            ),
            const SizedBox(height: 16),
            _buildCategorySection(
              context,
              'Analgesics & Anti-inflammatory - المسكنات',
              Icons.healing,
              const Color(0xFFF59E0B),
              [
                'Analgin & Dipyrone',
                'Dexamethasone',
                'Diclofenac Sodium',
                'Flunixin Meglumine',
                'Ketoprofen',
                'Phenyl Butazone',
                'Morprofen',
              ],
            ),
            const SizedBox(height: 16),
            _buildCategorySection(
              context,
              'Vitamins - الفيتامينات',
              Icons.health_and_safety,
              AppTheme.secondaryColor,
              [
                'Vitamin A, D3 & E',
                'Vitamin B, K & Choline',
                'Vitamin C',
                'Vitamin E & Selenium',
                'Vitamin K',
                'Vitamin Mixtures',
              ],
            ),
            const SizedBox(height: 16),
            _buildCategorySection(
              context,
              'Minerals & Trace Elements - المعادن',
              Icons.science,
              const Color(0xFF06B6D4),
              [
                'Phosphorus',
                'Copper',
                'Iron',
                'Manganese',
                'Zinc',
                'Minerals Mixtures',
              ],
            ),
            const SizedBox(height: 16),
            _buildCategorySection(
              context,
              'Vaccines - اللقاحات',
              Icons.vaccines,
              const Color(0xFF10B981),
              [
                'Newcastle Disease Vaccines',
                'Infectious Bronchitis (IB)',
                'Infectious Laryngotracheitis (ILT)',
                'Gumboro Vaccines',
                'Pox Vaccines',
                'Avian Influenza Vaccines',
                'Mycoplasma Vaccines',
                'Marek\'s Vaccines',
                'Reo Vaccines',
                'Lumpy Skin Disease Vaccines',
              ],
            ),
            const SizedBox(height: 16),
            _buildCategorySection(
              context,
              'Miscellaneous - متنوعات',
              Icons.category,
              const Color(0xFF6366F1),
              [
                'Digestive System Therapeutics',
                'Anti Mastitis Drugs',
                'Anti Mycotoxins',
                'Fluid Therapy Solutions',
                'Immune Stimulants',
                'Disinfectants - المطهرات',
                'Hormones - الهرمونات',
                'Antiseptics - المطهرات الموضعية',
                'Antivirals - مضادات الفيروسات',
                'Tonics - المقويات',
              ],
            ),
            const SizedBox(height: 16),
            _buildCategorySection(
              context,
              'Feed & Water Additives - إضافات الأعلاف',
              Icons.grass,
              const Color(0xFF84CC16),
              [
                'Feed Additives',
                'Water Additives',
                'Fatty Acids',
                'Metabolic Enhancers',
                'Yeast',
              ],
            ),
            const SizedBox(height: 16),
            _buildCategorySection(
              context,
              'Pet Animal Drugs - أدوية الحيوانات الأليفة',
              Icons.pets,
              const Color(0xFFF97316),
              ['Pet Medications', 'Pet Supplements'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<String> subcategories,
  ) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: AppTheme.heading3.copyWith(fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => CategoryDrugsScreen(
                    categoryName: title,
                    categoryColor: color,
                  ),
            ),
          );
        },
      ),
    );
  }
}
