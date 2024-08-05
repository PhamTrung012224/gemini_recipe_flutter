import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/components/ui_icon.dart';
import 'package:gemini_cookbook/src/config/constants/constants.dart';
import 'package:gemini_cookbook/src/config/themes/bloc/theme_mode_event.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/custom_textfield.dart';
import '../../themes/bloc/theme_mode_bloc.dart';
import '../../themes/bloc/theme_mode_state.dart';
import '../main_screen/my_user/my_user_bloc.dart';
import '../main_screen/my_user/my_user_event.dart';
import '../main_screen/my_user/my_user_state.dart';
import '../main_screen/my_user/update_user_image/update_user_profile_bloc.dart';
import '../main_screen/my_user/update_user_image/update_user_profile_event.dart';
import '../main_screen/my_user/update_user_image/update_user_profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final nameFocus = FocusNode();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserProfileBloc, UpdateUserProfileState>(
        listener: (context, state) {
          if (state is UploadPictureSuccess || state is UploadUsernameSuccess) {
            setState(() {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              context.read<MyUserBloc>().add(GetUserData(
                  userId: context.read<MyUserBloc>().state.user!.userId));
            });
          } else if (state is UploadProfileFailure) {
            setState(() {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              final snackBar = SnackBar(
                  backgroundColor: const Color(0xFF322F35),
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  content: Container(
                    alignment: Alignment.centerLeft,
                    height: 48,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Text(
                      state.errorMessage.replaceAll(RegExp(r'\[.*?\]\s?'), ''),
                      style: TextStyleConstants.snackBarText,
                    ),
                  ),
                  elevation: 6,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Profile', style: TextStyleConstants.tabBarTitle),
            leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: Icon(
                      Icons.arrow_back,
                      size: 24,
                    ))),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: BlocBuilder<MyUserBloc, MyUserState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 20),
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 24),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7)),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final image = await getProfileImage();
                                if (image != null) {
                                  setState(() {
                                    context.read<UpdateUserProfileBloc>().add(
                                        UpdateProfileImage(
                                            userId: state.user!.userId,
                                            path: image.path));
                                  });
                                }
                              },
                              child: Stack(
                                children: [
                                  UIIcon(
                                      size: 48,
                                      icon: IconConstants.accountIcon,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    child: (state.user?.picture.isNotEmpty ??
                                            false)
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: CachedNetworkImage(
                                              imageUrl: state.user!.picture,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              state.user?.name ?? '',
                              style: TextStyleConstants.title,
                            )
                          ],
                        )),
                    GestureDetector(
                      onTap: () async {
                        final image = await getProfileImage();
                        if (image != null) {
                          setState(() {
                            context.read<UpdateUserProfileBloc>().add(
                                UpdateProfileImage(
                                    userId: state.user!.userId,
                                    path: image.path));
                          });
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            left: 20, right: 24, top: 4, bottom: 4),
                        padding: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background))),
                        child: Row(
                          children: [
                            UIIcon(
                                size: 36,
                                icon: IconConstants.accountBoxIcon,
                                color: Theme.of(context).colorScheme.onSurface),
                            const SizedBox(width: 4.5),
                            Text(
                              'Edit Profile Image',
                              style: TextStyleConstants.semiMedium,
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: SingleChildScrollView(
                                    child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24, top: 24, bottom: 24, right: 24),
                                  child: Column(children: [
                                    CustomTextField(
                                      width: MediaQuery.of(context).size.width,
                                      text: 'Username',
                                      style: TextStyleConstants.semiNormal,
                                      prefixIcon:
                                          const Icon(IconConstants.iconName),
                                      textEditingController: nameController,
                                      obscureText: false,
                                      containerBorderRadius: 8,
                                      containerColor:
                                          Theme.of(context).colorScheme.surface,
                                      prefixIconColor: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      focusNode: nameFocus,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Please fill in this field';
                                        } else if (!RegExp(
                                                Constants.rejectNameString)
                                            .hasMatch(val)) {
                                          return 'Please enter a valid name';
                                        }
                                        return null;
                                      },
                                      errorMsg: errorMessage,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<UpdateUserProfileBloc>()
                                                  .add(UpdateProfileName(
                                                      userId: context
                                                          .read<MyUserBloc>()
                                                          .state
                                                          .user!
                                                          .userId,
                                                      userName: nameController
                                                          .value.text));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Update",
                                                style: TextStyleConstants
                                                    .semiMedium,
                                              ),
                                            )),
                                        GestureDetector(
                                            onTap: () {
                                              if (Navigator.canPop(context)) {
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Cancel",
                                                style: TextStyleConstants
                                                    .semiMedium,
                                              ),
                                            )),
                                      ],
                                    )
                                  ]),
                                )),
                              )),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            left: 20, right: 24, top: 4, bottom: 4),
                        padding: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background))),
                        child: Row(
                          children: [
                            UIIcon(
                                size: 36,
                                icon: IconConstants.usernameIcon,
                                color: Theme.of(context).colorScheme.onSurface),
                            const SizedBox(width: 4.5),
                            Text(
                              'Edit Username',
                              style: TextStyleConstants.semiMedium,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 4),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: Row(
                        children: [
                          UIIcon(
                              size: 28.5,
                              icon: IconConstants.themeIcon,
                              color: Theme.of(context).colorScheme.onSurface),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Dark Mode',
                              style: TextStyleConstants.semiMedium,
                            ),
                          ),
                          BlocBuilder<ThemeModeBloc, ThemeModeState>(
                            builder: (context, state) {
                              return Switch(
                                  value: state.isOnSwitch,
                                  onChanged: (value) => {
                                        context
                                            .read<ThemeModeBloc>()
                                            .add(SwitchModeEvent())
                                      });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }

  Future<XFile?> getProfileImage() async {
    ImagePicker imagePicker = ImagePicker();
    return await imagePicker.pickImage(source: ImageSource.gallery);
  }
}
