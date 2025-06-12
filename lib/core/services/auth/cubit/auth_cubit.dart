// lib/bloc/auth_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligenz/core/services/auth/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final isLoggedIn = await authRepository.isLoggedIn();
    debugPrint('User is logged in: $isLoggedIn');
    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> login(String url, String email, String password) async {
    emit(AuthLoading());
    try {
      await authRepository.setUrl(url);
      await authRepository.login(email, password);
      emit(Authenticated());
    } catch (ex) {
      debugPrint('Login error: $ex');
      emit(AuthError('Login failed'));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await authRepository.logout();
    debugPrint('User logged out');
    emit(Unauthenticated());
  }
}
