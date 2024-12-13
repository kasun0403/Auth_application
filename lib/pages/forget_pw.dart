import 'package:auth_app/pages/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPW extends StatefulWidget {
  const ForgotPW({super.key});

  @override
  State<ForgotPW> createState() => _ForgotPWState();
}

class _ForgotPWState extends State<ForgotPW> {
  TextEditingController email = TextEditingController();

  resetPw() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email.text,
    );
    Get.offAll(() => const Wrapper());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(hintText: "Enter email"),
            ),
            ElevatedButton(
                onPressed: () => resetPw(), child: const Text("Send link"))
          ],
        ),
      ),
    );
  }
}
