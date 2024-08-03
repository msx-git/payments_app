part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  LoginEvent({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });
}

final class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  RegisterEvent({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });
}

final class LogoutEvent extends AuthEvent {}

final class CheckTokenExpiryEvent extends AuthEvent {}

final class SendResetPasswordEvent extends AuthEvent {
  final String email;

  SendResetPasswordEvent(this.email);
}
