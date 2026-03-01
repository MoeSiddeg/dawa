import '../../domain/entities/most_viewed_medicine_entity.dart';

sealed class MostViewedMedicinesState {
  const MostViewedMedicinesState();
}

class MostViewedMedicinesInitial extends MostViewedMedicinesState {
  const MostViewedMedicinesInitial();
}

class MostViewedMedicinesLoading extends MostViewedMedicinesState {
  const MostViewedMedicinesLoading();
}

class MostViewedMedicinesSuccess extends MostViewedMedicinesState {
  final List<MostViewedMedicineEntity> medicines;

  const MostViewedMedicinesSuccess(this.medicines);
}

class MostViewedMedicinesEmpty extends MostViewedMedicinesState {
  const MostViewedMedicinesEmpty();
}

class MostViewedMedicinesError extends MostViewedMedicinesState {
  final String message;

  const MostViewedMedicinesError(this.message);
}
