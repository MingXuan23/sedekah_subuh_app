part of 'derma_bloc.dart';

sealed class DermaState extends Equatable {
  const DermaState();
  
  @override
  List<Object> get props => [];
}

final class DermaInitial extends DermaState{}

final class DermaFetched extends DermaState{
  final List<Derma> dermaList;
  final List<String> dermaTypeList;

  DermaFetched({required this.dermaList, required this.dermaTypeList});

 
  @override
  List<Object> get props => [dermaList, dermaTypeList];
}

final class DermaFetchError extends DermaState{
  final String error;

  const DermaFetchError(this.error);

  @override
  List<Object> get props => [error];
}

final class UpdateDermaType extends DermaState{
  final String type;
  const UpdateDermaType(this.type);

  @override
  List<Object> get props => [type];
}