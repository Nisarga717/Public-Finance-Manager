import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  User? get user => _auth.currentUser;
  bool get isAuthenticated => user != null;

  /// 🟢 **Register a New User & Store Data in Firestore**
  Future<String?> register(
      String name, String email, String phone, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Store user details in Firestore (Profile picture is initially null)
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "name": name,
          "email": email,
          "phone": phone,
          "profilePic": null, // User can set this later
          "createdAt": FieldValue.serverTimestamp(),
        });

        await user.updateDisplayName(name);
        await _storeUserToken();
      }

      notifyListeners();
      return null; // No error
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Registration failed.";
    } catch (e) {
      return "Error: $e";
    }
  }

  /// 🔵 **Login User**
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _storeUserToken();
      notifyListeners();
      return null; // No error
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Invalid credentials.";
    } catch (e) {
      return "Error: $e";
    }
  }

  /// 🟠 **Logout User**
  Future<void> logout() async {
    await _auth.signOut();
    await _secureStorage.delete(key: "user_token");
    notifyListeners();
  }

  /// 🔴 **Reset Password**
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // No error
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Failed to send reset email.";
    } catch (e) {
      return "Error: $e";
    }
  }

  /// 🛡 **Securely Store User Token**
  Future<void> _storeUserToken() async {
    if (_auth.currentUser != null) {
      await _secureStorage.write(
          key: "user_token", value: _auth.currentUser!.uid);
    }
  }

  /// 🟣 **Get User Data from Firestore**
  Future<Map<String, dynamic>?> getUserData() async {
    if (user == null) return null;

    DocumentSnapshot userDoc =
        await _firestore.collection("users").doc(user!.uid).get();
    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>;
    }
    return null;
  }

  /// 🟡 **Upload Profile Picture & Update Firestore**
  Future<String?> uploadProfilePicture(XFile image) async {
    if (user == null) return null;

    try {
      File file = File(image.path);
      String filePath = "profile_pictures/${user!.uid}.jpg";

      // Upload to Firebase Storage
      TaskSnapshot uploadTask = await _storage.ref(filePath).putFile(file);

      // Get download URL
      String downloadUrl = await uploadTask.ref.getDownloadURL();

      // Update Firestore
      await _firestore.collection("users").doc(user!.uid).update({
        "profilePic": downloadUrl,
      });

      notifyListeners();
      return downloadUrl;
    } catch (e) {
      return "Error uploading image: $e";
    }
  }

  
}
