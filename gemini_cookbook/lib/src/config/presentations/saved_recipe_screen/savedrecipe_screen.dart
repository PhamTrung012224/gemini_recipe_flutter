import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/constants/constants.dart';
import 'package:gemini_cookbook/src/config/models/objects/prompt_response_object.dart';
import 'package:gemini_cookbook/src/config/models/objects/youtube_response_object.dart';
import 'package:lottie/lottie.dart';

import '../authentication_screen/authentication_bloc/authentication_bloc.dart';
import '../recipe_screen/recipe_screen.dart';
import '../recipe_screen/save_recipe_bloc/save_recipe_bloc.dart';

class SavedRecipeScreen extends StatefulWidget {
  final String userId;
  const SavedRecipeScreen({super.key, required this.userId});

  @override
  State<SavedRecipeScreen> createState() => _SavedRecipeScreenState();
}

class _SavedRecipeScreenState extends State<SavedRecipeScreen> {
  final recipeCollection = FirebaseFirestore.instance.collection('recipes');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Saved Recipes',
          style: TextStyleConstants.tabBarTitle,
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          height: double.infinity,
          width: double.infinity,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("recipes")
                .where('ownerId', isEqualTo: widget.userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active &&
                  (snapshot.data?.docs.length ?? 0) >= 1) {
                final result = snapshot.data!.docs.toList();
                List<String> recipeTitles = [];
                List<YoutubeResponse> youtubeResponses = [];
                List<PromptResponse> promptResponses = [];
                for (var recipe in result) {
                  recipeTitles.add(recipe["title"]);
                  promptResponses
                      .add(PromptResponse.fromJson(recipe["recipeJson"]));
                  youtubeResponses
                      .add(YoutubeResponse.fromJson(recipe["youtubeJson"]));
                }
                return ListView.builder(
                    itemCount: recipeTitles.length,
                    itemBuilder: (context, idx) => SizedBox(
                          width: (MediaQuery.of(context).size.width - 40),
                          child: GestureDetector(
                            onTap: () async {
                              final savedCheck = await recipeCollection
                                  .where('ownerId', isEqualTo: widget.userId)
                                  .where('title', isEqualTo: recipeTitles[idx])
                                  .get();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => SaveRecipeBloc(
                                        userRepository: context
                                            .read<AuthenticationBloc>()
                                            .userRepository),
                                    child: RecipeScreen(
                                      userId: widget.userId,
                                      promptResponse: promptResponses[idx],
                                      youtubeResponse: youtubeResponses[idx],
                                      savedCheck:
                                          savedCheck.size >= 1 ? true : false,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 6,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width:
                                        (MediaQuery.of(context).size.width -
                                                100) /
                                            2,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft:Radius.circular(4),bottomLeft: Radius.circular(4)),
                                      child: Image.network(
                                        youtubeResponses[idx]
                                            .items[0]
                                            .snippet
                                            .thumbnails
                                            .medium
                                            .url,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 8, bottom: 4),
                                      child: Text(
                                        recipeTitles[idx],
                                        style: TextStyleConstants.headline2,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ));
              } else if (snapshot.connectionState == ConnectionState.active &&
                  (snapshot.data?.docs.length ?? 0) == 0) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(LottieConstants.noRecipeAnimation,
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.5),
                    Text(
                      "No recipes are being saved.",
                      style: TextStyleConstants.headline1,
                    )
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          )),
    );
  }
}
