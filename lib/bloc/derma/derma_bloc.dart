

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prim_derma_app/models/derma.dart';
import 'package:prim_derma_app/repo/derma_repo.dart';

import 'package:equatable/equatable.dart';
part 'derma_event.dart';
part 'derma_state.dart';

class DermaBloc extends Bloc<DermaEvent, DermaState> {
  DermaRepo repo;

  DermaBloc(DermaState dermaInitial, this.repo) : super(dermaInitial) {

    on<RequestDermaList>((event,emit) async{
      var donations = await repo.getDerma();
      var typeList =  donations.map((e)=>e.donationType).toSet().toList();
      emit(DermaFetched(dermaList: donations, dermaTypeList: typeList));
    });
    on<SelectDermaType>((event,emit) async{
      
      emit(UpdateDermaType(event.type));
    });
    // on<LoginRequested>((event, emit) async {
    //   emit(LoginLoading());

    //  await Future.delayed(Duration(seconds:3 ));
    //  emit(LoginSuccess());
      // try {
      //   final bool success = true;
      //   if (success) {
      //     emit(LoginSuccess());
      //   } else {
      //     emit(LoginFailure('Login failed'));
      //   }
      // } catch (error) {
      //   emit(LoginFailure(error.toString().replaceAll('Exception: ', '')));
      // }
    //});
  }
}
