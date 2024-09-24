part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class KeepUserSignedIn extends LoginEvent {}

class LoginRequested extends LoginEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AutoLogin extends LoginEvent {}

class ResetLoginState extends LoginEvent {}

class LogoutRequested extends LoginEvent {}


