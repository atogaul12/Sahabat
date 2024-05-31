import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../repositories/auth_repo.dart';
import '../../repositories/user_repo.dart'; // Tambahkan ini

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  final _repo = AuthRepo();
  final _userRepo = UserRepo(); // Tambahkan ini

  void login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await _repo.login(email: email, password: password);
      bool isProfileComplete = await _userRepo.isProfileComplete();
      if (isProfileComplete) {
        emit(LoginSuccess('Login berhasil!'));
      } else {
        emit(LoginCompleteProfile());
      }
    } catch (e) {
      print(e);
      emit(LoginFailure(e.toString()));
    }
  }
}
