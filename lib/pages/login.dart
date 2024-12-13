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

  bool isloading = false;

  signIn() async {
    setState(() {
      isloading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error message", e.code,
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error message", e.toString());
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log in"),
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: email,
                    decoration: const InputDecoration(hintText: "Enter email"),
                  ),
                  TextField(
                    controller: password,
                    decoration:
                        const InputDecoration(hintText: "Enter passsword"),
                  ),
                  ElevatedButton(
                      onPressed: () => signIn(), child: const Text("log in")),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () => Get.to(const SignUpPage()),
                      child: const Text("Register now")),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () => Get.to(const ForgotPW()),
                      child: const Text("Forgot password?"))
                ],
              ),
            ),
    );
  }
}
