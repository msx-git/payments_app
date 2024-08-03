import '../models/karta.dart';
import '../services/firebase_karta_service.dart';

class KartaRepository {
  final FirebaseKartaService _firebaseKartaService;

  KartaRepository({required FirebaseKartaService firebaseKartaService})
      : _firebaseKartaService = firebaseKartaService;

  /// FETCH CARDS
  Future<List<Karta>> fetchCards() async {
    return await _firebaseKartaService.fetchCards();
  }
}
