import 'package:auth_app/pages/home_page.dart';
import 'package:auth_app/pages/login.dart';
import 'package:auth_app/pages/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.emailVerified) {
              return const HomePage();
            } else {
              return const VerifyEmail();
            }
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
