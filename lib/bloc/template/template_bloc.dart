import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prim_derma_app/models/user.dart';
import 'package:prim_derma_app/repo/env_variable.dart';
import 'package:prim_derma_app/repo/user_repo.dart';
import 'package:equatable/equatable.dart';
part 'template_event.dart';
part 'template_state.dart';

class TemplateBloc extends Bloc<TemplateEvent, TemplateState> {
  UserRepo repo;

  TemplateBloc(TemplateState loginInitial, this.repo) : super(loginInitial) {
    on<ExampleEvent>(
      (event, emit) {
        emit(TemplateInitial());
      },
    );
    
  }
}
