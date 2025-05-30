part of 'users_bloc.dart';

@immutable
sealed class UsersState {}

class UsersInitial extends UsersState {}

class UserLoaded extends UsersState {
  final List<User> users;
  UserLoaded(this.users);
}

class LoginSuccess extends UsersState {
  final User user;
  LoginSuccess(this.user);

}

class LoginFailure extends UsersState {
  final String message;
  LoginFailure(this.message);
}
class UserAddedSuccess extends UsersState {}

class UserExportedSuccess extends UsersState {}


class UsersError extends UsersState {
  final String message;
  UsersError(this.message);
}
