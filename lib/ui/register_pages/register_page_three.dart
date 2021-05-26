import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:save_ai/data/hobbies.dart';
import 'package:save_ai/data/users.dart';
import 'package:save_ai/style/theme.dart' as Theme;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegisterPageThree extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPageThree>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool isFinished = false;

  String countryValue;
  String stateValue;
  String cityValue;

  File _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget gradientTextField({String hintText, onSubmitted}) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.75,
        height: MediaQuery.of(context).size.width * 0.2,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.Colors.loginGradientStart,
              // offset: Offset(1.0, 6.0),
              blurRadius: 10.0,
            ),
            BoxShadow(
              color: Theme.Colors.loginGradientEnd,
              // offset: Offset(1.0, 6.0),
              blurRadius: 10.0,
            ),
          ],
          gradient: new LinearGradient(
              colors: [
                Theme.Colors.loginGradientEnd,
                Theme.Colors.loginGradientStart
              ],
              begin: const FractionalOffset(0.2, 0.2),
              end: const FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: TextField(
          textAlign: TextAlign.center,
          onSubmitted: onSubmitted,
          textInputAction: TextInputAction.done,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 15.0,
              color: Colors.white70,
            ),
          ),
          maxLines: null,
        ));
  }

  Widget animatedText({List<String> text, onFinished}) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: TypewriterAnimatedTextKit(
          onFinished: onFinished,
          totalRepeatCount: 1,
          isRepeatingAnimation: false,
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
          text: text,
          textStyle: GoogleFonts.asul(
              fontSize: 25,
              fontWeight: FontWeight.normal,
              color: Color(0xFF343d8f)),
          textAlign: TextAlign.center,
          repeatForever: false,
        ));
  }

  Widget animatedTextSmall({List<String> text}) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: TypewriterAnimatedTextKit(
          totalRepeatCount: 1,
          isRepeatingAnimation: false,
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
          text: text,
          textStyle: GoogleFonts.asul(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Color(0xFF343d8f)),
          textAlign: TextAlign.center,
          repeatForever: false,
        ));
  }

  Widget buildWidgets() {
    return !isFinished
        ? SizedBox(height: 0)
        : Column(children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              // decoration: new BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
              //   boxShadow: <BoxShadow>[
              //     BoxShadow(
              //       color: Theme.Colors.loginGradientStart,
              //       offset: Offset(1.0, 6.0),
              //       blurRadius: 20.0,
              //     ),
              //     BoxShadow(
              //       color: Theme.Colors.loginGradientEnd,
              //       offset: Offset(1.0, 6.0),
              //       blurRadius: 20.0,
              //     ),
              //   ],
              //   gradient: new LinearGradient(
              //       colors: [
              //         Theme.Colors.loginGradientEnd,
              //         Theme.Colors.loginGradientStart
              //       ],
              //       begin: const FractionalOffset(0.2, 0.2),
              //       end: const FractionalOffset(1.0, 1.0),
              //       stops: [0.0, 1.0],
              //       tileMode: TileMode.clamp),
              // ),
              child: MaterialButton(
                // highlightColor: Colors.transparent,
                // splashColor: Theme.Colors.loginGradientEnd,
                color: Theme.Colors.loginGradientEnd,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 42.0),
                  child: Text(
                    "Add your first photo",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
                onPressed: () async {
                  await getImage();
                  //showInSnackBar("Login button pressed");
                  // Navigate.pushPageReplacement(context, HomePage());
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Center(
              child: _image == null
                  ? Text('No image selected.')
                  : Text('Image selected.'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            animatedTextSmall(text: ["Your current city"]),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: SelectState(
                onCountryChanged: (value) {
                  setState(() {
                    countryValue = value;
                    current_country = countryValue;
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    stateValue = value;
                    current_state = stateValue;
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    cityValue = value;
                    current_city = cityValue;
                  });
                },
              ),
            ),
            // gradientTextField(
            //     hintText: "Your current residing city...",
            //     onSubmitted: (text) => bio = text),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            animatedTextSmall(text: ["Say something about yourself!"]),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            gradientTextField(
                hintText: "Your bio...", onSubmitted: (text) => bio = text),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            // animatedTextSmall(text: ["Do you smoke?"]),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            // gradientButton(
            //     buttons: ["Frequently", "Socially", "Rarely", "Never"]),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            // animatedTextSmall(text: ["Do you drink?"]),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            // gradientButton(
            //     buttons: ["Frequently", "Socially", "Rarely", "Never"]),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            // animatedTextSmall(text: ["Hobbies"]),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            // gradientButton(buttons: hobbies.sublist(0, 11)),
          ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: ClampingScrollPhysics(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height >= 1000.0
            ? MediaQuery.of(context).size.height
            : 1000.0,
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [Theme.Colors.background, Theme.Colors.background],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            SafeArea(
              child: animatedText(
                text: [
                  "You are almost there!",
                  "Share your first photo and talk about yourself!",
                ],
                onFinished: () {
                  setState(() {
                    isFinished = true;
                  });
                },
              ),
            ),
            buildWidgets(),
          ],
        ),
      ),
    ));
  }
}
