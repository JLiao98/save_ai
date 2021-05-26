import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:save_ai/data/users.dart';
import 'package:save_ai/style/theme.dart' as Theme;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:city_pickers/city_pickers.dart';

class RegisterPageOne extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPageOne>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isFinished = false;
  String _bd;
  String _bt;
  String _city;
  bool _bd_selected = false;
  bool _bt_selected = false;
  bool _city_selected = false;

  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
          textStyle: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
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
          textStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          repeatForever: false,
        ));
  }

  // Widget buildTextFields() {
  //
  //   return ;
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height >= 775.0
            ? MediaQuery.of(context).size.height
            : 775.0,
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
                  "Change your gender, birth date, birth time, and birth place.",
                ],
                onFinished: () {
                  setState(() {
                    isFinished = true;
                  });
                },
              ),
            ),
            !isFinished
                ? SizedBox(height: 0)
                : Column(children: [
                    GroupButton(
                      isRadio: true,
                      spacing: 10,
                      onSelected: (index, isSelected) =>
                          gender = index == 0 ? "male" : "female",
                      buttons: Gender,
                      selectedTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white70,
                      ),
                      unselectedTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                      selectedColor: Theme.Colors.loginGradientEnd,
                      unselectedColor: Colors.white70,
                      selectedShadow: <BoxShadow>[
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
                      unselectedShadow: <BoxShadow>[
                        BoxShadow(color: Colors.transparent)
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    animatedTextSmall(text: ["What is your goal?"]),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    GroupButton(
                      isRadio: true,
                      spacing: 10,
                      onSelected: (index, isSelected) => goal = index + 1,
                      buttons: List.generate(Goal.length, (index) => Goal[index]["goal_name"]),
                      selectedTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white70,
                      ),
                      unselectedTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                      selectedColor: Theme.Colors.loginGradientEnd,
                      unselectedColor: Colors.white70,
                      selectedShadow: <BoxShadow>[
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
                      unselectedShadow: <BoxShadow>[
                        BoxShadow(color: Colors.transparent)
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                      child: MaterialButton(
                        highlightColor: Colors.transparent,
                        splashColor: Theme.Colors.loginGradientEnd,
                        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 42.0),
                          child: !_bd_selected
                              ? Text("Your birth date...",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15.0))
                              : Text(_bd,
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15.0)),
                        ),
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(1900, 1, 1, 0, 0),
                              maxTime: DateTime.now(), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            print('confirm $date');
                            setState(() {
                              _bd = date.toString().substring(0, 10);
                              birth_date = _bd;
                              _bd_selected = true;
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                      child: MaterialButton(
                        highlightColor: Colors.transparent,
                        splashColor: Theme.Colors.loginGradientEnd,
                        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 42.0),
                          child: !_bt_selected
                              ? Text(
                                  "Your birth time...",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15.0),
                                )
                              : Text(
                                  _bt,
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15.0),
                                ),
                        ),
                        onPressed: () {
                          DatePicker.showTime12hPicker(context,
                              showTitleActions: true, onChanged: (time) {
                            print('change $time in time zone ' +
                                time.timeZoneOffset.inHours.toString());
                          }, onConfirm: (time) {
                            print('confirm $time');
                            setState(() {
                              _bt = time.toString().substring(11, 16);
                              birth_time = _bt;
                              _bt_selected = true;
                            });
                          }, currentTime: DateTime.now());
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                      child: MaterialButton(
                        highlightColor: Colors.transparent,
                        splashColor: Theme.Colors.loginGradientEnd,
                        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 42.0),
                          child: !_city_selected
                              ? Text(
                                  "Your birth place...",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15.0),
                                )
                              : Text(
                                  _city,
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15.0),
                                ),
                        ),
                        onPressed: () async {
                          Result result = await CityPickers.showCityPicker(
                            theme: ThemeData(),
                            context: context,
                          );
                          setState(() {
                            _city =
                                "${result.provinceName} ${result.cityName} ${result.areaName}";
                            _city_selected = true;
                            Global_tags[2] = result.cityName;
                          });
                        },
                      ),
                    ),
                    // gradientTextField(
                    //     hintText: "Your birthplace...",
                    //     onSubmitted: (text) {
                    //       print(text);
                    //     }),
                  ]),
          ],
        ),
      ),
    );
  }
}
