import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stonks/Providers/PortfolioAction.dart';
import 'package:stonks/Providers/screenManager.dart';
import 'package:stonks/Screens/homeScreen.dart';
import 'package:stonks/Screens/marketSearch.dart';
import 'package:stonks/Screens/positionDetailScreen.dart';
import './Providers/AuthService.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Stonks');
    setWindowMinSize(const Size(1200, 800));
    setWindowMaxSize(Size.infinite);
  }
  runApp(MyApp());
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return HomeScreen();
    }
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Sign in'),
          onPressed: () {
            context
                .read<AuthService>()
                .signIn(email: 'seb4594@gmail.com', password: 'cowfat4594');
          },
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthService(FirebaseAuth.instance)),
        ChangeNotifierProvider(create: (context) => ScreenManager()),
        ChangeNotifierProxyProvider<AuthService, PortfolioAction>(
            create: null,
            update: (ctx, auth, oldStocks) => PortfolioAction(
                auth.userId, oldStocks == null ? [] : oldStocks.currentStocks)),
        StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, home: AuthWrapper(),
        routes: {
          '/home': (ctx) => HomeScreen(),
          '/market': (ctx) => MarketSearchPage(),
          '/positonDetail': (ctx) => PositionDetailScreen()
        },

        // Scaffold(
        //   drawer: Drawer(),
        //   appBar: AppBar(
        //     actions: [],
        //   ),
        //   body: Container(),
        // ),
      ),
    );
  }
}
