import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? _user;
  User? get user{
    return _user;
  }
  AuthService() {
    _firebaseAuth.authStateChanges().listen(authStateChangesStreamListener);
  }

  Future<bool> login(String email, String password) async {
    try{
      final credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if(credential.user != null){
        _user = credential.user;
        return true;
      }
    }catch (e){
      print(e);
    }
    return false;
  }

  Future<bool> signup(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> logout() async {
    try{
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }


  void authStateChangesStreamListener(User? user) {
    if (user != null){
      _user = user;
    } else {
      _user = null;
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      // Sign in with Google
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the authentication details from Google
      final googleAuth = await googleUser.authentication;

      // Create a credential using the GoogleAuthProvider
      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Sign in to Firebase with the generated credential
      final userCredential = await _firebaseAuth.signInWithCredential(cred);

      // Return the user credential which contains the user information
      return userCredential;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}