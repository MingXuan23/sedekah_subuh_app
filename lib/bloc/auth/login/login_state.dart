part of 'login_bloc.dart';

sealed class LoginState{
  const LoginState();
  
 
}

final class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object> get props => [error];
}

class LoginFailureWithoutError extends LoginState{}

class LoginWithoutNetwork extends LoginState{}

class LogoutSuccess extends LoginState{}