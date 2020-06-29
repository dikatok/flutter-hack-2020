import 'package:CoronaDOOM/helpers/helpers.dart';
import 'package:CoronaDOOM/screens/game.dart';
import 'package:CoronaDOOM/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseUser user;

  @override
  void initState() {
    playIdle();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user = await getCurrentUser();
      if (user == null) {
        await signIn();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      padding: const EdgeInsets.all(16),
                      shape: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Game()));
                      },
                      child: const Text(
                        "PLAY",
                        style: TextStyle(color: Colors.green, fontSize: 24),
                      ),
                    ),
                    // const SizedBox(height: 32),
                    // GoogleSignInButton(
                    //   text: user == null
                    //       ? "Sign in with Google"
                    //       : "Signed in as ${user.displayName}",
                    //   onPressed: () async {
                    //     if (user == null) {
                    //       user = await signIn();
                    //     } else {
                    //       user = null;
                    //       // await signou
                    //     }
                    //   },
                    // ),
                  ],
                ),
              ),
              Positioned(
                bottom: 8,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Leaderboard()));
                      },
                      child: const Text(
                        "Leaderboard",
                        style: TextStyle(color: Colors.green, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
