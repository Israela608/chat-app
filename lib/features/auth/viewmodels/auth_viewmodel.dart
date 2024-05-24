import 'package:chat_app/common/utils/app_logger.dart';
import 'package:chat_app/data/model/response.dart';
import 'package:chat_app/features/auth/constant/constants.dart';
import 'package:chat_app/firebase_ref/references.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthViewmodel extends ChangeNotifier {
  bool _showSpinner = false;
  bool get showSpinner => _showSpinner;
  set showSpinner(bool value) {
    _showSpinner = value;
    notifyListeners();
  }

  late FirebaseAuth _auth;
  User? _user;

  User? get user => _user;

  // Get the current User
  User? get currentUser => _auth.currentUser;
  // String? get userId => currentUser?.uid;

  //Check if the user is logged in or not
  bool get isAlreadyLoggedIn => _auth.currentUser != null;
  // String get displayName => currentUser?.displayName ?? '';
  String? get email => currentUser?.email;

  AuthViewmodel() {
    initAuth();
  }

  void initAuth() {
    //await Future.delayed(const Duration(seconds: 2));
    _auth = FirebaseAuth.instance;

    //Check whether the user is logged in or not and listen for changes
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners(); // Notify listeners about the change.
    });
  }

  Future<ResponseModel> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    showSpinner = true;

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );

      showSpinner = false;
      return ResponseModel(true, 'Registration Successful');
    } on FirebaseAuthException catch (e) {
      AppLogger.e(e);
      showSpinner = false;

      if (e.code == 'email-already-in-use') {
        return ResponseModel(false, 'Account already exists with this email');
      } else {
        return ResponseModel(false, 'Registration failed: ${e.message}');
      }
    }
  }

  Future<ResponseModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    showSpinner = true;

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );

      showSpinner = false;
      return ResponseModel(true, 'Login Successful');
    } on FirebaseAuthException catch (e) {
      AppLogger.e(e);
      showSpinner = false;

      if (e.code == 'wrong-password') {
        return ResponseModel(false, 'Wrong Password');
      } else if (e.code == 'user-not-found') {
        return ResponseModel(false, 'No user found with this email');
      } else {
        return ResponseModel(false, 'Login failed: ${e.message}');
      }
    }
  }

  Future<ResponseModel> signInWithGoogle() async {
    // GoogleSignIn method is used to get sign in information from google
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
      Constants.emailScope,
    ]);
    try {
      //Sign out any previous account. This will bring out the options to choose which google account you want to sign into
      await googleSignIn.signOut();

      //We try to sign in. If we can, then we get the account information and assign it to the 'account' variable
      GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) {
        //We get the authentication object
        final authAccount = await account.authentication;
        //We save the id and access token from the authentication object in this 'credential' variable
        final credential = GoogleAuthProvider.credential(
          idToken: authAccount.idToken,
          accessToken: authAccount.accessToken,
        );

        await _auth.signInWithCredential(credential);
        await saveUser(account);

        return ResponseModel(true, 'Log in Successful');
      }
      return ResponseModel(false, 'Log in Aborted');
    } on Exception catch (error) {
      AppLogger.e(error);
    }
    return ResponseModel(false, 'Log Failed');
  }

  // Save user to Firebase Firestore or your database
  Future<void> saveUser(GoogleSignInAccount account) async {
    userRF.doc(account.email).set({
      'email': account.email,
      'name': account.displayName,
      'profilepic': account.photoUrl
    });
  }

  Future<ResponseModel> signOut() async {
    showSpinner = true;
    AppLogger.d('Signing out');
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();

      showSpinner = false;
      return ResponseModel(true, 'Log out Successful');
    } on FirebaseAuthException catch (e) {
      AppLogger.e(e);
    }

    showSpinner = false;
    return ResponseModel(false, 'Log out Failed');
  }
}

/*
class AuthViewModel extends ChangeNotifier {
  bool _showSpinner = false;
  bool get showSpinner => _showSpinner;

  late FirebaseAuth _auth;
  User? _user;

  User? get user => _user;

  AuthViewModel() {
    initAuth();
  }

  void initAuth() {
    _auth = FirebaseAuth.instance;
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners(); // Notify listeners about the change.
    });
  }

  Future<ResponseModel> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _showSpinner = true;
    notifyListeners();

    try {
      List<String> methods = await _auth.fetchSignInMethodsForEmail(email);
      if (methods.contains('google.com')) {
        _showSpinner = false;
        return ResponseModel(false, 'Account already exists with Google Sign-In');
      } else {
        await _auth.createUserWithEmailAndPassword(
          email: email.trim().toLowerCase(),
          password: password.trim(),
        );
        _showSpinner = false;
        return ResponseModel(true, 'Registration Successful');
      }
    } catch (e) {
      AppLogger.e(e);
      _showSpinner = false;
      return ResponseModel(false, 'Registration failed: ${e.toString()}');
    }
  }

  Future<ResponseModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _showSpinner = true;
    notifyListeners();

    try {
      List<String> methods = await _auth.fetchSignInMethodsForEmail(email);
      if (methods.contains('google.com')) {
        // Automatically sign in with Google if the email is already linked to Google Sign-In
        return await signInWithGoogle();
      } else {
        await _auth.signInWithEmailAndPassword(
          email: email.trim().toLowerCase(),
          password: password.trim(),
        );
        _showSpinner = false;
        return ResponseModel(true, 'Login Successful');
      }
    } catch (e) {
      AppLogger.e(e);
      _showSpinner = false;
      return ResponseModel(false, 'Login failed: ${e.toString()}');
    }
  }

  Future<ResponseModel> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    try {
      await googleSignIn.signOut();
      GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) {
        final authAccount = await account.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: authAccount.idToken,
          accessToken: authAccount.accessToken,
        );

        await _auth.signInWithCredential(credential);
        await saveUser(account);

        return ResponseModel(true, 'Login Successful');
      }
      return ResponseModel(false, 'Login Aborted');
    } on Exception catch (error) {
      AppLogger.e(error);
      return ResponseModel(false, 'Login Failed: ${error.toString()}');
    }
  }

  Future<void> saveUser(GoogleSignInAccount account) async {
    userRF.doc(account.email).set({
      'email': account.email,
      'name': account.displayName,
      'profilepic': account.photoUrl
    });
  }

  Future<ResponseModel> signOut() async {
    _showSpinner = true;
    notifyListeners();
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      _showSpinner = false;
      return ResponseModel(true, 'Logout Successful');
    } on FirebaseAuthException catch (e) {
      AppLogger.e(e);
      _showSpinner = false;
      return ResponseModel(false, 'Logout Failed: ${e.toString()}');
    }
  }
}


Future<AuthResult> loginWithFacebook() async {
  //this will display the facebook login dialog to the user
  final loginResult = await FacebookAuth.instance.login();
  final token = loginResult.accessToken?.token;
  if (token == null) {
    // User has aborted the logging in process
    return AuthResult.aborted;
  }

  //Get the token
  final oauthCredentials = FacebookAuthProvider.credential(token);

  try {
    //Sign in with the token
    await FirebaseAuth.instance.signInWithCredential(oauthCredentials);

    //If successful return success
    return AuthResult.success;
  } //If failed
  on FirebaseAuthException catch (e) {
    final email = e.email;
    final credential = e.credential;

    if (e.code == Constants.accountExistsWithDifferentCredential &&
        email != null &&
        credential != null) {
      final providers =
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      //If user has logged in with google before
      if (providers.contains(Constants.googleCom)) {
        //Login with google
        await loginWithGoogle();

        //Link both the facebook and google credentials
        currentUser?.linkWithCredential(credential);
      }

      //If the code above runs successfully, then the user has successfully logged in
      return AuthResult.success;
    }
    //Else failure
    return AuthResult.failure;
  }
}


Future<ResponseModel> registerWithEmailAndPassword({
  required String email,
  required String password,
}) async {
  _showSpinner = true;
  notifyListeners();

  try {
    await _auth.createUserWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password.trim(),
    );
    _showSpinner = false;
    return ResponseModel(true, 'Registration Successful');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      return ResponseModel(false, 'Account already exists with this email');
    } else {
      AppLogger.e(e);
      _showSpinner = false;
      return ResponseModel(false, 'Registration failed: ${e.message}');
    }
  }
}

Future<ResponseModel> signInWithEmailAndPassword({
  required String email,
  required String password,
}) async {
  _showSpinner = true;
  notifyListeners();

  try {
    await _auth.signInWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password.trim(),
    );
    _showSpinner = false;
    return ResponseModel(true, 'Login Successful');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'wrong-password') {
      // Attempt Google Sign-In if password is wrong
      return await signInWithGoogle(email: email);
    } else if (e.code == 'user-not-found') {
      AppLogger.e(e);
      _showSpinner = false;
      return ResponseModel(false, 'No user found with this email');
    } else {
      AppLogger.e(e);
      _showSpinner = false;
      return ResponseModel(false, 'Login failed: ${e.message}');
    }
  }
}*/
