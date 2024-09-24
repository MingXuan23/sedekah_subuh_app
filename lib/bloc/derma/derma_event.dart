
part of 'derma_bloc.dart';


sealed class DermaEvent extends Equatable {
  const DermaEvent();

  @override
  List<Object> get props => [];
}

class RequestDermaList extends DermaEvent{}

class SelectDermaType extends DermaEvent{
  final String type;

  SelectDermaType({required this.type});
  @override
  List<Object> get props => [type];
}