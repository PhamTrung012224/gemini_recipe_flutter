import 'package:firebase_auth/firebase_auth.dart';

import '../../user_repository.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<MyUser> signUp(MyUser myUser, String password);

  Future<void> setUserData(MyUser user);

  Future<void> signIn(String email, String password);

  Future<void> logOut();

  Future<MyUser> getUserData(String userId);

  Future<MyUserRecipe> getUserRecipeData(String userRecipeId);

  Future<String> uploadPicture(String path, String userId);

  Future<void> setUserRecipeData(MyUserRecipe userRecipe);

  Future<void> deleteUserRecipe(String userId, String recipeTitle);

  Future<void> editUsername(String userId, String newUsername);


// Future<String> uploadRecipePicture(String path, String userId);
// Future<void> setSuggestRecipeData(MySuggestRecipe mySuggestRecipe);
}
