import '../../../../core/networking/api_result.dart';
import '../../data/models/most_viewed_medicines_response.dart';

abstract class MostViewedMedicinesRepository {
  Future<ApiResult<MostViewedMedicinesResponse>> getMostViewedMedicines();
}
