import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'blocs/auth/auth_bloc.dart';
import 'data/repositories/auth_repository.dart';
import 'data/services/firebase_auth_service.dart';
import 'ui/screens/auth/login_screen.dart';
import 'ui/screens/home/home_screen.dart';
import 'utils/navigation/app_route.dart';
import 'utils/navigation/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final firebaseAuthService = FirebaseAuthService();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) =>
              AuthRepository(firebaseAuthService: firebaseAuthService),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthBloc, AuthState>(
        bloc: context.read<AuthBloc>()..add(CheckTokenExpiryEvent()),
        builder: (context, state) {
          if (state is AuthenticatedAuthState) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
      ),
      routes: AppRoute.routes,
      navigatorKey: navigationService.navigationKey,
    );
  }
}
