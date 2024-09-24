import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prim_derma_app/models/user.dart';
import 'package:prim_derma_app/repo/info_repo.dart';

import 'package:equatable/equatable.dart';
part 'info_event.dart';
part 'info_state.dart';

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  InfoRepo repo;

  InfoBloc(InfoState loginInitial, this.repo) : super(loginInitial) {
    on<requestInfoData>(
      (event, emit) async{
        emit(InfoLoading());

        var token =  await User.retrieveToken();
        if(token == null){
          emit(InfoMismatchToken());
          return;
        }
        var result = await repo.getDermaInfo(token!);

        if(result ==null){
          emit(InfoMismatchToken());
          return;

        }

        emit(InfoFetched(result));


      },
    );
    
  }
}
