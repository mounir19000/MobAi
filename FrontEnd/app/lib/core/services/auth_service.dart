import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<Map<String, dynamic>> signUp(String email, String password, String username, String phone) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;
    if (user != null) {
      // Create a Firestore user document
      UserModel newUser = UserModel(
        uid: user.uid,
        username: username,
        email: email,
        phone: phone,
        balance: 200.0, // Default balance
      );

      await _firestore.collection('users').doc(user.uid).set(newUser.toJson());

      return {
        "error": false,
        "user": newUser,
        "message": "User registered successfully!",
      };
    }

    return {
      "error": true,
      "message": "User creation failed.",
    };
  } on FirebaseAuthException catch (e) {
    String errorMessage = "An error occurred.";
    if (e.code == 'email-already-in-use') {
      errorMessage = "This email is already in use.";
    } else if (e.code == 'weak-password') {
      errorMessage = "The password is too weak.";
    }

    return {
      "error": true,
      "message": errorMessage,
    };
  } catch (e) {
    return {
      "error": true,
      "message": e.toString(),
    };
  }
}


  Future<Map<String, dynamic>> signIn(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        UserModel userModel = UserModel.fromJson(doc.data() as Map<String, dynamic>);
        return {
          "error": false,
          "user": userModel,  // You can return the full user object
          "token": await user.getIdToken(), // Firebase token
        };
      }
    }

    return {
      "error": true,
      "message": "User not found in the database.",
    };
  } catch (e) {
    return {
      "error": true,
      "message": e.toString(),
    };
  }
}




  Future<void> signOut() async {
    await _auth.signOut();
  }


  Future<UserModel?> getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    }
    return null;
  }
}
