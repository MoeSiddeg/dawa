import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class CategoryDrugsScreen extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;

  const CategoryDrugsScreen({
    super.key,
    required this.categoryName,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data - في التطبيق الحقيقي سيتم جلبها من API
    final drugs = List.generate(
      20,
      (index) => {
        'nameAr': 'دواء ${index + 1}',
        'nameEn': 'Drug ${index + 1}',
        'company': 'شركة ${(index % 3) + 1}',
        'category': categoryName,
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text(categoryName), backgroundColor: categoryColor),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter product name',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Sorting and Count
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.grey.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Showing 1-${drugs.length} of ${drugs.length} results',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                  DropdownButton<String>(
                    value: 'Default sorting',
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'Default sorting',
                        child: Text('Default sorting'),
                      ),
                      DropdownMenuItem(
                        value: 'Name',
                        child: Text('Sort by name'),
                      ),
                      DropdownMenuItem(
                        value: 'Price',
                        child: Text('Sort by price'),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
            // Drugs Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: drugs.length,
                  itemBuilder: (context, index) {
                    final drug = drugs[index];
                    return _buildDrugCard(
                      context,
                      drug['nameAr']!,
                      drug['nameEn']!,
                      drug['company']!,
                      categoryColor,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrugCard(
    BuildContext context,
    String nameAr,
    String nameEn,
    String company,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.secondaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drug Image with white background
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
              child: Icon(Icons.medication, size: 60, color: color),
            ),
          ),
          // Drug Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Drug Name Arabic
                Text(
                  nameAr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Read more button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/drug-details');
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3F4F6),
                      foregroundColor: AppTheme.textSecondary,
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text('Read more', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
