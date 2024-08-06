import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import '../../../components/ui_space.dart';
import '../../../constants/constants.dart';
import '../../../models/objects/image_object.dart';
import '../../../themes/color_source.dart';

class GetIngredientsScreen extends StatefulWidget {
  const GetIngredientsScreen({super.key});

  @override
  State<GetIngredientsScreen> createState() => _GetIngredientsScreenState();
}

class _GetIngredientsScreenState extends State<GetIngredientsScreen> {
  final ImageObject imgData = ImageObject(image: [], imageData: []);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          "First, please provide an image of what you have available",
                          style: TextStyleConstants.headline1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          "Note: If you want random ingredients, just skip this step",
                          style: TextStyleConstants.normal,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: GestureDetector(
                          onTap: getImage,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 12, bottom: 8, right: 10),
                            child: Container(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    const UISpace(height: 10),
                                    Row(
                                      children: [
                                        Container(
                                          height: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  52) /
                                              3,
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  52) /
                                              3,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12))),
                                          child: Transform.scale(
                                              scale: 1.8,
                                              child: const Icon(
                                                  Icons.image_outlined)),
                                        ),
                                        SizedBox(
                                          width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      52) *
                                                  2 /
                                                  3 +
                                              16,
                                          height: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  52) /
                                              3,
                                          child: (imgData.image?.isNotEmpty ??
                                                  false)
                                              ? ListView.builder(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 4),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder: (context, idx) =>
                                                      Row(
                                                    children: [
                                                      const SizedBox(width: 4),
                                                      ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    12)),
                                                        child: Stack(children: [
                                                          Image(
                                                            image: imgData
                                                                .image![idx]
                                                                .image,
                                                            height: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    52) /
                                                                3,
                                                            width: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    52) /
                                                                3,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                imgData.image!
                                                                    .removeAt(
                                                                        idx);
                                                                imgData
                                                                    .imageData!
                                                                    .removeAt(
                                                                        idx);
                                                              });
                                                            },
                                                            child:
                                                                const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 2,
                                                                      left: 76),
                                                              child: Icon(
                                                                  Icons
                                                                      .remove_circle_outline,
                                                                  color: ColorConstants
                                                                      .removeButtonColor),
                                                            ),
                                                          )
                                                        ]),
                                                      ),
                                                    ],
                                                  ),
                                                  itemCount:
                                                      imgData.image!.length,
                                                )
                                              : Container(),
                                        )
                                      ],
                                    ),
                                    const UISpace(height: 10)
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> getImage() async {
    ImagePicker imagePicker = ImagePicker();
    final img = await imagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      imgData.image!.add(Image(image: FileImage(File(img.path))));
      imgData.imageData!.add(DataPart(lookupMimeType(img.path).toString(),
          File(img.path).readAsBytesSync()));
      setState(() {});
    }
  }
}
