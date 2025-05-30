part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}
class AddUserEvent extends UsersEvent {
  final User user;
  AddUserEvent(this.user);
}

class LoadUsersEvent extends UsersEvent {}

class LoginEvent extends UsersEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}