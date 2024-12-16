import 'package:auth_app/pages/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatefulWidget {
  final String verificationId;
  const OtpPage({super.key, required this.verificationId});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String code = "";
  bool isLoading = false;

  // Method to handle OTP verification
  Future<void> signIn() async {
    if (code.length != 6) {
      Get.snackbar("Invalid OTP", "Please enter a 6-digit OTP",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    setState(() => isLoading = true);

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: code,
    );

    try {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        Get.offAll(() => const Wrapper());
      });
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Verification Failed", e.message ?? "Unknown error occurred",
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon and Title
                      const Icon(Icons.lock_outline_rounded,
                          size: 80, color: Color(0xFF0288D1)),
                      const SizedBox(height: 10),
                      const Text(
                        "OTP Verification",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Enter the 6-digit OTP sent to your mobile number",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 20),

                      // OTP Input
                      textCode(),

                      const SizedBox(height: 30),
                      // Verify Button
                      button(),
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

  // Customized Verify Button
  Widget button() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : signIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0288D1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(15),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text(
                "Verify & Proceed",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  // Customized OTP Input
  Widget textCode() {
    final defaultPinTheme = PinTheme(
      height: 55,
      width: 50,
      textStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black26),
      ),
    );

    return Pinput(
      length: 6,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF0288D1), width: 2),
        ),
      ),
      onChanged: (value) {
        setState(() {
          code = value;
        });
      },
      keyboardType: TextInputType.number,
      cursor: Container(
        height: 20,
        width: 2,
        color: const Color(0xFF0288D1),
      ),
    );
  }
}
