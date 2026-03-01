class MostViewedMedicineEntity {
  final int id;
  final String? name;
  final String? alias;
  final String? registrationNo;
  final String? tradeName;
  final String? applicant;
  final String? generics;
  final String? price;
  final String? image;
  final bool isFavorited;
  final String? dosageForm;

  const MostViewedMedicineEntity({
    required this.id,
    this.name,
    this.alias,
    this.registrationNo,
    this.tradeName,
    this.applicant,
    this.generics,
    this.price,
    this.image,
    this.isFavorited = false,
    this.dosageForm,
  });
}
