class DoctorEntity {
  final int id;
  final String? name;
  final String? alias;
  final String? jobTitle;
  final String? description;
  final String? email;
  final String? phone;
  final String? mobile;
  final String? governorateName;
  final List<SocialLinkEntity> socials;

  const DoctorEntity({
    required this.id,
    this.name,
    this.alias,
    this.jobTitle,
    this.description,
    this.email,
    this.phone,
    this.mobile,
    this.governorateName,
    this.socials = const [],
  });
}

class SocialLinkEntity {
  final String? platform;
  final String? url;

  const SocialLinkEntity({this.platform, this.url});
}
