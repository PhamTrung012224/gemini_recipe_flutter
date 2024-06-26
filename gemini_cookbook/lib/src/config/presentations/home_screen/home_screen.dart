import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/components/ui_space.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/bloc/home_screen_event.dart';

import 'bloc/home_screen_bloc.dart';
import 'bloc/home_screen_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> ingredients = [
    'oil',
    'butter',
    'flour',
    'salt',
    'pepper',
    'sugar',
    'milk',
    'vinegar'
  ];
  final List<String> cuisines = [
    'Italian',
    'Mexican',
    'American',
    'French',
    'Japanese',
    'Chinese',
    'Indian',
    'Greek',
    'Moroccan',
    'Ethiopian',
    'South African',
  ];
  final List<String> dietaryRestrictions = [
    'vegetarian',
    'dairy free',
    'kosher',
    'low carb',
    'wheat allergy',
    'nut allergy',
    'fish allergy',
    'soy allergy',
  ];

  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            expandedHeight: MediaQuery.of(context).size.height * 0.27,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(children: [
                UISpace(height: MediaQuery.of(context).size.height * 0.015),
                const Row(
                  children: [
                    Icon(Icons.menu),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Meowdy! Let's get cooking!",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                UISpace(height: MediaQuery.of(context).size.height * 0.048),
                const Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Tell me what ingredients you have and what you're feelin, and I'll create a recipe for you!",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Icon(Icons.info_rounded)
                    ],
                  ),
                ),
                ColoredBox(
                  color: Theme.of(context).colorScheme.background,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50)),
                      child: ColoredBox(
                          color: Theme.of(context).colorScheme.primary,
                          child: UISpace(
                              height:
                                  MediaQuery.of(context).size.height * 0.048))),
                ),
              ]),
              title: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius:
                        const BorderRadius.only(topRight: Radius.circular(50))),
                child: Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.0535,
                      child: const Padding(
                        padding: EdgeInsets.only(top: 8, left: 8),
                        child: Text(
                          'Create a recipe',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
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
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(50))),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                            height: 48,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Create a recipe:',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ))),
                        const UISpace(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).colorScheme.background,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 12, bottom: 8),
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    child: const Text(
                                        'I have these ingredients:')),
                              ),
                            ],
                          ),
                        ),
                        const UISpace(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).colorScheme.background,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 12, bottom: 8),
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    child: const Text(
                                        'I also have these staple ingredients:')),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 12),
                                child: InlineChoice.multiple(
                                    itemCount: ingredients.length,
                                    itemBuilder: (context, idx) => BlocBuilder<
                                            HomeScreenBloc, HomeScreenState>(
                                          builder: (context, state) {
                                            return ChoiceChip(
                                              label: Text(ingredients[idx]),
                                              selected: state
                                                  .isIngredientsSelected[idx],
                                              onSelected: (bool value) {
                                                List<bool> list = List.from(
                                                    state
                                                        .isIngredientsSelected);
                                                list[idx] = value;
                                                context
                                                    .read<HomeScreenBloc>()
                                                    .add(TapIngredientChip(
                                                        isIngredientsSelected:
                                                            list));
                                              },
                                            );
                                          },
                                        )),
                              )
                            ],
                          ),
                        ),
                        const UISpace(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).colorScheme.background,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 12, bottom: 8),
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    child: const Text("I'm in the mood for:")),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 12),
                                child: InlineChoice.multiple(
                                    itemCount: cuisines.length,
                                    itemBuilder: (context, idx) => BlocBuilder<
                                            HomeScreenBloc, HomeScreenState>(
                                          builder: (context, state) {
                                            return ChoiceChip(
                                              label: Text(cuisines[idx]),
                                              selected:
                                                  state.isCuisinesSelected[idx],
                                              onSelected: (bool value) {
                                                List<bool> list = List.from(
                                                    state.isCuisinesSelected);
                                                list[idx] = value;
                                                context
                                                    .read<HomeScreenBloc>()
                                                    .add(TapCuisineChip(
                                                        isCuisineSelected:
                                                            list));
                                              },
                                            );
                                          },
                                        )),
                              )
                            ],
                          ),
                        ),
                        const UISpace(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).colorScheme.background,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 12, bottom: 8),
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    child: const Text(
                                        "I have the following dietary restrictions:")),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 12),
                                child: InlineChoice.multiple(
                                    itemCount: dietaryRestrictions.length,
                                    itemBuilder: (context, idx) => BlocBuilder<
                                            HomeScreenBloc, HomeScreenState>(
                                          builder: (context, state) {
                                            return ChoiceChip(
                                              label: Text(
                                                  dietaryRestrictions[idx]),
                                              selected: state
                                                      .isDietaryRestrictionsSelected[
                                                  idx],
                                              onSelected: (bool value) {
                                                List<bool> list = List.from(state
                                                    .isDietaryRestrictionsSelected);
                                                list[idx] = value;
                                                context.read<HomeScreenBloc>().add(
                                                    TapDietaryRestrictionChip(
                                                        isDietaryRestrictionSelected:
                                                            list));
                                              },
                                            );
                                          },
                                        )),
                              )
                            ],
                          ),
                        ),
                        const UISpace(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).colorScheme.background,
                          child: const TextField(
                            enabled: false,
                          ),
                        ),
                        const UISpace(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      12,
                                  height: 48,
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12))),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.info_outline_rounded),
                                      SizedBox(width: 8),
                                      Text('Full Prompt'),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      20,
                                  height: 48,
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12))),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.send_sharp),
                                      SizedBox(width: 8),
                                      Text('Submit Prompt'),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const UISpace(height: 20),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            alignment: Alignment.center,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              height: 48,
                              padding:
                                  const EdgeInsets.only(left: 8, right: 8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12))),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.restart_alt),
                                  SizedBox(width: 8),
                                  Text('Reset Prompt'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const UISpace(height: 48),
                      ])),
            ),
          ),
        ],
      )),
    );
  }
}
