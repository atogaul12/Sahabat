import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepo {
  final _auth = FirebaseAuth.instance;

  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = _auth.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'userId': user.uid,
          'email': email,
        }, SetOptions(merge: true));
      }
    } on FirebaseException catch (e) {
      throw e.message ?? 'Something wrong!';
    } catch (e) {
      throw e;
    }
  }

  Future<void> register(
      {required String email, required String password}) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'userId': user.uid,
          'email': user.email,
          'name': '',
          'address': '',
          'phone': '',
        });
      }
    } on FirebaseException catch (e) {
      throw e.message ?? 'Something wrong!';
    } catch (e) {
      throw e;
    }
  }

  Future<void> loginWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    try {
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'userId': user.uid,
          'email': user.email,
          'name': user.displayName ?? '',
          'address': '',
          'phone': '',
        }, SetOptions(merge: true));
      }
    } on FirebaseException catch (e) {
      throw e.message ?? 'Something wrong!';
    } catch (e) {
      throw e;
    }
  }

  Future<void> loginWithPhone(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        final userCredential = await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'userId': user.uid,
            'phone': phoneNumber,
            'email': '',
            'name': '',
            'address': '',
          }, SetOptions(merge: true));
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        throw e.message ?? 'Something wrong!';
      },
      codeSent: (String verificationId, int? resendToken) {
        // Handle code sent
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout
      },
    );
  }
}
