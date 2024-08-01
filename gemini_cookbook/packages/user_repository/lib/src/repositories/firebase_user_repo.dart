import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final usersRecipeCollection =
      FirebaseFirestore.instance.collection('recipes');
  final suggestRecipeCollection =
      FirebaseFirestore.instance.collection('suggest_recipes');
  FirebaseUserRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser;
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: myUser.email, password: password);
      myUser = myUser.copyWith(userId: user.user!.uid);
      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try {
      await usersCollection
          .doc(myUser.userId)
          .set(myUser.toEntity().toDocuments());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> uploadPicture(String path, String userId) async {
    try {
      File imageFile = File(path);
      Reference firebaseStoreRef =
          FirebaseStorage.instance.ref().child('$userId/PP/${userId}_lead');
      await firebaseStoreRef.putFile(imageFile);
      String url = await firebaseStoreRef.getDownloadURL();
      await usersCollection.doc(userId).update({'picture': url});
      return url;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> uploadRecipePicture(String path, String userId) async {
    try {
      File imageFile = File(path);
      Reference firebaseStoreRef =
      FirebaseStorage.instance.ref().child('$userId/PP/${userId}_lead');
      await firebaseStoreRef.putFile(imageFile);
      String url = await firebaseStoreRef.getDownloadURL();
      await suggestRecipeCollection.doc(userId).update({"picture": url});
      return url;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


  @override
  Future<MyUser> getUserData(String userId) async {
    try {
      return usersCollection.doc(userId).get().then((value) =>
          MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setUserRecipeData(MyUserRecipe userRecipe) async {
    try {
      await usersRecipeCollection
          .doc(userRecipe.userId)
          .set(userRecipe.toRecipeEntity().toRecipeDocuments());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setSuggestRecipeData(MySuggestRecipe mySuggestRecipe) async {
    try {
      await suggestRecipeCollection.doc(mySuggestRecipe.userId).set(
          mySuggestRecipe.toSuggestRecipeEntity().toSuggestRecipeDocuments());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUserRecipe> getUserRecipeData(String userRecipeId) {
    try {
      return usersCollection.doc(userRecipeId).get().then((value) =>
          MyUserRecipe.fromRecipeEntity(
              MyUserRecipeEntity.fromRecipeDocuments(value.data()!)));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteUserRecipe(String userId, String recipeTitle) async {
    try {
      final querySnapshot = await usersRecipeCollection
          .where('ownerId', isEqualTo: userId)
          .where('title', isEqualTo: recipeTitle)
          .get();
      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
