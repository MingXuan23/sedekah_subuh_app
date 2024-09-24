part of 'info_bloc.dart';

sealed class InfoState {
  const InfoState();
}

final class InfoInitial extends InfoState {}

final class InfoMissingCode extends InfoState {}

final class InfoFetched extends InfoState {
  final String code;
  const InfoFetched(this.code);
  @override
  List<Object> get props => [code];
}

final class InfoFailure extends InfoState {
  final String error;

  const InfoFailure(this.error);

  @override
  List<Object> get props => [error];
}

final class InfoLoading extends InfoState {}

final class InfoMismatchToken extends InfoState {}


// class ExampleState extends TemplateState {
//   final String error;

//   const ExampleState(this.error);

//   @override
//   List<Object> get props => [error];
// }

