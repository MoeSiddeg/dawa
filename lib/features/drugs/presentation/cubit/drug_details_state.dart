import '../../domain/entities/drug_details_entity.dart';

sealed class DrugDetailsState {
  const DrugDetailsState();
}

class DrugDetailsInitial extends DrugDetailsState {
  const DrugDetailsInitial();
}

class DrugDetailsLoading extends DrugDetailsState {
  const DrugDetailsLoading();
}

class DrugDetailsSuccess extends DrugDetailsState {
  final DrugDetailsEntity drug;

  const DrugDetailsSuccess(this.drug);
}

class DrugDetailsError extends DrugDetailsState {
  final String message;

  const DrugDetailsError(this.message);
}
