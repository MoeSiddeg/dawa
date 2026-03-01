import '../../domain/entities/user_profile_entity.dart';

abstract class UserProfileState {
  const UserProfileState();
}

class UserProfileInitial extends UserProfileState {
  const UserProfileInitial();
}

class UserProfileLoading extends UserProfileState {
  const UserProfileLoading();
}

class UserProfileSuccess extends UserProfileState {
  final UserProfileEntity profile;

  const UserProfileSuccess(this.profile);
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);
}

class UserProfileUpdating extends UserProfileState {
  const UserProfileUpdating();
}

class UserProfileUpdateSuccess extends UserProfileState {
  final String message;

  const UserProfileUpdateSuccess(this.message);
}

class UserProfileUpdateError extends UserProfileState {
  final String message;

  const UserProfileUpdateError(this.message);
}
