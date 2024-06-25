import 'package:choice/choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini_cookbook/src/config/components/ui_space.dart';

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
                const UISpace(height: 15.5),
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
                const UISpace(height: 42),
                const Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                            "Tell me what ingredients you have and what you're feelin, and I'll create a recipe for you!'"),
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
                          child: const UISpace(height: 40))),
                ),
              ]),
              title: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius:
                        const BorderRadius.only(topRight: Radius.circular(50))),
                child: const Row(
                  children: [
                    SizedBox(
                      height: 40,
                      child: Padding(
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
                                    fontSize: 15, fontWeight: FontWeight.w600),
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
                                  child:
                                      const Text('I have these ingredients:')),
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
                                  itemBuilder: (context, idx) => ChoiceChip(
                                        label: Text(ingredients[idx]),
                                        selected: isSelected,
                                        onSelected: (bool value) {
                                          setState(() {
                                            isSelected = !isSelected;
                                          });
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
                                  itemBuilder: (context, idx) => ChoiceChip(
                                        label: Text(cuisines[idx]),
                                        selected: isSelected,
                                        onSelected: (bool value) {
                                          setState(() {
                                            isSelected = !isSelected;
                                          });
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
                                  itemBuilder: (context, idx) => ChoiceChip(
                                        label: Text(dietaryRestrictions[idx]),
                                        selected: isSelected,
                                        onSelected: (bool value) {
                                          setState(() {
                                            isSelected = !isSelected;
                                          });
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
                      Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          ],
                        ),
                      ),
                      const UISpace(height: 20),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        color: Theme.of(context).colorScheme.background,
                      ),
                      const UISpace(height: 48),
                    ]),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
