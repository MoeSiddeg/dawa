import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

class CompanyCardWidget extends StatelessWidget {
  final String name;
  final String displayName;
  final String location;
  final dynamic logo;
  final VoidCallback onTap;

  const CompanyCardWidget({
    super.key,
    required this.name,
    required this.displayName,
    required this.location,
    required this.logo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locationText =
        location.isNotEmpty ? location.split(',').first : 'لا يوجد عنوان';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipOval(
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: _buildCompanyLogo(logo),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5F),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                name,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 12,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      locationText,
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 30,
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyLogo(dynamic logo) {
    if (logo is String && logo.isNotEmpty) {
      return Image.network(
        logo,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallbackLogo(),
      );
    }

    if (logo is IconData) {
      return Container(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        child: Icon(logo, size: 35, color: AppTheme.primaryColor),
      );
    }

    return _fallbackLogo();
  }

  Widget _fallbackLogo() {
    return Container(
      color: AppTheme.primaryColor.withValues(alpha: 0.1),
      child: const Icon(Icons.business, color: AppTheme.primaryColor, size: 35),
    );
  }
}
