import '../models/user.dart';
import '../services/firebase_auth_service.dart';

class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;

  AuthRepository({
    required FirebaseAuthService firebaseAuthService,
  }) : _firebaseAuthService = firebaseAuthService;

  Future<User> login({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    return await _firebaseAuthService.login(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }

  Future<User> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    return await _firebaseAuthService.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }

  Future<User?> checkTokenExpiry() async {
    return await _firebaseAuthService.checkTokenExpiry();
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuthService.resetPassword(email);
  }

  Future<void> logOut() async {
    await _firebaseAuthService.logOut();
  }
}
