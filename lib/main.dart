import 'package:beesihachallenge/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/api_service_provider.dart';
import 'providers/favorite_characters_provider.dart';
import 'screens/authentication/login_screen.dart';
import 'services/firebase_auth_methods.dart';
import 'services/firebase_messaging_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String? token = await FirebaseMessagingService.getToken();
  print("Firebase token: $token");
  FirebaseMessagingService.registerMessageHandler();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider<FavoritesCharactersProvider>(
          create: (_) => FavoritesCharactersProvider(),
        ),
        ChangeNotifierProvider<ApiServiceProvider>(
          create: (_) => ApiServiceProvider(),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Beesiha Challenge',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const AuthWrapper(), // const HomeScreen(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const HomeScreen();
    }
    return  LoginScreen();
  }
}
