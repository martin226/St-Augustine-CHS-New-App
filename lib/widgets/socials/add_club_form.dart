import 'dart:io';
import 'package:flutter/material.dart';
import 'package:staugustinechsnewapp/theme/styles.dart';
import 'package:staugustinechsnewapp/utilities/image/image_utils.dart';
import 'package:staugustinechsnewapp/utilities/profile/banner_dimensions.dart';
import 'package:staugustinechsnewapp/widgets/reusable/custom_snackbar.dart';
import 'package:staugustinechsnewapp/widgets/reusable/rounded_button.dart';
import 'package:staugustinechsnewapp/widgets/reusable/rounded_textfield.dart';

class AddClubForm extends StatefulWidget {
  final Function({
    required String name,
    required String description,
    required File picture,
    required int joinPreference,
  }) onPressedSubmit;

  const AddClubForm({Key? key, required this.onPressedSubmit})
      : super(key: key);

  @override
  State<AddClubForm> createState() => _AddClubFormState();
}

class _AddClubFormState extends State<AddClubForm> {
  EdgeInsetsGeometry padding =
      const EdgeInsets.symmetric(vertical: 7.0, horizontal: 16.0);

  TextEditingController clubNameController = TextEditingController();
  TextEditingController clubDescriptionController = TextEditingController();
  File? image;
  int joinPreference = -1;

  Future<void> onPressedChooseImage() async {
    // Step #1: Pick Image From Gallery.
    await ImageUtils.pickImageFromGallery().then((pickedFile) async {
      // Step #2: Check if we actually picked an image. Otherwise -> stop;
      if (pickedFile == null) return;

      // Step #3: Crop earlier selected image
      await ImageUtils.cropSelectedImage(
        filePath: pickedFile.path,
        ratioX: bannerRatioXY,
        ratioY: 1.0,
      ).then((croppedFile) {
        // Step #4: Check if we actually cropped an image. Otherwise -> stop;
        if (croppedFile == null) return;

        // Step #5: Display image on screen
        setState(() {
          image = croppedFile;
        });
      });
    });
  }

  void onPressedSubmit() {
    if (clubNameController.text.isEmpty ||
        clubDescriptionController.text.isEmpty ||
        image == null ||
        joinPreference == -1) {
      useCustomSnackbar(
          context: context,
          message: 'Please fill out all required fields',
          type: ESnackBarType.failure);
      return;
    }
    widget.onPressedSubmit(
        name: clubNameController.text,
        description: clubDescriptionController.text,
        picture: image!,
        joinPreference: joinPreference);
  }

  List<Widget> buildJoinPreferences() {
    List<String> joinPreferences = [
      'Not accepting new members',
      'Members need admin approval',
      'Anyone can join',
    ];

    List<Widget> rows = [];
    for (var preference in joinPreferences) {
      rows.add(Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Styles.white,
            border: Border.all(
              color: Styles.primary,
              width: 1.0,
            ),
            borderRadius: Styles.mainBorderRadius),
        child: InkWell(
          child: Row(
            children: <Widget>[
              Padding(
                  padding: padding,
                  child: Text(
                    preference,
                    style: Theme.of(context).textTheme.subtitle2,
                  )),
              const Spacer(),
              Container(
                  alignment: Alignment.center,
                  width: 50.0,
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(width: 1.0, color: Styles.primary),
                    ),
                  ),
                  child: Padding(
                    padding: padding,
                    child: joinPreference == joinPreferences.indexOf(preference)
                        ? const Icon(
                            Icons.check,
                            color: Styles.primary,
                          )
                        : const Icon(
                            null,
                          ),
                  ))
            ],
          ),
          onTap: () {
            setState(() {
              joinPreference = joinPreferences.indexOf(preference);
            });
          },
        ),
      ));
      rows.add(const SizedBox(height: 10.0));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    double padding = 45.0;
    double bannerWidth = MediaQuery.of(context).size.width - (padding * 2);

    Map<String, double> pictureContainerDimensions =
        Styles.pictureContainerDimensions(context: context, width: bannerWidth);
    double bannerHeight = pictureContainerDimensions['height']!;
    bannerWidth = pictureContainerDimensions['width']!;

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 5.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Club Name', style: Theme.of(context).textTheme.subtitle2),
          const SizedBox(height: 5.0),
          RoundedTextField(
              hintText: 'Nano Engineering Club',
              controller: clubNameController),
          const SizedBox(height: 10.0),
          Text('Club Desc.', style: Theme.of(context).textTheme.subtitle2),
          const SizedBox(height: 5.0),
          RoundedTextField(
              hintText: 'A club for students who think the QNC is cool!',
              isMultiline: true,
              controller: clubDescriptionController),
          const SizedBox(height: 20.0),
          Text('Banner', style: Theme.of(context).textTheme.subtitle2),
          const SizedBox(height: 5.0),
          Align(
              alignment: Alignment.center,
              child: Container(
                decoration: image != null
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(image!),
                        ),
                        color: Styles.grey,
                      )
                    : null,
                color: image != null ? null : Styles.grey,
                height: bannerHeight,
                width: bannerWidth,
              )),
          const SizedBox(height: 5.0),
          RoundedButton(text: 'Choose Image', onPressed: onPressedChooseImage),
          const SizedBox(height: 20.0),
          Text('Join Preferences',
              style: Theme.of(context).textTheme.subtitle2),
          const SizedBox(height: 5.0),
          ...buildJoinPreferences(),
          const SizedBox(height: 10.0),
          RoundedButton(
            text: 'Create Club',
            onPressed: onPressedSubmit,
          )
        ]));
  }
}
