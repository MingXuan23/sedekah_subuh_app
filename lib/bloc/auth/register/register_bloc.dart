import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prim_derma_app/models/user.dart';
import 'package:prim_derma_app/repo/user_repo.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepo repo;

  RegisterBloc(this.repo) : super(RegisterInitial()) {
    on<ResetRegisterState>((event, emit) => emit(RegisterInitial()));

    on<RegisterRequested>((event, emit) async {
      emit(RegisterLoading());
      final (success, message) = await repo.userRegister(
        name: event.name,
        email: event.email,
        icno: event.icno,
        telno: event.telno,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
      );

      if (success) {
        final identifier =
            event.email.isEmpty ? event.icno.replaceAll('-', '') : event.email;
        await User.saveEmail(identifier);
        emit(RegisterSuccess(message));
      } else if (message == 'Please check your connection') {
        emit(RegisterWithoutNetwork());
      } else {
        emit(RegisterFailure(message));
      }
    });
  }
}
