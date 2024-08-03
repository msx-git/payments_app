import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payments_app/data/repositories/karta_repository.dart';

import '../../data/models/karta.dart';

part 'karta_event.dart';
part 'karta_state.dart';

class KartaBloc extends Bloc<KartaEvent, KartaState> {
  final KartaRepository _kartaRepository;

  KartaBloc({required KartaRepository kartaRepository})
      : _kartaRepository = kartaRepository,
        super(InitialKartasState()) {
    on<GetKartasEvent>(_getEvents);
  }

  void _getEvents(GetKartasEvent event, Emitter<KartaState> emit) async {
    emit(LoadingKartasState());
    try {
      // debugPrint("BEFORE LIST EVENTS:");
      final List<Karta> cards = await _kartaRepository.fetchCards();
      // debugPrint("LIST EVENTS: $cards");
      emit(LoadedKartasState(cards: cards));
    } catch (e) {
      emit(ErrorKartasState(errorMessage: e.toString()));
    }
  }
}
