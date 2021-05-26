import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:save_ai/data/users.dart';
import 'package:save_ai/ui/register_pages/register_page_five.dart';
import 'package:save_ai/utils/router.dart';
import 'package:save_ai/widget/intro_view.dart';
import 'package:save_ai/ui/register_pages/register_page_one.dart';
import 'package:save_ai/ui/register_pages/register_page_two.dart';
import 'package:save_ai/ui/register_pages/register_page_three.dart';
import 'package:save_ai/ui/register_pages/register_page_four.dart';
import 'package:save_ai/model/user.dart' as U;

import 'main_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

getRec() async {
  Response response;
  Dio dio = new Dio();
  response = await dio.get(
      "https://save-ai-api-staging.herokuapp.com/api/db/func/recommendation?external_user_id=$UserID");
  List rep = response.data["response"];
  print(rep.length);
  Users = List.generate(
      rep.length,
      (index) => U.User(
          uid: rep[index]["user_id"],
          name: rep[index]["display_name"],
          designation: rep[index]["profession_name"],
          ai: rep[index]["ai"],
          bio: '',
          age: rep[index]["age"],
          imgUrl: rep[index]["pictures"][0],
          location: ''));
}

getUser() async {
  Response response;
  Dio dio = new Dio();
  response = await dio.get(
      "https://save-ai-api-staging.herokuapp.com/api/db/v_user?external_user_id=$UserID");
  User_Info = response.data["response"]["data"][0];
  UserID_Internal = response.data["response"]["data"][0]["user_id"];
  print(UserID_Internal);
}

addUser() async {
  var formData = {
    "external_user_id": UserID,
    "display_name": Reg_Name,
    "first_name": "first name",
    "last_name": "last name",
    // "phone": "4253999992",
    "email": Reg_Email,
    "pictures": [
      "https://www.winhelponline.com/blog/wp-content/uploads/2017/12/user.png"
    ],
    "location": {"lat": 30.2918842, "long": -81.3927381},
    "location_city_id": 2,
    "height": 5.5,
    "goal_id": goal,
    "interest_ids": interests,
    "love_language_ids": [love_language_pri, love_language_sec],
    "job_title": "SDE",
    "employer": "MS",
    "verified": false,
    "age": 25,
    "gender": gender,
    "user_status": "active",
    "birth_date": birth_date,
    "birth_time": birth_time,
    "birth_city_id": 1,
    "birth_city": "${birth_country}_${birth_state}_${birth_city}",
    "location_city": "${current_country}_${current_state}_${current_city}",
    "education_id": education,
    "profession_id": profession,
    "religion_id": religion,
    "ethnicity_id": ethnicity,
    "kids_id": kids,
    "description": bio,
    "meta": {"meta": "json data1"}
  };

  try {
    Response response;
    Dio dio = new Dio();
    print('{$birth_country}_{$birth_state}_{$birth_city}');
    response = await dio.post(
        "https://save-ai-api-staging.herokuapp.com/api/db/user",
        data: formData);

    UserID_Internal = response.data["response"][0]["user_id"];
    print(UserID_Internal);

    print('Register successfully.');
  } on DioError catch (e) {
    print("Register failed.");
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx and is also not 304.
    if (e.response != null) {
      print(e.response.data);
      //print(e.response.headers);
      //print(e.response.request);
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      print(e.request);
      print(e.message);
    }
  }
}

class RegisterPageState extends State<RegisterPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return IntroView(
      pages: <Widget>[
        RegisterPageOne(),
        RegisterPageFour(),
        RegisterPageTwo(),
        RegisterPageFive(),
        RegisterPageThree()
      ],
      onIntroCompleted: () async {
        await addUser();
        await getUser();
        await getRec();
        Navigate.pushPageReplacement(context, HomePage());
      },
    );
  }
}
