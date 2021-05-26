import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:save_ai/data/users.dart';
import 'package:save_ai/style/theme.dart' as Theme;
import 'package:animated_text_kit/animated_text_kit.dart';

class RegisterPageFour extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPageFour>
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
          textStyle:  GoogleFonts.asul(fontSize: 25,fontWeight: FontWeight.normal,color: Color(0xFF343d8f)),
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
          textStyle:  GoogleFonts.asul(fontSize: 15,fontWeight: FontWeight.normal,color: Color(0xFF343d8f)),
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
    // final education = [
    //   "Some High School",
    //   "High School Diploma",
    //   "Some College",
    //   "Associate Degree",
    //   "Bachelor's Degree",
    //   "Master's Degree",
    //   "Doctoral's Degree",
    //   "Professional Degree",
    //   "Other"
    // ];
    //
    // final profession = [
    //   "Government",
    //   "Health & Medicine",
    //   "Law & Public Policy",
    //   "Entertainment",
    //   "Engineering",
    //   "Science & Technology",
    //   "Arts & Culture",
    //   "Architecture",
    //   "Farming & Forestry",
    //   "Social Service",
    //   "Education",
    //   "Installation & Repair",
    //   "Sales",
    //   "Business & Finance",
    //   "Other"
    // ];

    return !isFinished
        ? SizedBox(height: 0)
        : Column(children: [
            // SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            // Container(
            //   decoration: new BoxDecoration(
            //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
            //     boxShadow: <BoxShadow>[
            //       BoxShadow(
            //         color: Theme.Colors.loginGradientStart,
            //         offset: Offset(1.0, 6.0),
            //         blurRadius: 20.0,
            //       ),
            //       BoxShadow(
            //         color: Theme.Colors.loginGradientEnd,
            //         offset: Offset(1.0, 6.0),
            //         blurRadius: 20.0,
            //       ),
            //     ],
            //     gradient: new LinearGradient(
            //         colors: [
            //           Theme.Colors.loginGradientEnd,
            //           Theme.Colors.loginGradientStart
            //         ],
            //         begin: const FractionalOffset(0.2, 0.2),
            //         end: const FractionalOffset(1.0, 1.0),
            //         stops: [0.0, 1.0],
            //         tileMode: TileMode.clamp),
            //   ),
            //   child: MaterialButton(
            //     highlightColor: Colors.transparent,
            //     splashColor: Theme.Colors.loginGradientEnd,
            //     //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(
            //           vertical: 10.0, horizontal: 42.0),
            //       child: Text(
            //         "Add your first photo",
            //         style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 18.0,
            //             fontFamily: "WorkSansBold"),
            //       ),
            //     ),
            //     onPressed: () {
            //       //showInSnackBar("Login button pressed");
            //       // Navigate.pushPageReplacement(context, HomePage());
            //     },
            //   ),
            // ),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            animatedTextSmall(text: ["Education"]),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            gradientButton(
                onSelected: (index, isSelected) {
                  education = index + 1;
                },
                buttons: List.generate(Education.length, (index) => Education[index]["education_name"])),
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            animatedTextSmall(text: ["Profession"]),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            gradientButton(
                onSelected: (index, isSelected) {
                  profession = index + 1;
                },
                buttons: List.generate(Profession.length, (index) => Profession[index]["profession_name"])),
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
                  "What are your educational and professional background?",
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
