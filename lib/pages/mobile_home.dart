import 'package:auth_app/pages/otp_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({super.key});

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  TextEditingController phoneNumeber = TextEditingController();

  sendCode() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+81${phoneNumeber.text}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar("Error occured", e.code);
        },
        codeSent: (verificationId, forceResendingToken) {
          Get.to(OtpPage(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error Occured", e.code);
    } catch (e) {
      Get.snackbar("Error Occured", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          const Center(
            child: Text("Your Phone!"),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 6),
            child: Text(
                "we will send you an one time password on this mobile number"),
          ),
          const SizedBox(height: 20),
          phoneText(),
          const SizedBox(height: 50),
          button(),
        ],
      ),
    );
  }

  Widget phoneText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        controller: phoneNumeber,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          prefix: Text("+81"),
          prefixIcon: Icon(Icons.phone),
          labelText: "Enter phone number",
          hintStyle: TextStyle(color: Colors.grey),
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget button() {
    return ElevatedButton(
        onPressed: () => sendCode(), child: const Text("Recive OTP"));
  }
}
