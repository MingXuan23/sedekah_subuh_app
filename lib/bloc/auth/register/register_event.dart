part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object> get props => [];
}

class RegisterRequested extends RegisterEvent {
  final String name, email, icno, telno, password, passwordConfirmation;

  const RegisterRequested({
    required this.name,
    required this.email,
    required this.icno,
    required this.telno,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object> get props =>
      [name, email, icno, telno, password, passwordConfirmation];
}

class ResetRegisterState extends RegisterEvent {}
