import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prim_derma_app/models/user.dart';
import 'package:prim_derma_app/repo/env_variable.dart';
import 'package:prim_derma_app/repo/user_repo.dart';
import 'package:equatable/equatable.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepo repo;

  LoginBloc(LoginState loginInitial, this.repo) : super(loginInitial) {
    on<ResetLoginState>(
      (event, emit) {
        emit(LoginInitial());
      },
    );
    on<LoginRequested>((event, emit) async {
      emit(LoginLoading());
      // emit(LoginSuccess());
      var response = await repo.userLogin(event.email, event.password);
      if (response.$1 == null) {
        if (response.$2 == "Please check your connection") {
          emit(LoginWithoutNetwork());
        } else {
          emit(LoginFailure(response.$2));
          // emit(LoginInitial());
        }

        return;
      } else {
        var user = response.$1!;
        await Future.wait([
          User.saveToken(user.token ?? ""),
          User.saveEmail(event.email),
        ]);
        emit(LoginSuccess());
        return;
      }
    });

    on<AutoLogin>(
      (event, emit) async {
        if (!await validateEnvironment()) {
          emit(LoginWithoutNetwork());
          return;
        }
        var token = await User.retrieveToken();
        if (token == null) {
          emit(LoginFailureWithoutError());
          return;
        }
        var response = await repo.validateToken(token);
        if (response == 0) {
          emit(LoginWithoutNetwork());
        } else if (response == 200) {
          emit(LoginSuccess());
        } else {
          emit(const LoginFailure('Sesi Anda Telah Tamat. Sila Login Sekali'));
        }
      },
    );

    on<LogoutRequested>(
      (event, emit) async {
        await User.logout();
        emit(LoginFailureWithoutError());
      },
    );
  }
}
