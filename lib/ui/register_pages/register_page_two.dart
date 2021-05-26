import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:save_ai/data/users.dart';
import 'package:save_ai/style/theme.dart' as Theme;
import 'package:animated_text_kit/animated_text_kit.dart';

class RegisterPageTwo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPageTwo>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool isFinished = false;

  Widget gradientTextField({String hintText, onSubmitted}) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.Colors.loginGradientStart,
              offset: Offset(1.0, 6.0),
              blurRadius: 20.0,
            ),
            BoxShadow(
              color: Theme.Colors.loginGradientEnd,
              offset: Offset(1.0, 6.0),
              blurRadius: 20.0,
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
          textInputAction: TextInputAction.next,
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 22.0,
              color: Colors.white70,
            ),
          ),
          maxLines: 1,
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
          textStyle: GoogleFonts.asul(fontSize: 25,fontWeight: FontWeight.normal,color: Color(0xFF343d8f)),
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
          textStyle: GoogleFonts.asul(fontSize: 15,fontWeight: FontWeight.normal,color: Color(0xFF343d8f)),
          textAlign: TextAlign.center,
          repeatForever: false,
        ));
  }

  Widget gradientButton({onSelected(index, isSelected), List<String> buttons}) {
    return GroupButton(
      isRadio: true,
      spacing: 10,
      onSelected: onSelected,
      buttons: buttons,
      selectedTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: Colors.white,
      ),
      unselectedTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: Colors.grey[600],
      ),
      selectedColor: Theme.Colors.loginGradientEnd,
      unselectedColor: Colors.white,
      // selectedShadow: <BoxShadow>[
      //   BoxShadow(
      //     color: Theme.Colors.loginGradientStart,
      //     offset: Offset(1.0, 6.0),
      //     blurRadius: 20.0,
      //   ),
      //   BoxShadow(
      //     color: Theme.Colors.loginGradientEnd,
      //     offset: Offset(1.0, 6.0),
      //     blurRadius: 20.0,
      //   ),
      // ],
      // unselectedShadow: <BoxShadow>[BoxShadow(color: Colors.transparent)],
    );
  }

  Widget buildButtons() {
    // final religion = [
    //   "Agnostic",
    //   "Atheist",
    //   "Buddhist",
    //   "Christian",
    //   "Hindu",
    //   "Jain",
    //   "Jewish",
    //   "Muslim",
    //   "Zoroastrian",
    //   "Sikh",
    //   "Spiritual",
    //   "Other"
    // ];
    //
    // final ethnicity = [
    //   "Asian",
    //   "Black",
    //   "Latino",
    //   "White",
    //   "Native American",
    //   "Middle Eastern",
    //   "Pacific Islander",
    //   "African",
    //   "Caribbean",
    //   "Mixed",
    //   "Other",
    // ];
    //
    // final kids = ["Want", "Have", "Maybe", "Never"];


    return !isFinished
        ? SizedBox(height: 0)
        : Column(children: [
            animatedTextSmall(text: ["Religion"]),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            gradientButton(
                onSelected: (index, isSelected) {
                  religion = index + 1;
                },
                buttons: List.generate(Religion.length, (index) => Religion[index]["religion_name"])),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            animatedTextSmall(text: ["Ethnicity"]),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            gradientButton(
                onSelected: (index, isSelected) {
                  ethnicity = index + 1;
                },
                buttons: List.generate(Ethnicity.length, (index) => Ethnicity[index]["ethnicity_name"])),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            animatedTextSmall(text: ["Kids"]),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            gradientButton(
                onSelected: (index, isSelected) {
                  kids = index + 1;
                },
                buttons: List.generate(Kids.length, (index) => Kids[index]["kids_name"])),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            // animatedTextSmall(text: ["Eye color"]),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            // gradientButton(buttons: [
            //   "Amber",
            //   "Blue",
            //   "Brown",
            //   "Gray",
            //   "Green",
            //   "Hazel",
            //   "Other"
            // ]),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            // animatedTextSmall(text: ["Body type"]),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            // gradientButton(buttons: [
            //   "Toned",
            //   "Average",
            //   "Large",
            //   "Muscular",
            //   "Slim",
            //   "Stocky",
            //   "Other"
            // ]),
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
                  "What are your religion, ethnicity and kids status?",
                ],
                onFinished: () {
                  setState(() {
                    isFinished = true;
                  });
                },
              ),
            ),
            buildButtons(),
          ],
        ),
      ),
    ));
  }
}
