import 'dart:ui';
import 'package:auth_app/pages/forget_pw.dart';
import 'package:auth_app/pages/mobile_home.dart';
import 'package:auth_app/pages/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:email_validator/email_validator.dart'; // Import email validator package

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isloading = false;

  // Email and password validation
  bool isValidEmail(String email) {
    return EmailValidator.validate(email);
  }

  bool isValidPassword(String password) {
    return password.length >=
        6; // Ensure the password is at least 6 characters long
  }

  signIn() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      Get.snackbar("Error", "Please fill in both fields",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (!isValidEmail(email.text)) {
      Get.snackbar("Error", "Please enter a valid email",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (!isValidPassword(password.text)) {
      Get.snackbar("Error", "Password must be at least 6 characters",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
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

  googleLogin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
              ),
            ),
          ),
          Center(
            child: isloading
                ? const CircularProgressIndicator(color: Colors.white)
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Container(
                        padding: const EdgeInsets.all(25.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo
                            const Icon(Icons.lock_outline_rounded,
                                size: 70, color: Colors.blueAccent),
                            const SizedBox(height: 10),
                            const Text(
                              "Welcome Back!",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 20),
                            // Email Input
                            TextField(
                              controller: email,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_rounded),
                                hintText: "Email Address",
                                filled: true,
                                fillColor: Colors.grey.shade300,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Password Input
                            TextField(
                              controller: password,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline),
                                hintText: "Password",
                                filled: true,
                                fillColor: Colors.grey.shade300,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Get.to(const ForgotPW()),
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: signIn,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(15),
                                ),
                                child: const Text(
                                  "Log In",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Divider
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text("OR"),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            // Google Login Button
                            OutlinedButton.icon(
                              onPressed: googleLogin,
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(15),
                                side: const BorderSide(
                                    color: Colors.blueAccent, width: 1),
                              ),
                              icon: Image.asset(
                                "assets/google.png", // Add your google icon image
                                height: 20,
                                width: 20,
                              ),
                              label: const Text(
                                "Sign in with Google",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Mobile Login
                            TextButton(
                              onPressed: () => Get.to(const MobileHome()),
                              child: const Text(
                                "Login with Mobile Number",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Register Link
                            TextButton(
                              onPressed: () => Get.to(const SignUpPage()),
                              child: RichText(
                                text: TextSpan(
                                  text: "Don't have an account? ",
                                  style: GoogleFonts.lato(
                                      textStyle:
                                          const TextStyle(color: Colors.black)),
                                  children: const [
                                    TextSpan(
                                      text: "Register now",
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
