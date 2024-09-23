part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class Loading extends AuthState{}


class ErrorOcurred extends AuthState {
  final String errMsg;

  ErrorOcurred({required this.errMsg});

}

class Submitted extends AuthState{}

class SuccessfullyLoggedIn extends AuthState{}

class SuccessfullyLinked extends AuthState{}