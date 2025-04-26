import 'package:ecommerce_app/controllers/db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Create a new account using email-password method
  Future<String> createAccountWithEmail(
      String name, String email, String password) async {
    try {
      // Creating user with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save user data to the database after account creation
      await DbService().saveUserData(name: name, email: email);

      // Return success message
      return "Account Created Successfully";
    } on FirebaseAuthException catch (e) {
      // Return specific error message from Firebase
      return _handleFirebaseAuthException(e);
    } catch (e) {
      // Catch all other exceptions
      return "An error occurred: ${e.toString()}";
    }
  }

  // Login with email-password method
  Future<String> loginWithEmail(String email, String password) async {
    try {
      // Signing in the user with email and password
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Return success message
      return "Login Successful";
    } on FirebaseAuthException catch (e) {
      // Return specific error message from Firebase
      return _handleFirebaseAuthException(e);
    } catch (e) {
      // Catch all other exceptions
      return "An error occurred: ${e.toString()}";
    }
  }

  // Logout the user
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Error during logout: ${e.toString()}");
    }
  }

  // Reset the password
  Future<String> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return "Password reset email sent successfully.";
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseAuthException(e);
    } catch (e) {
      return "An error occurred: ${e.toString()}";
    }
  }

  // Check if the user is logged in or not
  Future<bool> isLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  // Helper method to handle FirebaseAuthExceptions
  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return "This email is already in use.";
      case 'invalid-email':
        return "The email address is not valid.";
      case 'operation-not-allowed':
        return "Operation not allowed. Please contact support.";
      case 'weak-password':
        return "Password is too weak. Please use a stronger password.";
      case 'user-disabled':
        return "This user has been disabled.";
      case 'user-not-found':
        return "No user found with this email.";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
      default:
        return "An error occurred: ${e.message}";
    }
  }
}
