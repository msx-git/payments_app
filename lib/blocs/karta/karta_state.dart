
part of 'karta_bloc.dart';

sealed class KartaState {}

final class InitialKartasState extends KartaState {}

final class LoadingKartasState extends KartaState {}

final class LoadedKartasState extends KartaState {
  final List<Karta> cards;

  LoadedKartasState({required this.cards});
}

final class ErrorKartasState extends KartaState {
  final String errorMessage;

  ErrorKartasState({required this.errorMessage});
}
