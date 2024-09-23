part of 'phone_cubit.dart';

@immutable
sealed class PhoneState {}

final class PhoneInitial extends PhoneState {}

class isLoading extends PhoneState {}

class ErrorIsOcurred extends PhoneState {
  final String errorMsg;
  ErrorIsOcurred({
    required this.errorMsg,
  });
}

class PhoneNumberSubmitted extends PhoneState {}

class PhoneOtpVerified extends PhoneState {}
