import '../../domain/entities/ad_entity.dart';

sealed class AdsState {
  const AdsState();
}

class AdsInitial extends AdsState {
  const AdsInitial();
}

class AdsLoading extends AdsState {
  const AdsLoading();
}

class AdsSuccess extends AdsState {
  final List<AdEntity> ads;
  const AdsSuccess(this.ads);
}

class AdsEmpty extends AdsState {
  const AdsEmpty();
}

class AdsError extends AdsState {
  final String message;
  const AdsError(this.message);
}
