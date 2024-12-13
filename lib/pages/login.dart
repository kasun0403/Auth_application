import 'package:auth_app/pages/forget_pw.dart';
import 'package:auth_app/pages/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.text, password: password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log in"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(hintText: "Enter email"),
            ),
            TextField(
              controller: password,
              decoration: const InputDecoration(hintText: "Enter passsword"),
            ),
            ElevatedButton(
                onPressed: () => signIn(), child: const Text("log in")),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () => Get.to(SignUpPage()),
                child: const Text("Register now")),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () => Get.to(ForgotPW()),
                child: const Text("Forgot password?"))
          ],
        ),
      ),
    );
  }
}
