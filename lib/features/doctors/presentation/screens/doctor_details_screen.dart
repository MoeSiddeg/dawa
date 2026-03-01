import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ads_widget.dart';
import '../../domain/entities/doctor_entity.dart';
import '../cubit/doctor_details_cubit.dart';
import '../cubit/doctor_details_state.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final int doctorId;

  const DoctorDetailsScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطبيب')),
      body: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
        builder: (context, state) {
          if (state is DoctorDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DoctorDetailsError) {
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
                    state.message,
                    style: AppTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DoctorDetailsCubit>().loadDoctorDetails(
                        doctorId,
                      );
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is DoctorDetailsSuccess) {
            return _buildContent(context, state.doctor);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, DoctorEntity doctor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Image and Basic Info
          SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildImagePlaceholder(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(doctor.name ?? 'غير محدد', style: AppTheme.heading1),
          const SizedBox(height: 8),
          if (doctor.governorateName != null)
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 4),
                Text(doctor.governorateName!, style: AppTheme.bodyMedium),
              ],
            ),
          const SizedBox(height: 8),
          if (doctor.jobTitle != null)
            Text(doctor.jobTitle!, style: AppTheme.bodySmall),
          const SizedBox(height: 32),

          // Description
          if (doctor.description != null && doctor.description!.isNotEmpty) ...[
            Text('الوصف', style: AppTheme.heading2),
            const SizedBox(height: 12),
            Text(
              doctor.description!,
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 32),
          ],

          // Contact Information
          Text('معلومات التواصل', style: AppTheme.heading2),
          const SizedBox(height: 16),

          // Email
          if (doctor.email != null && doctor.email!.isNotEmpty)
            _buildContactItem(
              icon: Icons.email_outlined,
              title: 'البريد الإلكتروني',
              value: doctor.email!,
              onTap: () => _launchUrl('mailto:${doctor.email}'),
            ),

          // Mobile
          if (doctor.mobile != null && doctor.mobile!.isNotEmpty)
            _buildContactItem(
              icon: FontAwesomeIcons.whatsapp,
              title: 'الجوال',
              value: doctor.mobile!,
              onTap: () => _launchUrl('tel:${doctor.mobile}'),
            ),

          // Phone
          if (doctor.phone != null && doctor.phone!.isNotEmpty)
            _buildContactItem(
              icon: Icons.phone_outlined,
              title: 'الهاتف',
              value: doctor.phone!,
              onTap: () => _launchUrl('tel:${doctor.phone}'),
            ),

          if (doctor.socials.isNotEmpty) ...[
            const SizedBox(height: 32),
            Text('وسائل التواصل الاجتماعي', style: AppTheme.heading2),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    doctor.socials.map((social) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _buildSocialButton(
                          icon: _getSocialIcon(social.platform),
                          onTap: () {
                            if (social.url != null) _launchUrl(social.url!);
                          },
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],

          const SizedBox(height: 32),
          const AdsWidget(),
        ],
      ),
    );
  }

  IconData _getSocialIcon(String? platform) {
    switch (platform?.toLowerCase()) {
      case 'facebook':
        return FontAwesomeIcons.facebook;
      case 'youtube':
        return FontAwesomeIcons.youtube;
      case 'linkedin':
        return FontAwesomeIcons.linkedin;
      case 'instagram':
        return FontAwesomeIcons.instagram;
      case 'twitter':
      case 'x':
        return FontAwesomeIcons.twitter;
      case 'whatsapp':
        return FontAwesomeIcons.whatsapp;
      default:
        return FontAwesomeIcons.link;
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppTheme.primaryColor.withValues(alpha: 0.1),
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 80, color: AppTheme.primaryColor),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title, style: AppTheme.bodyLarge),
        subtitle: Text(value, style: AppTheme.bodyMedium),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 24),
      ),
    );
  }
}
