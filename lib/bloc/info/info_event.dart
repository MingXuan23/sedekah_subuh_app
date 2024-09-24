part of 'info_bloc.dart';

sealed class InfoEvent extends Equatable {
  const InfoEvent();

  @override
  List<Object> get props => [];
}

class requestInfoData extends InfoEvent {}


// class LoginRequested extends TemplateEvent {
//   final String email;
//   final String password;

//   const LoginRequested({
//     required this.email,
//     required this.password,
//   });

//   @override
//   List<Object> get props => [email, password];
// }



