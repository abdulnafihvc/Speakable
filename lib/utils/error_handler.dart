import 'package:firebase_auth/firebase_auth.dart';

class AppErrorMessages {
  static const String networkError = 'Unable to connect. Please check your internet connection and try again.';
  static const String invalidCredentials = 'Invalid email or password. Please verify your credentials and try again.';
  static const String emailAlreadyInUse = 'This email address is already registered. Please sign in or use a different email.';
  static const String weakPassword = 'Password is too weak. Please choose a stronger password with at least 6 characters.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String userNotFound = 'No account found with this email address.';
  static const String tooManyRequests = 'Too many failed attempts. Please try again later.';
  static const String accountDisabled = 'This account has been disabled. Please contact support.';
  static const String operationNotAllowed = 'Email/password accounts are not enabled. Please contact support.';
  static const String unexpectedError = 'An unexpected error occurred. Please try again.';
  static const String signUpSuccess = 'Account created successfully! Welcome to Speakable.';
  static const String signInSuccess = 'Welcome back! You have been signed in successfully.';
}

class ErrorHandler {
  static String getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return AppErrorMessages.weakPassword;
      case 'email-already-in-use':
        return AppErrorMessages.emailAlreadyInUse;
      case 'invalid-email':
        return AppErrorMessages.invalidEmail;
      case 'user-not-found':
        return AppErrorMessages.userNotFound;
      case 'wrong-password':
        return AppErrorMessages.invalidCredentials;
      case 'too-many-requests':
        return AppErrorMessages.tooManyRequests;
      case 'user-disabled':
        return AppErrorMessages.accountDisabled;
      case 'operation-not-allowed':
        return AppErrorMessages.operationNotAllowed;
      case 'network-request-failed':
        return AppErrorMessages.networkError;
      default:
        return e.message ?? AppErrorMessages.unexpectedError;
    }
  }
}
