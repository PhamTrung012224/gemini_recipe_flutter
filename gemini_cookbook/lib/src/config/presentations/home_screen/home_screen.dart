import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/components/suggest_list.dart';
import 'package:gemini_cookbook/src/config/presentations/profile_screen/profile_screen.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../components/gradient_text.dart';
import '../../components/ui_icon.dart';
import '../../components/ui_space.dart';
import '../../constants/constants.dart';
import '../../models/services/youtube_search/youtube_search.dart';
import '../authentication_screen/sign_in_screen/bloc/sign_in_bloc.dart';
import '../authentication_screen/sign_in_screen/bloc/sign_in_event.dart';
import '../main_screen/my_user/my_user_bloc.dart';
import '../main_screen/my_user/my_user_event.dart';
import '../main_screen/my_user/my_user_state.dart';
import '../main_screen/my_user/update_user_image/update_user_profile_bloc.dart';
import '../main_screen/my_user/update_user_image/update_user_profile_state.dart';


class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  NavigatorState? _navigator;
  BuildContext? _context;
  bool isDarkMode = false;
  bool _isLoadingLogOut = false;
  final YoutubeSearchRepository youtube = YoutubeSearchRepository();
  final suggestCollection =
      FirebaseFirestore.instance.collection('suggest_recipes');
  final recipeCollection = FirebaseFirestore.instance.collection('recipes');
  final categoryCollection = FirebaseFirestore.instance.collection('category');

  @override
  void didChangeDependencies() {
    isDarkMode = (Theme.of(context).brightness == Brightness.dark);
    _navigator = Navigator.of(context);
    _context = context;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<UpdateUserProfileBloc, UpdateUserProfileState>(
      listener: (context, state) {
        if (state is UploadPictureSuccess || state is UploadUsernameSuccess) {
          setState(() {
            context.read<MyUserBloc>().add(GetUserData(
                userId: context.read<MyUserBloc>().state.user!.userId));
          });
        }
      },
      child: Stack(
        children: [
          Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: isDarkMode
                  ? const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xff511709),
                        Color(0xff4c2921),
                      ]),
                    )
                  : const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xffffeabd),
                        Color(0xffffac37),
                      ]),
                    )),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  expandedHeight: MediaQuery.of(context).size.height * 0.28,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: isDarkMode
                                ? const BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color(0xff511709),
                                      Color(0xff4c2921),
                                    ]),
                                  )
                                : const BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color(0xffffeabd),
                                      Color(0xffffac37),
                                    ]),
                                  )),
                        Column(children: [
                          UISpace(
                              height:
                                  MediaQuery.of(context).size.height * 0.008),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8.0),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    UIIcon(
                                        size: 42,
                                        icon: IconConstants.accountIcon,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                    BlocBuilder<MyUserBloc, MyUserState>(
                                      builder: (context, state) {
                                        return GestureDetector(
                                          onTap: () async {
                                            _navigator!.push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const ProfileScreen()));
                                          },
                                          child: Container(
                                            width: 42,
                                            height: 42,
                                            decoration: const BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                            child: (state.user?.picture
                                                        .isNotEmpty ??
                                                    false)
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          state.user!.picture,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Center(
                                    child: BlocBuilder<MyUserBloc, MyUserState>(
                                      builder: (context, state) {
                                        return Text(
                                          "Hello ${state.user?.name ?? ''}!",
                                          style: TextStyleConstants.title,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        _isLoadingLogOut = true;
                                      });
                                      await precacheImage(
                                              AssetImage(isDarkMode
                                                  ? ImageConstants
                                                      .loginDarkBackground
                                                  : ImageConstants
                                                      .loginBackground),
                                              context)
                                          .catchError((error) {
                                        log('Error preloading image: $error');
                                      });
                                      _context!
                                          .read<SignInBloc>()
                                          .add(SignOutRequired());
                                      setState(() {
                                        _isLoadingLogOut = false;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.logout_sharp,
                                      size: 40,
                                    ))
                              ],
                            ),
                          ),
                          UISpace(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Don't know what to eat today, let's us give you some suggestions",
                                    style: TextStyleConstants.headline1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ])
                      ],
                    ),
                    title: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.013,
                                  left: 8,
                                  bottom: MediaQuery.of(context).size.height *
                                      0.013),
                              child: GradientText(
                                'Recommend dishes',
                                gradient: LinearGradient(colors: [
                                  Theme.of(context).colorScheme.onSurface,
                                  Theme.of(context).colorScheme.onSurface
                                ]),
                                style: TextStyleConstants.headline1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    titlePadding: const EdgeInsets.all(0),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  child: StreamBuilder(
                    stream: categoryCollection.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active &&
                          (snapshot.data?.docs.length ?? 0) >= 1) {
                        final result = snapshot.data!.docs.toList();

                        final categories = [];

                        // Get list of category
                        for (var category in result) {
                          categories.add(category["name"]);
                        }

                        return Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 32,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: categories.length,
                                  itemBuilder: (context, idx) {
                                    return SuggestList(
                                      title: categories[idx],
                                      category: categories[idx],
                                      recipeCollection: recipeCollection,
                                    );
                                  }),
                            ),
                            const UISpace(height: 20)
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                )),
              ],
            ),
          ),
          _isLoadingLogOut
              ? Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Theme.of(context).colorScheme.primary, size: 90),
                )
              : const SizedBox()
        ],
      ),
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
    _navigator = null;
    _context = null;
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
