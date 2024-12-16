import 'package:auth_app/pages/otp_page.dart';
import 'package:auth_app/pages/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({super.key});

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  TextEditingController phoneNumberController = TextEditingController();
  bool isLoading = false;

  sendCode() async {
    if (phoneNumberController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a valid phone number",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+81${phoneNumberController.text.trim()}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar("Verification Failed", e.message ?? "An error occurred",
              backgroundColor: Colors.red, colorText: Colors.white);
        },
        codeSent: (verificationId, forceResendingToken) {
          Get.to(() => OtpPage(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error Occurred", e.message ?? "Unknown error");
    } catch (e) {
      Get.snackbar("Error", e.toString());
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
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title Icon
                      const Icon(Icons.phone_android_rounded,
                          size: 80, color: Color(0xFF0288D1)),
                      const SizedBox(height: 10),
                      // Title
                      const Text(
                        "Enter Your Phone Number",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "We will send a one-time password to this mobile number.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      // Phone Number Input
                      phoneText(),
                      const SizedBox(height: 30),
                      // Send OTP Button
                      sendOtpButton(),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () => Get.offAll(() => const Wrapper()),
                        child: const Text(
                          "Back to Login",
                          style: TextStyle(
                            color: Color(0xFF0288D1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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

  Widget phoneText() {
    return TextField(
      controller: phoneNumberController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        prefix: const Text("+81 "),
        prefixIcon: const Icon(Icons.phone, color: Color(0xFF0288D1)),
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget sendOtpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : sendCode,
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
                "Send OTP",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
