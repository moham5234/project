import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../Models/model_user.dart';
import '../sqlite.dart';

part 'users_event.dart';
part 'users_state.dart';


class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UserService userService;

  UsersBloc(this.userService) : super(UsersInitial()) {
    on<AddUserEvent>((event, emit) async {
      await userService.insertUser(event.user);
      emit(UserAddedSuccess());
      await Future.delayed(Duration(milliseconds: 500));
      add(LoadUsersEvent());
    });

    on<LoadUsersEvent>((event, emit) async {
      emit(UsersInitial());
      final users = await userService.getUsers();
      emit(UserLoaded(users));
    });

    on<LoginEvent>((event, emit) async {
      final users = await userService.getUsers();
      final user = users.firstWhere(
            (u) => u.email == event.email && u.password == event.password,
        orElse: () => User(name: '', email: '', password: '', type: ''),
      );

      if (user.name.isNotEmpty) {
        emit(LoginSuccess(user));
      } else {
        emit(LoginFailure('فشل في تسجيل الدخول'));
      }
    });
  }
}
