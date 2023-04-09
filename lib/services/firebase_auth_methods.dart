import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/showOtpDialog.dart';
import '../utils/showSnackbar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  User get user => _auth.currentUser!;

  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  Future<void> phoneSignIn(
    BuildContext context,
    String phoneNumber,
  ) async {
    TextEditingController codeController = TextEditingController();
    _isLoading = true;
    if (kIsWeb) {
      ConfirmationResult result =
          await _auth.signInWithPhoneNumber(phoneNumber);

      showOTPDialog(
        codeController: codeController,
        context: context,
        onPressed: () async {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: result.verificationId,
            smsCode: codeController.text.trim(),
          );

          await _auth.signInWithCredential(credential);
          Navigator.of(context).pop();
        },
      );
    } else {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+213$phoneNumber",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          _isLoading = false;
          showSnackBar(context, e.message!);
          print(e.message!);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          _isLoading = false;
          showOTPDialog(
            codeController: codeController,
            context: context,
            onPressed: () async {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: codeController.text.trim(),
              );

              await _auth.signInWithCredential(credential);
              Navigator.of(context).pop();
            },
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {
          _isLoading = false;

          // Auto-resolution timed out...
        },
      );
    }
  }
}
