import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/components/ui_space.dart';
import 'package:gemini_cookbook/src/config/models/objects/recipe_object.dart';
import 'package:lottie/lottie.dart';

import '../constants/constants.dart';
import '../models/objects/prompt_response_object.dart';
import '../models/objects/suggest_response_object.dart';
import '../models/objects/youtube_response_object.dart';
import '../models/services/youtube_search/youtube_search.dart';
import '../presentations/authentication_screen/authentication_bloc/authentication_bloc.dart';
import '../presentations/main_screen/my_user/my_user_bloc.dart';
import '../presentations/main_screen/my_user/my_user_state.dart';
import '../presentations/recipe_screen/recipe_screen.dart';
import '../presentations/recipe_screen/save_recipe_bloc/save_recipe_bloc.dart';

class SuggestList extends StatefulWidget {
  final String title;
  final String category;
  final CollectionReference<Map<String, dynamic>> recipeCollection;

  const SuggestList({
    super.key,
    required this.title,
    required this.category,
    required this.recipeCollection,
  });

  @override
  State<SuggestList> createState() => _SuggestListState();
}

class _SuggestListState extends State<SuggestList> {
  final YoutubeSearchRepository youtube = YoutubeSearchRepository();
  List<bool> isLoading = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("suggest_recipes")
          .where("recipeJson.category", isEqualTo: widget.category)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active &&
            (snapshot.data?.docs.length ?? 0) >= 1) {
          final result = snapshot.data!.docs.toList();
          final RecipeList suggestRecipes = RecipeList();
          if (isLoading.length != result.length) {
            isLoading = List.filled(result.length, false);
          }
          for (var recipe in result) {
            suggestRecipes.addRecipe(Recipe(
              recipeId: recipe["userId"],
              recipeImage: recipe["picture"],
              suggestRecipe: SuggestResponse.fromJson(recipe["recipeJson"]),
            ));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  widget.title,
                  style: TextStyleConstants.title,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.28,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: suggestRecipes.suggestRecipes.length,
                  itemBuilder: (context, idx) => SuggestRecipe(
                      index: idx,
                      isLoading: isLoading,
                      suggestRecipes: suggestRecipes,
                      recipeCollection: widget.recipeCollection),
                ),
              ),
              const UISpace(height: 16),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class SuggestRecipe extends StatefulWidget {
  final int index;
  final List<bool> isLoading;
  final RecipeList suggestRecipes;
  final CollectionReference<Map<String, dynamic>> recipeCollection;

  const SuggestRecipe(
      {super.key,
      required this.index,
      required this.isLoading,
      required this.suggestRecipes,
      required this.recipeCollection});

  @override
  State<SuggestRecipe> createState() => _SuggestRecipeState();
}

class _SuggestRecipeState extends State<SuggestRecipe> {
  final YoutubeSearchRepository youtube = YoutubeSearchRepository();
  BuildContext? _context;
  List<bool> isLoading = [];

  @override
  void initState() {
    isLoading = widget.isLoading;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _context = context;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyUserBloc, MyUserState>(
      builder: (context, userState) {
        return GestureDetector(
          onTap: () async {
            setState(() {
              isLoading[widget.index] = true;
            });

            final res = await getYoutubeResponse(
              'How to make ${widget.suggestRecipes.suggestRecipes[widget.index].suggestRecipe.title}',
              5,
            );

            final PromptResponse promptResponse = PromptResponse.fromJson(widget
                .suggestRecipes.suggestRecipes[widget.index].suggestRecipe
                .toJson());

            final YoutubeResponse youtubeResponse =
                YoutubeResponse.fromJson(res);

            final savedCheck = await widget.recipeCollection
                .where('ownerId', isEqualTo: userState.user!.userId)
                .where('title',
                    isEqualTo: widget.suggestRecipes
                        .suggestRecipes[widget.index].suggestRecipe.title)
                .get();

            setState(() {
              isLoading[widget.index] = false;
            });
            Navigator.of(_context!).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => SaveRecipeBloc(
                    userRepository:
                        context.read<AuthenticationBloc>().userRepository,
                  ),
                  child: RecipeScreen(
                    userId: userState.user!.userId,
                    promptResponse: promptResponse,
                    youtubeResponse: youtubeResponse,
                    savedCheck: savedCheck.size >= 1,
                  ),
                ),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: isLoading[widget.index]
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey.withOpacity(0.4),
                    child: Center(
                      child: Lottie.asset(LottieConstants.cookingAnimation,
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.width * 0.4),
                    ),
                  )
                : Column(
                    children: [
                      widget.suggestRecipes.suggestRecipes[widget.index]
                              .recipeImage.isEmpty
                          ? const SizedBox.shrink()
                          : ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              child: CachedNetworkImage(
                                maxHeightDiskCache:
                                    (MediaQuery.of(context).size.height * 0.2)
                                        .ceil(),
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                width: MediaQuery.of(context).size.width * 0.5,
                                imageUrl: widget.suggestRecipes
                                    .suggestRecipes[widget.index].recipeImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.suggestRecipes.suggestRecipes[widget.index]
                                .suggestRecipe.title,
                            textAlign: TextAlign.left,
                            style: TextStyleConstants.headline2,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> getYoutubeResponse(
      String q, int maxResults) async {
    try {
      return youtube.search(q, maxResults);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  void dispose() {
    _context = null;
    super.dispose();
  }
}
