import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/base_repository.dart';
import '../../domain/repositories/most_viewed_medicines_repository.dart';
import '../models/most_viewed_medicines_response.dart';

class MostViewedMedicinesRepositoryImpl extends BaseRepository
    implements MostViewedMedicinesRepository {
  final ApiService _apiService;

  MostViewedMedicinesRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<MostViewedMedicinesResponse>> getMostViewedMedicines() {
    return executeApiCall<
      MostViewedMedicinesResponse,
      MostViewedMedicinesResponse
    >(() => _apiService.getMostViewedMedicines());
  }
}
